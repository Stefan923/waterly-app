package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserInfoRequest;
import me.stefan923.waterly.dto.UserInfoResponse;

import java.util.Optional;

public interface UserInfoService {

    Optional<UserInfoResponse> getByUserAccountId(String id);
    Optional<UserInfoResponse> save(UserInfoRequest userInfoRequest) throws Exception;
    Optional<UserInfoResponse> update(UserInfoRequest userInfoRequest) throws Exception;
    void delete(String userId) throws Exception;

}
