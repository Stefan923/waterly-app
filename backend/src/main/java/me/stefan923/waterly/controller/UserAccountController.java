package me.stefan923.waterly.controller;

import me.stefan923.waterly.dto.UserAccountRegistration;
import me.stefan923.waterly.dto.UserAccountResponse;
import me.stefan923.waterly.service.UserAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/api/user_accounts")
public class UserAccountController {

    private final UserAccountService userAccountService;

    @Autowired
    public UserAccountController(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    @GetMapping("")
    public ResponseEntity<?> getUserAccountByEmail(@RequestParam String email) {
        Optional<UserAccountResponse> userAccountResponse = userAccountService.getByEmail(email);
        if (userAccountResponse.isPresent()) {
            return new ResponseEntity<>(userAccountResponse.get(), HttpStatus.FOUND);
        } else {
            return new ResponseEntity<>("Couldn't find an user by given email.", HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("")
    public ResponseEntity<?> registerUserAccount(@RequestBody UserAccountRegistration accountRegistration) {
        try {
            Optional<UserAccountResponse> userAccountResponse = userAccountService.save(accountRegistration);
            if (userAccountResponse.isPresent()) {
                return new ResponseEntity<>(userAccountResponse.get(), HttpStatus.CREATED);
            } else {
                return new ResponseEntity<>("Couldn't create a new user.", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUserAccount(@PathVariable String id) {
        try {
            userAccountService.delete(id);
            return new ResponseEntity<>("Successfully deleted account for given user id.", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

}
