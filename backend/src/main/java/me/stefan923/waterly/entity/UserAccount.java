package me.stefan923.waterly.entity;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

@Getter
@Setter
@Builder
@Document("user_accounts")
@RequiredArgsConstructor
@AllArgsConstructor
public class UserAccount implements UserDetails {

    @Id
    private String id;

    @NotNull(message = "Type of the account is mandatory.")
    private UserAccountType accountType;

    @Indexed(unique = true)
    @NotBlank(message = "Email address is mandatory.")
    @Pattern(regexp = "^(?=.{1,64}@)[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*@"
            + "[^-][A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$",
            message = "This is not a valid email address.")
    private String email;

    private String password;

    private int confirmCode;

    private boolean isAccountExpired;

    private boolean isAccountLocked;

    private boolean isPasswordExpired;

    private boolean isAccountEnabled;


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return !isAccountExpired;
    }

    @Override
    public boolean isAccountNonLocked() {
        return !isAccountLocked;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return !isPasswordExpired;
    }

    @Override
    public boolean isEnabled() {
        return isAccountEnabled;
    }
}
