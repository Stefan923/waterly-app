package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.ConsumptionRequest;
import me.stefan923.waterly.dto.ConsumptionResponse;
import me.stefan923.waterly.dto.ConsumptionUpdateRequest;
import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.entity.ConsumptionType;

import java.math.BigInteger;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

public interface ConsumptionService {
    Map<String, Object> getAllByUserId(String userId, int page, int size) throws Exception;
    Map<String, Object> getAllByUserIdAndConsumptionStatus(String userId, ConsumptionStatus consumptionStatus,
                                                           int page, int size) throws Exception;
    Map<String, Object> getOrGenerateByUserIdForCurrentDay(String userId, int page, int size) throws Exception;
    Map<String, Object> getAllByUserIdAndCreationDate(String userId, ConsumptionType consumptionType,
                                                      LocalDate creationDate, int page, int size) throws Exception;
    Map<String, Object> getHourlyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                      ConsumptionType type, int page, int size) throws Exception;
    Map<String, Object> getDailyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                     ConsumptionType type, int page, int size) throws Exception;
    Map<String, Object> getWeeklyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                      ConsumptionType type, int page, int size) throws Exception;
    Optional<ConsumptionResponse> save(ConsumptionRequest consumptionRequest) throws Exception;
    Optional<ConsumptionResponse> update(String id, ConsumptionUpdateRequest consumptionRequest) throws Exception;
    void delete(String id) throws Exception;

}
