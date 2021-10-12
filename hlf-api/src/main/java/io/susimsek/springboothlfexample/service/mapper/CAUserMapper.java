package io.susimsek.springboothlfexample.service.mapper;

import io.susimsek.springboothlfexample.model.request.CAUserRegistrationDTO;
import io.susimsek.springboothlfexample.model.response.CAUserDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface CAUserMapper {

    @Mapping(target = "affiliation", ignore = true)
    CAUserDTO cAUserRegistrationDTOToCAUserDTO(CAUserRegistrationDTO userRegistrationDTO);
}
