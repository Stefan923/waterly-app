package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.UserSettings;

@Getter
@Setter
public class UserSettingsResponse {

    private float defaultLiquidsConsumption;
    private float defaultCaloriesConsumption;
    private boolean gesturesDetection;

    public UserSettingsResponse(UserSettings userSettings) {
        this.defaultLiquidsConsumption = userSettings.getDefaultLiquidsConsumption();
        this.defaultCaloriesConsumption = userSettings.getDefaultCaloriesConsumption();
        this.gesturesDetection = userSettings.isGesturesDetection();
    }

}
