package me.stefan923.waterly.exception;

public class NonRegisteredAccountException extends Exception {
    public NonRegisteredAccountException(String message) {
        super(message);
    }
}
