package me.stefan923.waterly.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigInteger;

@Getter
@Setter
@Builder
@Document("user_settings")
@RequiredArgsConstructor
@AllArgsConstructor
public class UserSettings {

    private static final int DAILY_LIQUIDS_CONSUMPTIONS = 14;
    private static final int DAILY_CALORIES_CONSUMPTIONS = 3;

    @Id
    private BigInteger id;
    private String userId;
    private int defaultLiquidsConsumption;
    private int defaultCaloriesConsumption;
    private int dailyLiquidsConsumptionTarget;
    private int dailyCaloriesConsumptionTarget;
    private int dailyLiquidsConsumptions;
    private int dailyCaloriesConsumptions;
    private boolean gesturesDetection;
    private boolean developerMode;
    private ScheduleSettings scheduleSettings;

    public static UserSettings getDefaultUserSettings(String userId) {
        return UserSettings.builder()
                .userId(userId)
                .defaultLiquidsConsumption(150)
                .defaultCaloriesConsumption(300)
                .dailyLiquidsConsumptionTarget(2000)
                .dailyCaloriesConsumptionTarget(2000)
                .dailyLiquidsConsumptions(14)
                .dailyCaloriesConsumptions(3)
                .gesturesDetection(true)
                .developerMode(false)
                .scheduleSettings(new ScheduleSettings())
                .build();
    }

}
