package me.stefan923.waterly.notification;

import me.stefan923.waterly.entity.*;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Component
public class NotificationPlanner {
    private static final int MEAL_DURATION = 30;
    private static final int DRINK_DURATION = 0;
    private static final int DRINK_BEFORE_MEAL_INTERVAL = 10;
    private static final int DRINK_AFTER_MEAL_INTERVAL = 20;

    public List<Consumption> planNotifications(
            String userId,
            DayOfWeek targetDayOfWeek,
            TimeRange timeRange,
            int numMealNotifications,
            int numDrinkNotifications
    ) {
        List<Consumption> consumptions = new ArrayList<>();
        Time startTime = timeRange.getStartHour();
        Time endTime = timeRange.getEndHour();

        int availableMinutes = calculateAvailableMinutes(startTime, endTime);
        int minimumMinutes = ((numMealNotifications) * MEAL_DURATION
                + (numMealNotifications - 1) * DRINK_BEFORE_MEAL_INTERVAL
                + (numMealNotifications - 1) * DRINK_AFTER_MEAL_INTERVAL) + 60;

        if (minimumMinutes > availableMinutes) {
            throw new IllegalArgumentException("Not enough time available to plan needed notifications.");
        }

        List<Time> mealNotifications = planMealNotifications(startTime, endTime, numMealNotifications);
        List<Time> drinkNotifications = planDrinkNotifications(mealNotifications, numMealNotifications, numDrinkNotifications);
        mealNotifications.forEach(time -> {
            LocalDateTime notificationDateTime = computeLocalDateTime(targetDayOfWeek, time);
            consumptions.add(Consumption.builder()
                            .userId(userId)
                            .consumptionType(ConsumptionType.FOOD)
                            .consumptionStatus(ConsumptionStatus.NO_ENTRY)
                            .quantity(0).modifiedAt(notificationDateTime)
                            .createdAt(notificationDateTime).build());
        });
        drinkNotifications.forEach(time -> {
            LocalDateTime notificationDateTime = computeLocalDateTime(targetDayOfWeek, time);
            consumptions.add(Consumption.builder()
                    .userId(userId)
                    .consumptionType(ConsumptionType.LIQUID)
                    .consumptionStatus(ConsumptionStatus.NO_ENTRY)
                    .quantity(0).modifiedAt(notificationDateTime)
                    .createdAt(notificationDateTime).build());
        });

        return consumptions;
    }

    List<Time> planMealNotifications(Time startTime, Time endTime, int numMealNotifications) {
        List<Time> notificationTimes = new ArrayList<>();

        int availableMinutes = calculateAvailableMinutes(startTime, endTime) - 90;
        int eventSpacing = calculateEventSpacing(numMealNotifications, availableMinutes, MEAL_DURATION);

        Time actualStartTime = addMinutesToTime(startTime, 30);
        notificationTimes.add(actualStartTime);

        for (int i = 1; i < numMealNotifications; i++) {
            Time notificationTime = addMinutesToTime(notificationTimes.get(i - 1), eventSpacing + MEAL_DURATION);
            notificationTimes.add(notificationTime);
        }

        return notificationTimes;
    }

    List<Time> planDrinkNotifications(
            List<Time> mealNotificationTimes,
            int numMealNotifications,
            int numDrinkNotifications
    ) {
        List<Time> notificationTimes = new ArrayList<>();

        notificationTimes.add(subtractMinutesFromTime(mealNotificationTimes.get(0), DRINK_BEFORE_MEAL_INTERVAL));
        int intervalNotifications = (numDrinkNotifications - 2) / (numMealNotifications - 1);
        int remainingNotifications = (numDrinkNotifications - 2) % (numMealNotifications - 1);
        for (int i = 1; i < numMealNotifications; i++) {
            Time startTime = addMinutesToTime(mealNotificationTimes.get(i - 1), MEAL_DURATION + DRINK_AFTER_MEAL_INTERVAL);
            Time endTime = subtractMinutesFromTime(mealNotificationTimes.get(i), DRINK_BEFORE_MEAL_INTERVAL);

            int availableTime = calculateAvailableMinutes(startTime, endTime);
            int actualIntervalNotifications =
                    (i <= remainingNotifications) ? intervalNotifications + 1 : intervalNotifications;
            int eventSpacing = calculateEventSpacing(actualIntervalNotifications, availableTime, DRINK_DURATION);

            notificationTimes.add(startTime);
            Time notificationTime = startTime;
            for (int j = 1; j < actualIntervalNotifications; j++) {
                notificationTime = addMinutesToTime(notificationTime, eventSpacing);
                notificationTimes.add(notificationTime);
            }
        }

        if (numMealNotifications > 1) {
            notificationTimes.add(addMinutesToTime(mealNotificationTimes.get(numMealNotifications - 1),
                    MEAL_DURATION + DRINK_AFTER_MEAL_INTERVAL));
        }

        return notificationTimes;
    }

    private LocalDateTime computeLocalDateTime(DayOfWeek targetDayOfWeek, Time time) {
        LocalTime targetTime = LocalTime.of(time.getHour(), time.getMinute(), 0, 0);

        LocalDateTime currentDateTime = LocalDateTime.now();

        int daysToAdd = targetDayOfWeek.getValue() - currentDateTime.getDayOfWeek().getValue();
        if (daysToAdd < 0) {
            daysToAdd += 7;
        }

        return currentDateTime
                .plusDays(daysToAdd)
                .withHour(targetTime.getHour())
                .withMinute(targetTime.getMinute())
                .withSecond(0)
                .withNano(0);
    }

    private int calculateAvailableMinutes(Time startTime, Time endTime) {
        int startMinutes = (startTime.getHour() * 60) + startTime.getMinute();
        int endMinutes = (endTime.getHour() * 60) + endTime.getMinute();
        return endMinutes - startMinutes;
    }

    private int calculateEventSpacing(int numEvents, int availableMinutes, int eventDuration) {
        if (numEvents <= 1) {
            return 0;
        }

        int actualAvailableMinutes = availableMinutes - eventDuration * (numEvents - 1);
        return Math.max(1, actualAvailableMinutes / (numEvents - 1));
    }

    private Time addMinutesToTime(Time time, int minutes) {
        int hour = time.getHour();
        int minute = time.getMinute() + minutes;

        hour += minute / 60;
        minute = minute % 60;

        hour = hour % 24;

        return new Time(hour, minute);
    }

    private Time subtractMinutesFromTime(Time time, int minutes) {
        int hour = time.getHour();
        int minute = hour * 60 + time.getMinute() - minutes;

        hour = minute / 60;
        minute = minute % 60;

        hour = hour % 24;

        return new Time(hour, minute);
    }
}
