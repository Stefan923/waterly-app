package me.stefan923.waterly.controller;

import me.stefan923.waterly.dto.UserSettingsRequest;
import me.stefan923.waterly.dto.UserSettingsResponse;
import me.stefan923.waterly.service.UserSettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/api/user_settings")
public class UserSettingsController {

    private final UserSettingsService userSettingsService;

    @Autowired
    public UserSettingsController(UserSettingsService userSettingsService) {
        this.userSettingsService = userSettingsService;
    }

    @GetMapping("")
    public ResponseEntity<?> getUserSettingsByUserId(@RequestParam String userId) {
        Optional<UserSettingsResponse> userSettingsResponse = userSettingsService.getByUserAccountId(userId);
        if (userSettingsResponse.isPresent()) {
            return new ResponseEntity<>(userSettingsResponse.get(), HttpStatus.FOUND);
        } else {
            return new ResponseEntity<>("Couldn't find any user settings by given id.", HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("")
    public ResponseEntity<?> createUserSettings(@RequestBody UserSettingsRequest userSettingsRequest) {
        try {
            Optional<UserSettingsResponse> userSettingsResponse = userSettingsService.save(userSettingsRequest);
            if (userSettingsResponse.isPresent()) {
                return new ResponseEntity<>(userSettingsResponse.get(), HttpStatus.CREATED);
            } else {
                return new ResponseEntity<>("Couldn't create a new user settings entry.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PutMapping("")
    public ResponseEntity<?> updateUserSettings(@RequestBody UserSettingsRequest userSettingsRequest) {
        try {
            Optional<UserSettingsResponse> userSettingsResponse = userSettingsService.update(userSettingsRequest);
            if (userSettingsResponse.isPresent()) {
                return new ResponseEntity<>(userSettingsResponse.get(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Couldn't update the user settings for given user id.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteUserSettings(@PathVariable String userId) {
        try {
            userSettingsService.delete(userId);
            return new ResponseEntity<>("Successfully deleted user settings for given user id.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

}
