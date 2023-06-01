package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.ConsumptionRequest;
import me.stefan923.waterly.dto.ConsumptionResponse;
import me.stefan923.waterly.entity.Consumption;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.repository.ConsumptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ConsumptionServiceImpl implements ConsumptionService {

    private final MongoTemplate mongoTemplate;
    private final ConsumptionRepository consumptionRepository;

    @Autowired
    public ConsumptionServiceImpl(MongoTemplate mongoTemplate, ConsumptionRepository consumptionRepository) {
        this.mongoTemplate = mongoTemplate;
        this.consumptionRepository = consumptionRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getAllByUserAccountId(String userId, int page, int size) throws Exception {
        try {
            Page<Consumption> consumptions = consumptionRepository.findAllByUserIdOrderByCreatedAtDesc(
                    userId,
                    PageRequest.of(page, size)
            );

            Map<String, Object> consumptionsResponse = new HashMap<>();
            consumptionsResponse.put("consumptions", consumptions.getContent()
                    .stream().map(ConsumptionResponse::new).collect(Collectors.toList()));
            consumptionsResponse.put("currentPage", consumptions.getNumber());
            consumptionsResponse.put("totalItems", consumptions.getTotalElements());
            consumptionsResponse.put("totalPages", consumptions.getTotalPages());

            return consumptionsResponse;
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Optional<ConsumptionResponse> save(ConsumptionRequest consumptionRequest) throws Exception {
        String userId = consumptionRequest.getUserId();

        if (!doesUserIdExist(userId)) {
            throw new Exception("This user id is not associated to an account.");
        }

        try {
            LocalDateTime actualLocalDateTime = LocalDateTime.now();
            return Optional.of(consumptionRepository.save(Consumption.builder()
                    .userId(userId)
                    .consumptionType(consumptionRequest.getConsumptionType())
                    .consumptionStatus(consumptionRequest.getConsumptionStatus())
                    .quantity(consumptionRequest.getQuantity())
                    .createdAt(actualLocalDateTime)
                    .modifiedAt(actualLocalDateTime)
                    .build()
            )).map(ConsumptionResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public Optional<ConsumptionResponse> update(BigInteger id, ConsumptionRequest consumptionRequest) throws Exception {
        Consumption consumption = consumptionRepository.findById(id)
                .orElseThrow(() -> new Exception("This id is not associated to a consumption entry."));

        return Optional.of(consumptionRepository.save(Consumption.builder()
                .id(id)
                .userId(consumptionRequest.getUserId())
                .consumptionType(consumptionRequest.getConsumptionType())
                .consumptionStatus(consumptionRequest.getConsumptionStatus())
                .quantity(consumptionRequest.getQuantity())
                .createdAt(consumption.getCreatedAt())
                .modifiedAt(LocalDateTime.now())
                .build()
        )).map(ConsumptionResponse::new);
    }

    @Override
    @Transactional
    public void delete(BigInteger id) throws Exception {
        Consumption consumption = consumptionRepository.findById(id)
                .orElseThrow(() -> new Exception("This id is not associated to a consumption entry."));

        consumptionRepository.delete(consumption);
    }

    @Transactional(readOnly = true)
    boolean doesUserIdExist(String userId) {
        return mongoTemplate.exists(Query.query(Criteria.where("id").is(userId)), UserAccount.class);
    }

}
