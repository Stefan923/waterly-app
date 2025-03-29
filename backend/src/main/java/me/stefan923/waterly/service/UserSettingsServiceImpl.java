package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserInfoRequest;
import me.stefan923.waterly.dto.UserSettingsRequest;
import me.stefan923.waterly.dto.UserSettingsResponse;
import me.stefan923.waterly.entity.GenderType;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.entity.UserSettings;
import me.stefan923.waterly.repository.UserSettingsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
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
                    .dailyLiquidsConsumptionTarget(userSettingsRequest.getDailyLiquidsConsumptionTarget())
                    .dailyCaloriesConsumptionTarget(userSettingsRequest.getDailyCaloriesConsumptionTarget())
                    .dailyLiquidsConsumptions(userSettingsRequest.getDailyLiquidsConsumptions())
                    .dailyCaloriesConsumptions(userSettingsRequest.getDailyCaloriesConsumptions())
                    .gesturesDetection(userSettingsRequest.isGesturesDetection())
                    .developerMode(userSettingsRequest.isDeveloperMode())
                    .scheduleSettings(userSettingsRequest.getScheduleSettings())
                    .build()
            )).map(UserSettingsResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public Optional<UserSettingsResponse> saveDefaultUserSettings(String userId, UserInfoRequest userInfoRequest) throws Exception {
        if (!isUserIdUnique(userId)) {
            throw new Exception("This user id has already been used.");
        }

        if (!doesUserIdExist(userId)) {
            throw new Exception("This user id is not associated to an account.");
        }

        try {
            UserSettings userSettings = setRecommendedQuantities(UserSettings.getDefaultUserSettings(userId),
                    userInfoRequest);
            return Optional.of(userSettingsRepository.save(
                    userSettings
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
                .dailyLiquidsConsumptionTarget(userSettingsRequest.getDailyLiquidsConsumptionTarget())
                .dailyCaloriesConsumptionTarget(userSettingsRequest.getDailyCaloriesConsumptionTarget())
                .dailyLiquidsConsumptions(userSettingsRequest.getDailyLiquidsConsumptions())
                .dailyCaloriesConsumptions(userSettingsRequest.getDailyCaloriesConsumptions())
                .gesturesDetection(userSettingsRequest.isGesturesDetection())
                .developerMode(userSettingsRequest.isDeveloperMode())
                .scheduleSettings(userSettingsRequest.getScheduleSettings())
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
    public boolean isUserIdUnique(String userId) {
        if (userId == null) {
            return false;
        }

        Query query = new Query();
        query.addCriteria(Criteria.where("userId").is(userId));
        UserSettings userSettings = mongoTemplate.findOne(query, UserSettings.class);

        return userSettings == null;
    }

    @Transactional(readOnly = true)
    public boolean doesUserIdExist(String userId) {
        return mongoTemplate.exists(Query.query(Criteria.where("id").is(userId)), UserAccount.class);
    }

    private UserSettings setRecommendedQuantities(UserSettings userSettings, UserInfoRequest userInfo) {
        GenderType gender = userInfo.getGender();
        int age = Period.between(userInfo.getDateOfBirth(), LocalDate.now()).getYears();
        int calories;
        int liquids;

        if (gender == GenderType.MALE) {
            if (age >= 7 && age <= 8) {
                calories = 1600;
            } else if (age >= 9 && age <= 13) {
                calories = 2100;
            } else if (age >= 14 && age <= 18) {
                calories = 2600;
            } else if (age >= 19 && age <= 30) {
                calories = 2700;
            } else if (age >= 31 && age <= 60) {
                calories = 2600;
            } else {
                calories = 2300;
            }
            liquids = 3700;
        } else {
            if (age >= 7 && age <= 8) {
                calories = 1500;
            } else if (age >= 9 && age <= 13) {
                calories = 1800;
            } else if (age >= 14 && age <= 18) {
                calories = 2100;
            } else if (age >= 19 && age <= 30) {
                calories = 2100;
            } else if (age >= 31 && age <= 60) {
                calories = 1900;
            } else {
                calories = 1800;
            }
            liquids = 2700;
        }

        userSettings.setDailyLiquidsConsumptionTarget(liquids);
        userSettings.setDailyCaloriesConsumptionTarget(calories);
        return userSettings;
    }

}
