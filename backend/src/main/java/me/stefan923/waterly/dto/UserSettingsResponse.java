package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.ScheduleSettings;
import me.stefan923.waterly.entity.UserSettings;

@Getter
@Setter
public class UserSettingsResponse {

    private int defaultLiquidsConsumption;
    private int defaultCaloriesConsumption;
    private int dailyLiquidsConsumptionTarget;
    private int dailyCaloriesConsumptionTarget;
    private int dailyLiquidsConsumptions;
    private int dailyCaloriesConsumptions;
    private boolean gesturesDetection;
    private boolean developerMode;
    private ScheduleSettings scheduleSettings;

    public UserSettingsResponse(UserSettings userSettings) {
        this.defaultLiquidsConsumption = userSettings.getDefaultLiquidsConsumption();
        this.defaultCaloriesConsumption = userSettings.getDefaultCaloriesConsumption();
        this.dailyLiquidsConsumptionTarget = userSettings.getDailyLiquidsConsumptionTarget();
        this.dailyCaloriesConsumptionTarget = userSettings.getDailyCaloriesConsumptionTarget();
        this.dailyLiquidsConsumptions = userSettings.getDailyLiquidsConsumptions();
        this.dailyCaloriesConsumptions = userSettings.getDailyCaloriesConsumptions();
        this.gesturesDetection = userSettings.isGesturesDetection();
        this.developerMode = userSettings.isDeveloperMode();
        this.scheduleSettings = userSettings.getScheduleSettings();
    }

}
