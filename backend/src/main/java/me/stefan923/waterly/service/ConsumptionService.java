package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.ConsumptionRequest;
import me.stefan923.waterly.dto.ConsumptionResponse;

import java.math.BigInteger;
import java.util.Map;
import java.util.Optional;

public interface ConsumptionService {

    Map<String, Object> getAllByUserAccountId(String userId, int page, int size) throws Exception;
    Optional<ConsumptionResponse> save(ConsumptionRequest consumptionRequest) throws Exception;
    Optional<ConsumptionResponse> update(BigInteger id, ConsumptionRequest consumptionRequest) throws Exception;
    void delete(BigInteger id) throws Exception;

}
