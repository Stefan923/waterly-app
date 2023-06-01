package me.stefan923.waterly.repository;

import me.stefan923.waterly.entity.UserSettings;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.math.BigInteger;
import java.util.Optional;

public interface UserSettingsRepository extends MongoRepository<UserSettings, BigInteger> {

    Optional<UserSettings> findByUserId(String userId);

}
