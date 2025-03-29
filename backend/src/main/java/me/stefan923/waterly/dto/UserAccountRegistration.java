package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.UserAccountType;

@Getter
@Setter
@AllArgsConstructor
public class UserAccountRegistration {

    private String email;
    private UserAccountType accountType;
    private String password;
    private String o2authToken;

}
