package io.susimsek.springboothlfexample.model.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CAUserDTO {

    @Schema(description = "Unique identifier of the Org MSP.",
            example = "Org1MSP", required = true)
    private String org;

    @Schema(description = "Unique identifier of the User.",
            example = "max", required = true)
    private String userId;

    @Schema(description = "Affiliation of the User.",
            example = "org1.department1", required = true)
    private String affiliation;
}
