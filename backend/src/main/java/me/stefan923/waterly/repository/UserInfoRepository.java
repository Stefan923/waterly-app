package me.stefan923.waterly.repository;

import me.stefan923.waterly.entity.UserInfo;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.math.BigInteger;
import java.util.Optional;

public interface UserInfoRepository extends MongoRepository<UserInfo, BigInteger> {
    Optional<UserInfo> findByUserId(String userId);
}
