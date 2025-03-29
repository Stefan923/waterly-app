package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import me.stefan923.waterly.entity.UserAccountType;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class UserAccountLogin {

    private UserAccountType accountType;
    private String email;
    private String password;
    private String o2authToken;

}
