package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.UserAccountType;

@Getter
@Setter
@AllArgsConstructor
public class UserAccountRequest {

    private UserAccountRegistration userAccountRegistration;
    private UserInfoRequest userInfoRequest;

}
