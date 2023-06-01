package me.stefan923.waterly.controller;

import me.stefan923.waterly.dto.ConsumptionRequest;
import me.stefan923.waterly.dto.ConsumptionResponse;
import me.stefan923.waterly.service.ConsumptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.math.BigInteger;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/api/consumptions")
public class ConsumptionController {

    private final ConsumptionService consumptionService;

    @Autowired
    public ConsumptionController(ConsumptionService consumptionService) {
        this.consumptionService = consumptionService;
    }

    @GetMapping("")
    public ResponseEntity<?> getConsumptionsByUserId(
            @RequestParam String userId,
            @RequestParam int page,
            @RequestParam int size
    ) {
        try {
            Map<String, Object> consumptionResponse = consumptionService.getAllByUserAccountId(userId, page, size);
            return new ResponseEntity<>(consumptionResponse, HttpStatus.FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("")
    public ResponseEntity<?> createConsumption(@RequestBody ConsumptionRequest consumptionRequest) {
        try {
            Optional<ConsumptionResponse> consumptionResponse = consumptionService.save(consumptionRequest);
            if (consumptionResponse.isPresent()) {
                return new ResponseEntity<>(consumptionResponse.get(), HttpStatus.CREATED);
            } else {
                return new ResponseEntity<>("Couldn't create a new consumption entry.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateConsumption(
            @PathVariable BigInteger id,
            @RequestBody ConsumptionRequest consumptionRequest
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
    public ResponseEntity<?> deleteConsumption(@PathVariable BigInteger id) {
        try {
            consumptionService.delete(id);
            return new ResponseEntity<>("Successfully deleted consumption entry for given user id.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

}
