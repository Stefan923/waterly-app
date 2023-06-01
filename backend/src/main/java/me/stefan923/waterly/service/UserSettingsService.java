package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserSettingsRequest;
import me.stefan923.waterly.dto.UserSettingsResponse;

import java.util.Optional;

public interface UserSettingsService {

    Optional<UserSettingsResponse> getByUserAccountId(String id);
    Optional<UserSettingsResponse> save(UserSettingsRequest userSettingsRequest) throws Exception;
    Optional<UserSettingsResponse> update(UserSettingsRequest userSettingsRequest) throws Exception;
    void delete(String userId) throws Exception;

}
