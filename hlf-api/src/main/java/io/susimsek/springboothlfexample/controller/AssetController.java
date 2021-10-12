package io.susimsek.springboothlfexample.controller;

import io.susimsek.springboothlfexample.model.request.AssetRegistrationRequestDTO;
import io.susimsek.springboothlfexample.model.request.AssetUpdateRequestDTO;
import io.susimsek.springboothlfexample.model.response.AssetDTO;
import io.susimsek.springboothlfexample.model.response.AssetHistoryDTO;
import io.susimsek.springboothlfexample.model.response.AssetItemDTO;
import io.susimsek.springboothlfexample.service.AssetService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.hyperledger.fabric.gateway.ContractException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.concurrent.TimeoutException;

@Tag(name = "asset", description = "the Asset API")
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class AssetController {

    private final AssetService assetService;

    @Operation(summary = "Create Asset", tags = { "contact" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "successful operation",
                    content = {
                            @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = AssetDTO.class))),
                            @Content(mediaType = "application/xml", array = @ArraySchema(schema = @Schema(implementation = AssetDTO.class)))
                    }
            ),
            @ApiResponse(responseCode = "400", description = "Invalid Asset supplied", content = @Content),
            @ApiResponse(responseCode = "409", description = "Asset already exists", content = @Content)
    })
    @PostMapping(value = "/assets",
            produces = { "application/json", "application/xml" },
            consumes = { "application/json", "application/xml" })
    public ResponseEntity<AssetDTO> createAsset(@Parameter(description="Asset to add. Cannot null or empty.", required=true, schema=@Schema(implementation = AssetRegistrationRequestDTO.class)) @Valid @RequestBody AssetRegistrationRequestDTO asset
    ) throws ContractException, InterruptedException, TimeoutException {
        AssetDTO assetDTO = assetService.createAsset(asset);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(assetDTO);
    }

    @Operation(summary = "Update Asset", tags = { "contact" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = {
                            @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = AssetDTO.class))),
                            @Content(mediaType = "application/xml", array = @ArraySchema(schema = @Schema(implementation = AssetDTO.class)))
                    }
            ),
            @ApiResponse(responseCode = "400", description = "Invalid Asset supplied", content = @Content),
            @ApiResponse(responseCode = "404", description = "Asset not found", content = @Content)
    })
    @PutMapping(value = "/assets/{assetId}",
                produces = { "application/json", "application/xml" },
                consumes = { "application/json", "application/xml" })
    public ResponseEntity<AssetDTO> updateAsset(@Parameter(description="Id of the asset to be update. Cannot be empty.", required=true) @PathVariable String assetId,
                                                @Parameter(description="Asset to update. Cannot null or empty.", required=true, schema=@Schema(implementation = AssetUpdateRequestDTO.class)) @Valid @RequestBody AssetUpdateRequestDTO asset
                                                ) throws ContractException, InterruptedException, TimeoutException {
        AssetDTO assetDTO = assetService.updateAsset(assetId,asset);
        return ResponseEntity.ok(assetDTO);
    }

    @Operation(summary = "Find All Assets", tags = { "asset" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = {
                            @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = AssetItemDTO.class))),
                            @Content(mediaType = "application/xml", array = @ArraySchema(schema = @Schema(implementation = AssetItemDTO.class)))
                    }
            )
    })
    @GetMapping(value = "/assets",
                produces = { "application/json", "application/xml" })
    public ResponseEntity<List<AssetItemDTO>> findAllAssets() throws ContractException {
        List<AssetItemDTO> result = assetService.findAllAssets();
        return ResponseEntity.ok()
                .body(result);
    }

    @Operation(summary = "Find Asset History by ID", tags = { "contact" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = {
                            @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = AssetHistoryDTO.class))),
                            @Content(mediaType = "application/xml", array = @ArraySchema(schema = @Schema(implementation = AssetHistoryDTO.class)))
                    }
            ),
            @ApiResponse(responseCode = "400", description = "Invalid ID supplied",content = @Content),
            @ApiResponse(responseCode = "404", description = "Asset not found", content = @Content)
    })
    @GetMapping(value = "/assets/{assetId}",
                produces = { "application/json", "application/xml" })
    public ResponseEntity<List<AssetHistoryDTO>> findAssetById(@Parameter(description="Id of the asset to be obtained. Cannot be empty.", required=true) @PathVariable String assetId) throws ContractException {
       List<AssetHistoryDTO> result = assetService.findAssetHistory(assetId);
        return ResponseEntity.ok()
                .body(result);
    }


    @Operation(summary = "Delete Asset", tags = { "contact" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "successful operation", content = @Content),
            @ApiResponse(responseCode = "400", description = "Invalid ID supplied",content = @Content),
            @ApiResponse(responseCode = "404", description = "Asset not found", content = @Content)
    })
    @DeleteMapping(value = "/assets/{assetId}")
    public ResponseEntity<Void> deleteAsset(@Parameter(description="Id of the asset to be delete. Cannot be empty.", required=true) @PathVariable String assetId) throws ContractException, InterruptedException, TimeoutException {
        assetService.deleteAsset(assetId);
        return ResponseEntity.noContent()
                .build();
    }
}
