package me.stefan923.waterly.controller;

import me.stefan923.waterly.entity.ConsumptionStatus;
import me.stefan923.waterly.util.CsvFileWriterUtil;
import me.stefan923.waterly.dto.ConsumptionRequest;
import me.stefan923.waterly.dto.ConsumptionResponse;
import me.stefan923.waterly.dto.ConsumptionUpdateRequest;
import me.stefan923.waterly.entity.ConsumptionType;
import me.stefan923.waterly.service.ConsumptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/api/consumptions")
public class ConsumptionController {

    private final ConsumptionService consumptionService;
    private int iteration = 0;

    @Autowired
    public ConsumptionController(ConsumptionService consumptionService) {
        this.consumptionService = consumptionService;
    }

    @GetMapping(params = { "userId", "page", "size" })
    public ResponseEntity<?> getConsumptionsByUserId(
            @RequestParam String userId,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService.getAllByUserId(userId, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(params = { "userId", "consumptionStatus", "page", "size" })
    public ResponseEntity<?> getConsumptionsByUserIdAndConsumptionStatus(
            @RequestParam String userId,
            @RequestParam ConsumptionStatus consumptionStatus,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getAllByUserIdAndConsumptionStatus(userId, consumptionStatus, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(params = { "userId", "consumptionType", "creationDate", "page", "size" })
    public ResponseEntity<?> getConsumptionsByUserIdAndCreationDate(
            @RequestParam String userId,
            @RequestParam ConsumptionType consumptionType,
            @RequestParam LocalDate creationDate,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getAllByUserIdAndCreationDate(userId, consumptionType, creationDate, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(path = "/today", params = { "userId", "page", "size" })
    public ResponseEntity<?> getTodayConsumptionsByUserId(
            @RequestParam String userId,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getOrGenerateByUserIdForCurrentDay(userId, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(path = "/hourly", params = { "userId", "type", "modificationDate", "page", "size" })
    public ResponseEntity<?> getHourlyConsumptionByTypeAndModificationDate(
            @RequestParam String userId,
            @RequestParam ConsumptionType type,
            @RequestParam LocalDate modificationDate,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getHourlyConsumptionByTypeAndModificationDate(userId, modificationDate, type, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(path = "/daily", params = { "userId", "type", "modificationDate", "page", "size" })
    public ResponseEntity<?> getDailyConsumptionByTypeAndModificationDate(
            @RequestParam String userId,
            @RequestParam ConsumptionType type,
            @RequestParam LocalDate modificationDate,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getDailyConsumptionByTypeAndModificationDate(userId, modificationDate, type, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(path = "/weekly", params = { "userId", "type", "modificationDate", "page", "size" })
    public ResponseEntity<?> getWeeklyConsumptionByTypeAndModificationDate(
            @RequestParam String userId,
            @RequestParam ConsumptionType type,
            @RequestParam LocalDate modificationDate,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService
                    .getWeeklyConsumptionByTypeAndModificationDate(userId, modificationDate, type, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("")
    public ResponseEntity<?> createConsumption(@RequestBody ConsumptionRequest consumptionRequest) {
        try {
            Optional<ConsumptionResponse> consumptionResponse = consumptionService.save(consumptionRequest);
            if (consumptionResponse.isPresent()) {
                return new ResponseEntity<>(consumptionResponse.get(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Couldn't create a new consumption entry.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/sensor-data")
    public ResponseEntity<?> recordSensorData(@RequestBody String sensorData) {
        try {
            CsvFileWriterUtil.saveAsCsvFile(sensorData, "sensor-data-" + (iteration++) + ".csv");
            return new ResponseEntity<>("Saved successfully.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateConsumption(
            @PathVariable String id,
            @RequestBody ConsumptionUpdateRequest consumptionRequest
    ) {
        try {
            Optional<ConsumptionResponse> consumptionResponse = consumptionService.update(id, consumptionRequest);
            if (consumptionResponse.isPresent()) {
                return new ResponseEntity<>(consumptionResponse.get(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Couldn't update the consumption entry for given id.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteConsumption(@PathVariable String id) {
        try {
            consumptionService.delete(id);
            return new ResponseEntity<>("Successfully deleted consumption entry for given user id.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

}
