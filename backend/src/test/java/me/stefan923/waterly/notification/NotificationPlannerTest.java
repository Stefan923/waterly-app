package me.stefan923.waterly.notification;

import me.stefan923.waterly.entity.Consumption;
import me.stefan923.waterly.entity.Time;
import me.stefan923.waterly.entity.TimeRange;
import org.junit.jupiter.api.Test;

import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class NotificationPlannerTest {

    @Test
    void planNotifications_EnoughTimeAvailable_ReturnsListWithNotifications() {
        // Arrange
        NotificationPlanner notificationPlanner = new NotificationPlanner();
        String userId = "testUser";
        DayOfWeek targetDayOfWeek = DayOfWeek.MONDAY;
        TimeRange timeRange = new TimeRange(new Time(9, 0), new Time(18, 0));
        int numMealNotifications = 2;
        int numDrinkNotifications = 2;

        // Act
        List<Consumption> result = notificationPlanner.planNotifications(userId, targetDayOfWeek, timeRange, numMealNotifications, numDrinkNotifications);

        // Assert
        assertNotNull(result);
        assertEquals(4, result.size()); // 2 meal notifications + 2 drink notifications
    }

    @Test
    void planNotifications_NotEnoughTimeAvailable_ThrowsIllegalArgumentException() {
        // Arrange
        NotificationPlanner notificationPlanner = new NotificationPlanner();
        String userId = "testUser";
        DayOfWeek targetDayOfWeek = DayOfWeek.MONDAY;
        TimeRange timeRange = new TimeRange(new Time(9, 0), new Time(10, 0)); // Only 1 hour available
        int numMealNotifications = 2;
        int numDrinkNotifications = 2;

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->
                notificationPlanner.planNotifications(userId, targetDayOfWeek, timeRange, numMealNotifications, numDrinkNotifications));
    }

    @Test
    void planMealNotifications_ValidInput_ReturnsListWithMealNotifications() {
        // Arrange
        NotificationPlanner notificationPlanner = new NotificationPlanner();
        Time startTime = new Time(9, 0);
        Time endTime = new Time(18, 0);
        int numMealNotifications = 3;

        // Act
        List<Time> result = notificationPlanner.planMealNotifications(startTime, endTime, numMealNotifications);

        // Assert
        assertNotNull(result);
        assertEquals(3, result.size());
        assertEquals(new Time(9, 30), result.get(0));
        assertEquals(new Time(11, 30), result.get(1));
        assertEquals(new Time(13, 30), result.get(2));
    }

    @Test
    void planDrinkNotifications_ValidInput_ReturnsListWithDrinkNotifications() {
        // Arrange
        NotificationPlanner notificationPlanner = new NotificationPlanner();
        List<Time> mealNotificationTimes = new ArrayList<>();
        mealNotificationTimes.add(new Time(9, 30));
        mealNotificationTimes.add(new Time(11, 30));
        mealNotificationTimes.add(new Time(13, 30));
        int numMealNotifications = 3;
        int numDrinkNotifications = 4;

        // Act
        List<Time> result = notificationPlanner.planDrinkNotifications(mealNotificationTimes, numMealNotifications, numDrinkNotifications);

        // Assert
        assertNotNull(result);
        assertEquals(4, result.size());
        assertEquals(new Time(9, 20), result.get(0));
        assertEquals(new Time(10, 40), result.get(1));
        assertEquals(new Time(13, 20), result.get(2));
        assertEquals(new Time(14, 40), result.get(3));
    }

}