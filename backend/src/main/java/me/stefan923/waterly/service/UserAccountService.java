package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserAccountConfirmation;
import me.stefan923.waterly.dto.UserAccountLogin;
import me.stefan923.waterly.dto.UserAccountRegistration;
import me.stefan923.waterly.dto.UserAccountResponse;

import java.util.Optional;

public interface UserAccountService {

    Optional<UserAccountResponse> getByEmail(String email);
    String login(UserAccountLogin userAccountLogin) throws Exception;
    Optional<UserAccountResponse> save(UserAccountRegistration userAccountRegistration) throws Exception;
    void delete(String id) throws Exception;
    String generateConfirmCode(String email) throws  Exception;
    String confirmEmail(UserAccountConfirmation userAccountConfirmation) throws Exception;
    void validateEmail(String email) throws Exception;

}
