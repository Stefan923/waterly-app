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

    @Id
    private BigInteger id;
    private String userId;
    private float defaultLiquidsConsumption;
    private float defaultCaloriesConsumption;
    private boolean gesturesDetection;

}
