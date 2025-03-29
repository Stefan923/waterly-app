package me.stefan923.waterly.entity;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class TimeRange {

    private static final int DEFAULT_START_HOUR = 7;
    private static final int DEFAULT_END_HOUR = 22;
    private static final int DEFAULT_MINUTE = 0;

    private Time startHour = new Time(DEFAULT_START_HOUR, DEFAULT_MINUTE);
    private Time endHour = new Time(DEFAULT_END_HOUR, DEFAULT_MINUTE);

}
