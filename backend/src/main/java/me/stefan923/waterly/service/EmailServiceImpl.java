package me.stefan923.waterly.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Properties;

@Component
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {
    private final UserAccountService userAccountService;

    @Value("${email.username}")
    private String username;

    @Value("${email.password}")
    private String password;

    @Value("${email.smtp.host}")
    private String host;

    @Value("${email.smtp.port}")
    private String port;

    @Override
    public void sendConfirmationEmail(String email) throws Exception {
        sendConfirmationEmail(email, String.valueOf(userAccountService.generateConfirmCode(email)));
    }

    private void sendConfirmationEmail(String recipient, String confirmationCode) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
        message.setSubject("Confirmation Code");
        message.setText("Hi,\n\nYour confirmation code is: " + confirmationCode);

        Transport.send(message);
    }
}
