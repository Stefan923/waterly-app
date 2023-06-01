package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserSettingsRequest {

    private String userId;
    private float defaultLiquidsConsumption;
    private float defaultCaloriesConsumption;
    private boolean gesturesDetection;

}
