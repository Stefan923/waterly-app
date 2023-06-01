package me.stefan923.waterly.repository;

import me.stefan923.waterly.entity.UserAccount;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserAccountRepository extends MongoRepository<UserAccount, String> {

    Optional<UserAccount> findByEmailIsLike(String email);
    Optional<UserAccount> findById(String id);

}
