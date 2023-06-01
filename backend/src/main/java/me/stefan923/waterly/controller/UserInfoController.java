package me.stefan923.waterly.controller;

import me.stefan923.waterly.dto.UserInfoRequest;
import me.stefan923.waterly.dto.UserInfoResponse;
import me.stefan923.waterly.service.UserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/api/user_info")
public class UserInfoController {

    private final UserInfoService userInfoService;

    @Autowired
    public UserInfoController(UserInfoService userInfoService) {
        this.userInfoService = userInfoService;
    }

    @GetMapping("")
    public ResponseEntity<?> getUserInfoByUserId(@RequestParam String userId) {
        Optional<UserInfoResponse> userInfoResponse = userInfoService.getByUserAccountId(userId);
        if (userInfoResponse.isPresent()) {
            return new ResponseEntity<>(userInfoResponse.get(), HttpStatus.FOUND);
        } else {
            return new ResponseEntity<>("Couldn't find any user info by given id.", HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("")
    public ResponseEntity<?> createUserInfo(@RequestBody UserInfoRequest userInfoRequest) {
        try {
            Optional<UserInfoResponse> userInfoResponse = userInfoService.save(userInfoRequest);
            if (userInfoResponse.isPresent()) {
                return new ResponseEntity<>(userInfoResponse.get(), HttpStatus.CREATED);
            } else {
                return new ResponseEntity<>("Couldn't create a new user info entry.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PutMapping("")
    public ResponseEntity<?> updateUserInfo(@RequestBody UserInfoRequest userInfoRequest) {
        try {
            Optional<UserInfoResponse> userInfoResponse = userInfoService.update(userInfoRequest);
            if (userInfoResponse.isPresent()) {
                return new ResponseEntity<>(userInfoResponse.get(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Couldn't update the user info for given user id.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteUserInfo(@PathVariable String userId) {
        try {
            userInfoService.delete(userId);
            return new ResponseEntity<>("Successfully deleted user info for given user id.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

}
