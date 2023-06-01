package me.stefan923.waterly.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigInteger;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@Document("consumptions")
@RequiredArgsConstructor
@AllArgsConstructor
public class Consumption {

    @Id
    private BigInteger id;
    private String userId;
    private ConsumptionType consumptionType;
    private ConsumptionStatus consumptionStatus;
    private float quantity;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

}
