package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import me.stefan923.waterly.entity.ScheduleSettings;

@Getter
@Setter
@ToString
public class UserSettingsRequest {

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

}
