package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.entity.ConsumptionType;

@Getter
@Setter
@ToString
public class ConsumptionRequest {

    private String userId;
    private ConsumptionType consumptionType;
    private ConsumptionStatus consumptionStatus;
    private float quantity;

}
