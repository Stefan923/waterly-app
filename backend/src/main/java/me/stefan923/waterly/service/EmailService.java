package me.stefan923.waterly.service;

import jakarta.mail.MessagingException;

public interface EmailService {

    void sendConfirmationEmail(String email) throws Exception;

}
