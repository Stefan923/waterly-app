package me.stefan923.waterly.entity;

import lombok.*;

import java.time.DayOfWeek;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleSettings {

    private TimeRange sunday = new TimeRange();
    private TimeRange monday = new TimeRange();
    private TimeRange tuesday = new TimeRange();
    private TimeRange wednesday = new TimeRange();
    private TimeRange thursday = new TimeRange();
    private TimeRange friday = new TimeRange();
    private TimeRange saturday = new TimeRange();

    public TimeRange getTimeRangeByDayOfWeek(DayOfWeek dayOfWeek) {
        return switch (dayOfWeek) {
            case SUNDAY -> sunday;
            case MONDAY -> monday;
            case TUESDAY -> tuesday;
            case WEDNESDAY -> wednesday;
            case THURSDAY -> thursday;
            case FRIDAY -> friday;
            case SATURDAY -> saturday;
        };
    }

}
