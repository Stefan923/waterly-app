package me.stefan923.waterly.service;

import java.util.Optional;

public interface GoogleAuthService {
    Optional<String> verifyGoogleToken(String idTokenString);
}
