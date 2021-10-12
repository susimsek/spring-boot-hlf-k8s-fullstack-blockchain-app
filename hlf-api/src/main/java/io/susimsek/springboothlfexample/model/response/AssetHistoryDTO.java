package io.susimsek.springboothlfexample.model.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AssetHistoryDTO {

	@Schema(description = "Deletion status of the Transaction.", example = "false", required = true)
	private boolean isDelete;

	@Schema(description = "Asset Information.", required = true)
	private AssetDTO record;

	@Schema(description = "Unique identifier of the Transaction.", example = "45b4523648a6c52fb00bfdbfdd3ae2f52474c9fe71d328914de89fa7ce2c1681", required = true)
	private String txId;

	@Schema(description = "Creation Date of the Transaction.", example = "2021-09-22T16:44:26.3014639Z", required = true)
	private LocalDateTime timestamp;
}