package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import me.stefan923.waterly.entity.Consumption;
import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.entity.ConsumptionType;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class ConsumptionResponse {

    private String id;
    private ConsumptionType consumptionType;
    private ConsumptionStatus consumptionStatus;
    private float quantity;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    public ConsumptionResponse(Consumption consumption) {
        this.id = consumption.getId();
        this.consumptionType = consumption.getConsumptionType();
        this.consumptionStatus = consumption.getConsumptionStatus();
        this.quantity = consumption.getQuantity();
        this.createdAt = consumption.getCreatedAt().withSecond(0).withNano(0);
        this.modifiedAt = consumption.getModifiedAt().withSecond(0).withNano(0);
    }

}
