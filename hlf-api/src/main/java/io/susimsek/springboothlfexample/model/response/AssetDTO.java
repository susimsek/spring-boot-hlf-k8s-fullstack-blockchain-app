package io.susimsek.springboothlfexample.model.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AssetDTO {
	@Schema(description = "Unique identifier of the Asset.", example = "asset9", required = true)
	@JsonProperty("ID")
	private String id;

	@Schema(description = "Owner of the Asset.", example = "tom", required = true)
	private String owner;

	@Schema(description = "Color of the Asset.", example = "red", required = true)
	private String color;

	@Schema(description = "Size of the Asset.", example = "12", required = true)
	private int size;

	@Schema(description = "Appraised Value of the Asset.", example = "20", required = true)
	private int appraisedValue;
}