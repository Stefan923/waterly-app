package me.stefan923.waterly.repository;

import me.stefan923.waterly.entity.Consumption;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.math.BigInteger;

public interface ConsumptionRepository extends MongoRepository<Consumption, BigInteger> {

    Page<Consumption> findAllByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);

}
