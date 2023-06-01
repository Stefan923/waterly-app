package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.Consumption;
import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.entity.ConsumptionType;

import java.math.BigInteger;
import java.time.LocalDateTime;

@Getter
@Setter
public class ConsumptionResponse {

    private BigInteger id;
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
        this.createdAt = consumption.getCreatedAt();
        this.modifiedAt = consumption.getModifiedAt();
    }

}
