package io.susimsek.springboothlfexample.model.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AssetItemDTO {

	@Schema(description = "Asset Information.", required = true)
	@JsonProperty("Record")
	private AssetDTO assetDTO;

	@Schema(description = "Unique identifier of the Asset.", required = true)
	@JsonProperty("Key")
	private String key;
}