package me.stefan923.waterly.service;

import lombok.RequiredArgsConstructor;
import me.stefan923.waterly.dto.*;
import me.stefan923.waterly.entity.*;
import me.stefan923.waterly.notification.NotificationPlanner;
import me.stefan923.waterly.repository.ConsumptionRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ConsumptionServiceImpl implements ConsumptionService {
    private static final int MAX_PAGE_SIZE = 100;
    private final MongoTemplate mongoTemplate;
    private final ConsumptionRepository consumptionRepository;
    private final UserSettingsService userSettingsService;
    private final NotificationPlanner notificationPlanner;

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getAllByUserId(String userId, int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            Page<Consumption> consumptions = consumptionRepository.findAllByUserIdOrderByCreatedAtDesc(
                    userId,
                    PageRequest.of(page, size, Sort.by("createdAt").ascending())
            );

            return getResponseMap(consumptions);
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    public Map<String, Object> getAllByUserIdAndConsumptionStatus(String userId, ConsumptionStatus consumptionStatus,
                                                                  int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            Page<Consumption> consumptions = consumptionRepository.findAllByUserIdAndConsumptionStatus(
                    userId,
                    consumptionStatus,
                    PageRequest.of(page, size, Sort.by("createdAt").ascending())
            );

            return getResponseMap(consumptions);
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Map<String, Object> getOrGenerateByUserIdForCurrentDay(String userId, int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        LocalDateTime currentDateTime = LocalDateTime.now();
        try {
            LocalDateTime startOfDay = currentDateTime
                    .withHour(0).withMinute(0).withSecond(0).withNano(0);
            LocalDateTime nextDayStart = startOfDay.plusDays(1);

            Page<Consumption> consumptions = consumptionRepository.findByUserIdAndCreationDate(
                    userId,
                    startOfDay,
                    nextDayStart,
                    PageRequest.of(page, size, Sort.by("createdAt").ascending())
            );

            if (consumptions.isEmpty()) {
                consumptions = generateConsumptionsByUserId(userId, page, size);
            }

            boolean anyUpdated = updateExpiredConsumptions(consumptions.getContent());
            if (anyUpdated) {
                consumptions = consumptionRepository.findByUserIdAndCreationDate(
                        userId,
                        startOfDay,
                        nextDayStart,
                        PageRequest.of(page, size, Sort.by("createdAt").ascending())
                );
            }

            return getResponseMap(consumptions);
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getAllByUserIdAndCreationDate(
            String userId, ConsumptionType consumptionType, LocalDate creationDate, int page, int size
    ) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            LocalDateTime startOfDay = creationDate.atStartOfDay();
            LocalDateTime nextDayStart = creationDate.plusDays(1).atStartOfDay();

            Page<Consumption> consumptions = consumptionRepository.findByUserIdAndCreationDate(
                    userId,
                    startOfDay,
                    nextDayStart,
                    PageRequest.of(page, size, Sort.by("createdAt").ascending())
            );

            return getResponseMap(consumptions);
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Map<String, Object> getHourlyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                             ConsumptionType type, int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            LocalDateTime startOfDay = modificationDate.atStartOfDay();
            LocalDateTime nextDayStart = modificationDate.plusDays(1).atStartOfDay();

            List<Consumption> consumptions = consumptionRepository.findByUserIdAndModificationDate(
                    userId,
                    type,
                    startOfDay,
                    nextDayStart
            );

            List<IntervalConsumptionResponse> hourlyConsumptions = new ArrayList<>();
            for (int hour = 0; hour < 24; hour++) {
                final LocalDateTime startHour = startOfDay.plusHours(hour);
                final LocalDateTime endHour = startOfDay.plusHours(hour + 1);
                float quantity = (float) consumptions.stream()
                        .filter(consumption -> consumption.getModifiedAt().isAfter(startHour)
                                && consumption.getModifiedAt().isBefore(endHour)
                                || consumption.getModifiedAt().isEqual(startHour))
                        .map(Consumption::getQuantity)
                        .mapToDouble(Float::doubleValue)
                        .sum();
                hourlyConsumptions.add(new IntervalConsumptionResponse(startHour, quantity));
            }

            return getResponseMapHourly(convertListToPage(hourlyConsumptions, page, size));
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Map<String, Object> getDailyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                            ConsumptionType type, int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            LocalDateTime startOfWeek = modificationDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)).atStartOfDay();
            LocalDateTime startOfNextWeek = startOfWeek.plusDays(7);

            List<Consumption> consumptions = consumptionRepository.findByUserIdAndModificationDate(
                    userId,
                    type,
                    startOfWeek,
                    startOfNextWeek
            );

            List<IntervalConsumptionResponse> dailyConsumptions = new ArrayList<>();
            for (int day = 0; day < 7; day++) {
                final LocalDateTime startHour = startOfWeek.plusDays(day);
                final LocalDateTime endHour = startOfWeek.plusDays(day + 1);
                float quantity = (float) consumptions.stream()
                        .filter(consumption -> consumption.getModifiedAt().isAfter(startHour)
                                && consumption.getModifiedAt().isBefore(endHour)
                                || consumption.getModifiedAt().isEqual(startHour))
                        .map(Consumption::getQuantity)
                        .mapToDouble(Float::doubleValue)
                        .sum();
                dailyConsumptions.add(new IntervalConsumptionResponse(startHour, quantity));
            }

            return getResponseMapHourly(convertListToPage(dailyConsumptions, page, size));
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Map<String, Object> getWeeklyConsumptionByTypeAndModificationDate(String userId, LocalDate modificationDate,
                                                                             ConsumptionType type, int page, int size) throws Exception {
        if (size > MAX_PAGE_SIZE) {
            size = MAX_PAGE_SIZE;
        }

        try {
            LocalDateTime startOfMonth = modificationDate.withDayOfMonth(1).atStartOfDay();
            LocalDateTime startOfNextMonth = startOfMonth.plusMonths(1);

            List<Consumption> consumptions = consumptionRepository.findByUserIdAndModificationDate(
                    userId,
                    type,
                    startOfMonth,
                    startOfNextMonth
            );

            List<IntervalConsumptionResponse> dailyConsumptions = new ArrayList<>();
            for (int day = 0; day < YearMonth.of(startOfMonth.getYear(), startOfMonth.getMonth()).lengthOfMonth(); day++) {
                final LocalDateTime startHour = startOfMonth.plusDays(day);
                final LocalDateTime endHour = startOfMonth.plusDays(day + 1);
                float quantity = (float) consumptions.stream()
                        .filter(consumption -> consumption.getModifiedAt().isAfter(startHour)
                                && consumption.getModifiedAt().isBefore(endHour)
                                || consumption.getModifiedAt().isEqual(startHour))
                        .map(Consumption::getQuantity)
                        .mapToDouble(Float::doubleValue)
                        .sum();
                dailyConsumptions.add(new IntervalConsumptionResponse(startHour, quantity));
            }

            return getResponseMapHourly(convertListToPage(dailyConsumptions, page, size));
        } catch (Exception e) {
            throw new Exception("Couldn't execute given query.");
        }
    }

    @Override
    @Transactional
    public Optional<ConsumptionResponse> save(ConsumptionRequest consumptionRequest) throws Exception {
        String userId = consumptionRequest.getUserId();

        if (!doesUserIdExist(userId)) {
            throw new Exception("This user id is not associated to an account.");
        }

        try {
            LocalDateTime actualLocalDateTime = LocalDateTime.now();
            return Optional.of(consumptionRepository.save(Consumption.builder()
                    .userId(userId)
                    .consumptionType(consumptionRequest.getConsumptionType())
                    .consumptionStatus(consumptionRequest.getConsumptionStatus())
                    .quantity(consumptionRequest.getQuantity())
                    .createdAt(actualLocalDateTime)
                    .modifiedAt(actualLocalDateTime)
                    .build()
            )).map(ConsumptionResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public Optional<ConsumptionResponse> update(String id, ConsumptionUpdateRequest consumptionRequest) throws Exception {
        Consumption consumption = consumptionRepository.findById(id)
                .orElseThrow(() -> new Exception("This id is not associated to a consumption entry."));

        return Optional.of(consumptionRepository.save(Consumption.builder()
                .id(id)
                .userId(consumption.getUserId())
                .consumptionType(consumption.getConsumptionType())
                .consumptionStatus(consumptionRequest.getConsumptionStatus())
                .quantity(consumptionRequest.getQuantity())
                .createdAt(consumption.getCreatedAt())
                .modifiedAt(LocalDateTime.now())
                .build()
        )).map(ConsumptionResponse::new);
    }

    @Override
    @Transactional
    public void delete(String id) throws Exception {
        Consumption consumption = consumptionRepository.findById(id)
                .orElseThrow(() -> new Exception("This id is not associated to a consumption entry."));

        consumptionRepository.delete(consumption);
    }

    @Transactional
    public Page<Consumption> generateConsumptionsByUserId(String userId, int pageNumber, int pageSize) throws Exception {
        if (!doesUserIdExist(userId)) {
            throw new Exception("This user id is not associated to an account.");
        }

        DayOfWeek targetDayOfWeek = LocalDate.now().getDayOfWeek();
        UserSettingsResponse userSettings = userSettingsService.getByUserAccountId(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));
        TimeRange timeRange = userSettings.getScheduleSettings().getTimeRangeByDayOfWeek(targetDayOfWeek);
        int numDrinkNotifications = userSettings.getDailyLiquidsConsumptions();
        int numMealNotifications = userSettings.getDailyCaloriesConsumptions();

        List<Consumption> consumptions = notificationPlanner
                .planNotifications(userId, targetDayOfWeek, timeRange, numMealNotifications, numDrinkNotifications);

        return convertListToPage(consumptionRepository.saveAll(consumptions), pageNumber, pageSize);
    }

    @Transactional(readOnly = true)
    public boolean doesUserIdExist(String userId) {
        return mongoTemplate.exists(Query.query(Criteria.where("id").is(userId)), UserAccount.class);
    }

    private boolean updateExpiredConsumptions(List<Consumption> consumptions) {
        AtomicBoolean anyUpdated = new AtomicBoolean(false);
        LocalDateTime liquidLimitTime = LocalDateTime.now().minusMinutes(2);
        LocalDateTime mealLimitTime = LocalDateTime.now().minusMinutes(30);

        consumptions.stream().filter(consumption -> ConsumptionStatus.NO_ENTRY.equals(consumption.getConsumptionStatus())
                        && consumption.getCreatedAt().isBefore(
                                consumption.getConsumptionType() == ConsumptionType.LIQUID ? liquidLimitTime : mealLimitTime)
                ).forEach(consumption -> {
                    consumption.setConsumptionStatus(ConsumptionStatus.CANCELED);
                    consumptionRepository.save(consumption);
                    anyUpdated.set(true);
                });

        return anyUpdated.get();
    }

    private Map<String, Object> getResponseMap(Page<Consumption> consumptions) {
        Map<String, Object> consumptionsResponse = new HashMap<>();
        consumptionsResponse.put("consumptions", consumptions.getContent()
                .stream().map(ConsumptionResponse::new).collect(Collectors.toList()));
        consumptionsResponse.put("currentPage", consumptions.getNumber());
        consumptionsResponse.put("totalItems", consumptions.getTotalElements());
        consumptionsResponse.put("totalPages", consumptions.getTotalPages());

        return consumptionsResponse;
    }

    private Map<String, Object> getResponseMapHourly(Page<IntervalConsumptionResponse> consumptions) {
        Map<String, Object> consumptionsResponse = new HashMap<>();
        consumptionsResponse.put("consumptions", consumptions.getContent());
        consumptionsResponse.put("currentPage", consumptions.getNumber());
        consumptionsResponse.put("totalItems", consumptions.getTotalElements());
        consumptionsResponse.put("totalPages", consumptions.getTotalPages());

        return consumptionsResponse;
    }

    public static <T> Page<T> convertListToPage(List<T> consumptions, int pageNumber, int pageSize) {
        int startIndex = pageNumber * pageSize;
        int endIndex = Math.min(startIndex + pageSize, consumptions.size());
        List<T> sublist = consumptions.subList(startIndex, endIndex);

        return new PageImpl<>(sublist, PageRequest.of(pageNumber, pageSize), consumptions.size());
    }
}
