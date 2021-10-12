package io.susimsek.springboothlfexample.model.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Getter
@Setter
public class AssetUpdateRequestDTO {

    @Schema(description = "Owner of the Asset.", example = "tom", required = true)
    @NotBlank
    @Size(max = 25)
    private String owner;

    @Schema(description = "Color of the Asset.", example = "red", required = true)
    @NotBlank
    @Size(max = 25)
    private String color;

    @Schema(description = "Size of the Asset.", example = "12", required = true)
    @Min(1)
    @Max(50)
    private int size;

    @Schema(description = "Appraised Value of the Asset.", example = "20", required = true)
    @Min(1)
    @Max(500)
    private int appraisedValue;
}
