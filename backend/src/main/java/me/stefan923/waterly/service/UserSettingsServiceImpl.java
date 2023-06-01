package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserSettingsRequest;
import me.stefan923.waterly.dto.UserSettingsResponse;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.entity.UserSettings;
import me.stefan923.waterly.repository.UserSettingsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class UserSettingsServiceImpl implements UserSettingsService {

    private final MongoTemplate mongoTemplate;
    private final UserSettingsRepository userSettingsRepository;

    @Autowired
    public UserSettingsServiceImpl(MongoTemplate mongoTemplate, UserSettingsRepository userSettingsRepository) {
        this.mongoTemplate = mongoTemplate;
        this.userSettingsRepository = userSettingsRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<UserSettingsResponse> getByUserAccountId(String id) {
        return userSettingsRepository.findByUserId(id).map(UserSettingsResponse::new);
    }

    @Override
    @Transactional
    public Optional<UserSettingsResponse> save(UserSettingsRequest userSettingsRequest) throws Exception {
        String userId = userSettingsRequest.getUserId();

        if (!isUserIdUnique(userId)) {
            throw new Exception("This user id has already been used.");
        }

        if (!doesUserIdExist(userId)) {
            throw new Exception("This user id is not associated to an account.");
        }

        try {
            return Optional.of(userSettingsRepository.save(UserSettings.builder()
                    .userId(userId)
                    .defaultLiquidsConsumption(userSettingsRequest.getDefaultLiquidsConsumption())
                    .defaultCaloriesConsumption(userSettingsRequest.getDefaultCaloriesConsumption())
                    .gesturesDetection(userSettingsRequest.isGesturesDetection())
                    .build()
            )).map(UserSettingsResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public Optional<UserSettingsResponse> update(UserSettingsRequest userSettingsRequest) throws Exception {
        String userId = userSettingsRequest.getUserId();

        UserSettings userSettings = userSettingsRepository.findByUserId(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));

        return Optional.of(userSettingsRepository.save(UserSettings.builder()
                .id(userSettings.getId())
                .userId(userId)
                .defaultLiquidsConsumption(userSettingsRequest.getDefaultLiquidsConsumption())
                .defaultCaloriesConsumption(userSettingsRequest.getDefaultCaloriesConsumption())
                .gesturesDetection(userSettingsRequest.isGesturesDetection())
                .build()
        )).map(UserSettingsResponse::new);
    }

    @Override
    @Transactional
    public void delete(String userId) throws Exception {
        UserSettings userSettings = userSettingsRepository.findByUserId(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));

        userSettingsRepository.delete(userSettings);
    }

    @Transactional(readOnly = true)
    boolean isUserIdUnique(String userId) {
        if (userId == null) {
            return false;
        }

        Query query = new Query();
        query.addCriteria(Criteria.where("userId").is(userId));
        UserSettings userSettings = mongoTemplate.findOne(query, UserSettings.class);

        return userSettings == null;
    }

    @Transactional(readOnly = true)
    boolean doesUserIdExist(String userId) {
        return mongoTemplate.exists(Query.query(Criteria.where("id").is(userId)), UserAccount.class);
    }

}
