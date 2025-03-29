package me.stefan923.waterly.repository;

import me.stefan923.waterly.entity.Consumption;
import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.entity.ConsumptionType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface ConsumptionRepository extends MongoRepository<Consumption, String> {
    Page<Consumption> findAllByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);
    Page<Consumption> findAllByUserIdAndConsumptionStatus(String userId, ConsumptionStatus consumptionStatus,
                                                          Pageable pageable);

    @Query("{ userId: { $eq: ?0 }, createdAt: { $gte: ?1, $lt: ?2 } }")
    Page<Consumption> findByUserIdAndCreationDate(String userId, LocalDateTime startDate,
                                                  LocalDateTime endDate, Pageable pageable);

    @Query("{ userId: { $eq: ?0 }, consumptionType: { $eq: ?1 }, modifiedAt: { $gte: ?2, $lt: ?3 } }")
    List<Consumption> findByUserIdAndModificationDate(String userId, ConsumptionType type, LocalDateTime startDate,
                                                      LocalDateTime endDate);
}
