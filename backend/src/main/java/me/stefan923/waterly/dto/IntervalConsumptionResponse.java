package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class IntervalConsumptionResponse {

    private LocalDateTime time;
    private float quantity;

}
