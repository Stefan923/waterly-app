package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class UserAccountConfirmation {
    private String email;
    private int confirmCode;
}
