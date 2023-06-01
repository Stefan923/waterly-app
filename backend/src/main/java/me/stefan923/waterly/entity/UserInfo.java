package me.stefan923.waterly.entity;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigInteger;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@Document("user_info")
@RequiredArgsConstructor
@AllArgsConstructor
public class UserInfo {

    @Id
    private BigInteger id;

    @Indexed(unique = true)
    @NotBlank
    private String userId;

    @NotBlank
    private String firstName;

    @NotBlank
    private String lastName;

    @NotNull
    private LocalDate dateOfBirth;

    @NotNull
    private GenderType gender;

    @Min(10)
    @Max(500)
    private double weight;

    @Min(10)
    @Max(500)
    private double height;

}
