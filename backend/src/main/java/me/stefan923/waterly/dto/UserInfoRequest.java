package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.GenderType;

import java.time.LocalDate;

@Getter
@Setter
public class UserInfoRequest {

    private String userId;
    private String firstName;
    private String lastName;
    private LocalDate dateOfBirth;
    private GenderType gender;
    private double weight;
    private double height;

}
