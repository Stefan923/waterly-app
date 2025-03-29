package me.stefan923.waterly.controller;

import me.stefan923.waterly.dto.*;
import me.stefan923.waterly.entity.UserAccountType;
import me.stefan923.waterly.exception.NonEnabledAccountException;
import me.stefan923.waterly.exception.NonRegisteredAccountException;
import me.stefan923.waterly.service.EmailService;
import me.stefan923.waterly.service.GoogleAuthService;
import me.stefan923.waterly.service.UserAccountService;
import me.stefan923.waterly.service.UserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthenticationController {
    private final UserAccountService userAccountService;
    private final UserInfoService userInfoService;
    private final EmailService emailService;
    private final GoogleAuthService googleAuthService;

    @Autowired
    public AuthenticationController(UserAccountService userAccountService,
                                    UserInfoService userInfoService,
                                    EmailService emailService,
                                    GoogleAuthService googleAuthService) {
        this.userAccountService = userAccountService;
        this.userInfoService = userInfoService;
        this.emailService = emailService;
        this.googleAuthService = googleAuthService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserAccountLogin userAccountLogin) {
        try {
            if (userAccountLogin.getAccountType() == UserAccountType.GOOGLE) {
                Optional<String> googleServiceResponse = googleAuthService.verifyGoogleToken(userAccountLogin.getO2authToken());
                if (googleServiceResponse.isPresent()) {
                    userAccountLogin.setEmail(googleServiceResponse.get());
                } else {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Your account has not been registered yet.");
                }
            }
            return ResponseEntity.ok().body(userAccountService.login(userAccountLogin));
        } catch (NonRegisteredAccountException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Your account has not been registered yet.");
        } catch (NonEnabledAccountException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

    @GetMapping("/validate")
    public ResponseEntity<?> validateEmail(@RequestParam String email) {
        try {
            userAccountService.validateEmail(email);
            return ResponseEntity.ok().body("Given email is valid for creating a new account.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody UserAccountRequest userAccountRequest) {
        try {
            UserAccountResponse userAccountResponse = userAccountService
                    .save(userAccountRequest)
                    .orElseThrow(() -> new Exception("Couldn't create a new user."));

            UserInfoRequest userInfoRequest = userAccountRequest.getUserInfoRequest();
            userInfoRequest.setUserId(userAccountResponse.getId());
            userInfoService.save(userInfoRequest)
                    .orElseThrow(() -> new Exception("Couldn't create a new user."));

            return ResponseEntity.status(HttpStatus.OK).body("Account created successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

    @GetMapping("/request_confirm_code")
    public ResponseEntity<?> sendConfirmCodeEmail(@RequestParam String email) {
        try {
            emailService.sendConfirmationEmail(email);
            return ResponseEntity.status(HttpStatus.OK).body("A confirmation code has been sent to your email.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/confirm")
    public ResponseEntity<?> confirm(@RequestBody UserAccountConfirmation userAccountConfirmation) {
        System.out.println(userAccountConfirmation);
        try {
            return ResponseEntity.ok().body(userAccountService.confirmEmail(userAccountConfirmation));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

}
