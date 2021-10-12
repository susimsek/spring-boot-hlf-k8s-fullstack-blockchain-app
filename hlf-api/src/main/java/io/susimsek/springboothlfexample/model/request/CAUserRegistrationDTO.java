package io.susimsek.springboothlfexample.model.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Getter
@Setter
public class CAUserRegistrationDTO {

    @Schema(description = "Unique identifier of the Org MSP.",
            example = "Org1MSP", required = true)
    @NotBlank
    @Size(max = 25)
    private String org;

    @Schema(description = "Unique identifier of the User.",
            example = "max", required = true)
    @NotBlank
    @Size(max = 50)
    private String userId;
}
