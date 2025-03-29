package me.stefan923.waterly.service;

import lombok.RequiredArgsConstructor;
import me.stefan923.waterly.dto.*;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.entity.UserAccountType;
import me.stefan923.waterly.exception.NonEnabledAccountException;
import me.stefan923.waterly.exception.NonRegisteredAccountException;
import me.stefan923.waterly.repository.UserAccountRepository;
import me.stefan923.waterly.security.JwtAuthenticationUtil;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class UserAccountServiceImpl implements UserAccountService {
    private final MongoTemplate mongoTemplate;
    private final UserAccountRepository userAccountRepository;
    private final UserSettingsService userSettingsService;
    private final JwtAuthenticationUtil jwtAuthenticationUtil;
    private final Random random = new Random();

    @Override
    @Transactional(readOnly = true)
    public Optional<UserAccountResponse> getByEmail(String email) {
        return userAccountRepository.findByEmailIsLike(email).map(UserAccountResponse::new);
    }

    @Override
    @Transactional(readOnly = true)
    public UserTokenResponse login(UserAccountLogin userAccountLogin) throws Exception {
        UserAccountType userAccountType = userAccountLogin.getAccountType();
        if (userAccountType.equals(UserAccountType.CREDENTIALS)) {
            Optional<UserAccount> userAccountOptional = userAccountRepository.findByEmailIsLike(userAccountLogin.getEmail());
            if (userAccountOptional.isEmpty()) {
                throw new Exception("Incorrect email or password.");
            }

            UserAccount userAccount = userAccountOptional.get();
            if (userAccount.getPassword().equals(userAccountLogin.getPassword())) {
                if (userAccount.isEnabled()) {
                    return new UserTokenResponse(userAccount.getId(), jwtAuthenticationUtil.generateToken(userAccount));
                }
                throw new NonEnabledAccountException("Your account was not confirmed yet.");
            }
            throw new Exception("Incorrect email or password.");
        } else if (userAccountType.equals(UserAccountType.GOOGLE)) {
            Optional<UserAccount> userAccountOptional = userAccountRepository.findByEmailIsLike(userAccountLogin.getEmail());
            if (userAccountOptional.isEmpty()) {
                throw new NonRegisteredAccountException("There is no existing account with given email.");
            }

            UserAccount userAccount = userAccountOptional.get();
            if (userAccount.getAccountType().equals(UserAccountType.GOOGLE)) {
                if (userAccount.isEnabled()) {
                    return new UserTokenResponse(userAccount.getId(), jwtAuthenticationUtil.generateToken(userAccount));
                }
                throw new NonEnabledAccountException("Your account was not confirmed yet.");
            }
            throw new Exception("Wrong authentication method.");
        } else {
            throw new Exception("Authentication method not implemented.");
        }
    }

    @Override
    @Transactional
    public UserTokenResponse confirmEmail(UserAccountConfirmation userAccountConfirmation) throws Exception {
        Optional<UserAccount> userAccountOptional = userAccountRepository
                .findByEmailIsLike(userAccountConfirmation.getEmail());
        if (userAccountOptional.isEmpty()) {
            throw new Exception("Couldn't find an account with given email.");
        }

        UserAccount userAccount = userAccountOptional.get();
        if (userAccount.isEnabled()) {
            throw new Exception("Given account is already enabled.");
        }

        int confirmCode = userAccount.getConfirmCode();
        if (confirmCode == -1 || userAccount.getConfirmCode() != userAccountConfirmation.getConfirmCode()) {
            throw new Exception("Confirmation code is wrong.");
        }

        userAccount.setAccountEnabled(true);
        userAccountRepository.save(userAccount);

        return new UserTokenResponse(userAccount.getId(), jwtAuthenticationUtil.generateToken(userAccount));
    }

    @Override
    @Transactional(readOnly = true)
    public void validateEmail(String email) throws Exception {
        if (isEmailUnique(email)) {
            return;
        }
        throw new Exception("An account already uses this email. Try to sign in.");
    }

    @Override
    @Transactional
    public Optional<UserAccountResponse> save(UserAccountRequest userAccountRequest) throws Exception {
        UserAccountRegistration userAccountRegistration = userAccountRequest.getUserAccountRegistration();
        if (!isEmailUnique(userAccountRegistration.getEmail())) {
            throw new Exception("This email address has already been used.");
        }

        if (!userAccountRegistration.getAccountType().equals(UserAccountType.CREDENTIALS)) {
            userAccountRegistration.setPassword(generateRandomPassword());
        }

        try {
            UserAccount userAccount = userAccountRepository.save(UserAccount.builder()
                    .accountType(userAccountRegistration.getAccountType())
                    .email(userAccountRegistration.getEmail())
                    .password(userAccountRegistration.getPassword())
                    .confirmCode(-1)
                    .isAccountEnabled(false)
                    .isAccountEnabled(false)
                    .isPasswordExpired(false)
                    .isAccountLocked(false)
                    .build()
            );

            try {
                userSettingsService.saveDefaultUserSettings(userAccount.getId(), userAccountRequest.getUserInfoRequest());
            } catch (Exception e) {
                userAccountRepository.delete(userAccount);
                throw e;
            }

            return Optional.of(userAccount).map(UserAccountResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public void delete(String userId) throws Exception {
        UserAccount userAccount = userAccountRepository.findById(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));

        userAccountRepository.delete(userAccount);
    }

    @Override
    @Transactional
    public String generateConfirmCode(String email) throws Exception {
        Optional<UserAccount> userAccountOptional = userAccountRepository
                .findByEmailIsLike(email);
        if (userAccountOptional.isEmpty()) {
            throw new Exception("Couldn't find an account with given email.");
        }

        UserAccount userAccount = userAccountOptional.get();
        if (userAccount.isEnabled()) {
            throw new Exception("Given account is already enabled.");
        }

        userAccount.setConfirmCode(generateConfirmCode());
        userAccountRepository.save(userAccount);

        return String.valueOf(userAccount.getConfirmCode());
    }

    @Transactional(readOnly = true)
    public boolean isEmailUnique(String email) {
        if (email == null) {
            return false;
        }

        Query query = new Query();
        query.addCriteria(Criteria.where("email").is(email));
        UserAccount userAccount = mongoTemplate.findOne(query, UserAccount.class);

        return userAccount == null;
    }

    private int generateConfirmCode() {
        return random.nextInt(900000) + 100000;
    }

    private String generateRandomPassword() {
        int leftLimit = 48;
        int rightLimit = 122;
        int targetStringLength = 16;
        Random random = new Random();

        return random.ints(leftLimit, rightLimit + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }
}
