package me.stefan923.waterly.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.entity.UserAccountType;

@Getter
@Setter
@AllArgsConstructor
public class UserAccountResponse {

    private String id;
    private String email;
    private UserAccountType accountType;

    public UserAccountResponse(UserAccount userAccount) {
        this.id = userAccount.getId();
        this.email = userAccount.getEmail();
        this.accountType = userAccount.getAccountType();
    }

}
