package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.*;

import java.util.Optional;

public interface UserAccountService {

    Optional<UserAccountResponse> getByEmail(String email);
    UserTokenResponse login(UserAccountLogin userAccountLogin) throws Exception;
    Optional<UserAccountResponse> save(UserAccountRequest userAccountRequest) throws Exception;
    void delete(String id) throws Exception;
    String generateConfirmCode(String email) throws  Exception;
    UserTokenResponse confirmEmail(UserAccountConfirmation userAccountConfirmation) throws Exception;
    void validateEmail(String email) throws Exception;

}
