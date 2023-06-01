package me.stefan923.waterly.dto;

import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.GenderType;
import me.stefan923.waterly.entity.UserInfo;

import java.time.LocalDate;

@Getter
@Setter
public class UserInfoResponse {

    private String firstName;
    private String lastName;
    private LocalDate dateOfBirth;
    private GenderType gender;
    private double weight;
    private double height;

    public UserInfoResponse(UserInfo userInfo) {
        this.firstName = userInfo.getFirstName();
        this.lastName = userInfo.getLastName();
        this.dateOfBirth = userInfo.getDateOfBirth();
        this.gender = userInfo.getGender();
        this.weight = userInfo.getWeight();
        this.height = userInfo.getHeight();
    }

}
