package io.susimsek.springboothlfexample.controller;

import io.susimsek.springboothlfexample.model.request.CAUserRegistrationDTO;
import io.susimsek.springboothlfexample.model.response.CAUserDTO;
import io.susimsek.springboothlfexample.service.CAUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@Tag(name = "ca user", description = "the CA User API")
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class CAUserController {

    private final CAUserService caUserService;

    @Operation(summary = "Create user", tags = { "ca user" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "successful operation",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = CAUserDTO.class)),
                            @Content(mediaType = "application/xml", schema = @Schema(implementation = CAUserDTO.class))
                   }
           ),
          @ApiResponse(responseCode = "400", description = "Invalid CA User supplied", content = @Content)
    })
    @PostMapping(value = "/ca-users/sign-up", consumes = { "application/json", "application/xml"})
    public ResponseEntity<CAUserDTO> registerUser(@Parameter(description="CA User to add. Cannot null or empty.", required=true, schema=@Schema(implementation = CAUserRegistrationDTO.class)) @RequestBody @Valid CAUserRegistrationDTO user) throws Exception {
        CAUserDTO caUserDTO = caUserService.registerUser(user);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(caUserDTO);
    }
}
