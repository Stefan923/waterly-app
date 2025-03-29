package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserAccountRequest {

    private UserAccountRegistration userAccountRegistration;
    private UserInfoRequest userInfoRequest;

}
