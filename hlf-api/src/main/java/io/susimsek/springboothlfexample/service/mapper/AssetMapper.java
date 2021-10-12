package io.susimsek.springboothlfexample.service.mapper;

import io.susimsek.springboothlfexample.model.request.AssetRegistrationRequestDTO;
import io.susimsek.springboothlfexample.model.request.AssetUpdateRequestDTO;
import io.susimsek.springboothlfexample.model.response.AssetDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface AssetMapper {

    AssetDTO assetRegistrationRequestDTOToAssetDTO(AssetRegistrationRequestDTO assetRegistrationRequestDTO);

    @Mapping(target = "id", ignore = true)
    AssetDTO assetUpdateRequestDTOToAssetDTO(AssetUpdateRequestDTO assetUpdateRequestDTO);
}
