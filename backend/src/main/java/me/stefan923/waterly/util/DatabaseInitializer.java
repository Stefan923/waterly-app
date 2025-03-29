package me.stefan923.waterly.util;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import me.stefan923.waterly.entity.*;
import me.stefan923.waterly.repository.ConsumptionRepository;
import me.stefan923.waterly.repository.UserAccountRepository;
import me.stefan923.waterly.repository.UserInfoRepository;
import me.stefan923.waterly.repository.UserSettingsRepository;
import org.springframework.stereotype.Component;

import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Component
@RequiredArgsConstructor
public final class DatabaseInitializer {
    public static final String USER_EMAIL = "admin@waterly.com";
    public static final String USER_PASSWORD = "Password0";

    private final UserAccountRepository userAccountRepository;
    private final UserSettingsRepository userSettingsRepository;
    private final UserInfoRepository userInfoRepository;
    private final ConsumptionRepository consumptionRepository;
    private final Random random = new Random();

    @PostConstruct
    public void initializeAdminAccount() {
        if (!isAdminAccountInitialized()) {
            String userId = createAdminUserAccount();
            createAdminUserSettings(userId);
            createAdminUserInfo(userId);
            createAdminConsumptions(userId);
        }
    }

    public boolean isAdminAccountInitialized() {
        Optional<UserAccount> userAccount = userAccountRepository.findByEmailIsLike(USER_EMAIL);
        return userAccount.isPresent();
    }

    private String createAdminUserAccount() {
        return userAccountRepository.save(UserAccount.builder()
                .accountType(UserAccountType.CREDENTIALS)
                .email(USER_EMAIL)
                .password(USER_PASSWORD)
                .confirmCode(-1)
                .isAccountEnabled(true)
                .isAccountExpired(false)
                .isAccountLocked(false)
                .build()).getId();
    }

    private BigInteger createAdminUserSettings(String userId) {
        return userSettingsRepository.save(UserSettings.getDefaultUserSettings(userId)).getId();
    }

    private BigInteger createAdminUserInfo(String userId) {
        return userInfoRepository.save(UserInfo.builder()
                .userId(userId)
                .firstName("Waterly")
                .lastName("Admin")
                .gender(GenderType.MALE)
                .dateOfBirth(LocalDate.now())
                .height(182)
                .weight(80)
                .build()).getId();
    }

    private void createAdminConsumptions(String userId) {
        int[] mealHours = new int[]{ 8, 13, 20 };
        for (int day = 149; day >= 0; day--) {
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay().minusDays(day);
            for (int hour = 0; hour < 24; hour++) {
                LocalDateTime consumptionTime = startOfDay.plusHours(hour);
                consumptionRepository.save(Consumption.builder()
                        .userId(userId)
                        .consumptionType(ConsumptionType.LIQUID)
                        .consumptionStatus(ConsumptionStatus.DONE)
                        .quantity(generateRandomNumber(80, 250))
                        .modifiedAt(consumptionTime)
                        .createdAt(consumptionTime)
                        .build());
            }

            for (int hour : mealHours) {
                LocalDateTime consumptionTime = startOfDay.plusHours(hour);
                consumptionRepository.save(Consumption.builder()
                        .userId(userId)
                        .consumptionType(ConsumptionType.FOOD)
                        .consumptionStatus(ConsumptionStatus.DONE)
                        .quantity(generateRandomNumber(450, 900))
                        .modifiedAt(consumptionTime)
                        .createdAt(consumptionTime)
                        .build());
            }
        }
    }

    public int generateRandomNumber(int lowerBound, int upperBound) {
        return random.nextInt(upperBound - lowerBound + 1) + lowerBound;
    }
}
