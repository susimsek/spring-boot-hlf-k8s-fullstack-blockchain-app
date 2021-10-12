package io.susimsek.springboothlfexample.service.impl;

import io.susimsek.springboothlfexample.exception.RecordAlreadyExistsException;
import io.susimsek.springboothlfexample.exception.RecordNotFoundException;
import io.susimsek.springboothlfexample.model.request.AssetRegistrationRequestDTO;
import io.susimsek.springboothlfexample.model.request.AssetUpdateRequestDTO;
import io.susimsek.springboothlfexample.model.response.AssetDTO;
import io.susimsek.springboothlfexample.model.response.AssetHistoryDTO;
import io.susimsek.springboothlfexample.model.response.AssetItemDTO;
import io.susimsek.springboothlfexample.service.AssetService;
import io.susimsek.springboothlfexample.service.mapper.AssetMapper;
import io.susimsek.springboothlfexample.util.HlfExceptionMessageUtil;
import io.susimsek.springboothlfexample.util.JsonUtil;
import io.susimsek.springboothlfexample.util.TransactionUtil;
import lombok.RequiredArgsConstructor;
import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.ContractException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeoutException;

@Service
@RequiredArgsConstructor
public class AssetServiceImpl implements AssetService {

    private final Contract contract;
    private final JsonUtil jsonUtil;
    private final AssetMapper assetMapper;

    @Override
    public AssetDTO createAsset(AssetRegistrationRequestDTO asset) throws InterruptedException, TimeoutException, ContractException {
        try {
            contract.submitTransaction(TransactionUtil.CREATE_ASSET,asset.getId(),asset.getColor(),String.valueOf(asset.getSize()),asset.getOwner(),String.valueOf(asset.getAppraisedValue()));
            return assetMapper.assetRegistrationRequestDTOToAssetDTO(asset);
        } catch (ContractException ex) {
            if(ex.getMessage().contains(HlfExceptionMessageUtil.ASSET_ALREADY_EXISTS_MESSAGE)){
                throw new RecordAlreadyExistsException(String.format("Asset %s is already exists",asset.getId()));
            }
            throw ex;
        }
    }

    @Override
    public AssetDTO updateAsset(String assetId, AssetUpdateRequestDTO asset) throws InterruptedException, TimeoutException, ContractException {
        try {
            contract.submitTransaction(TransactionUtil.UPDATE_ASSET,assetId,asset.getColor(),String.valueOf(asset.getSize()),asset.getOwner(),String.valueOf(asset.getAppraisedValue()));
            AssetDTO assetDTO = assetMapper.assetUpdateRequestDTOToAssetDTO(asset);
            assetDTO.setId(assetId);
            return assetDTO;
        } catch (ContractException ex) {
            if(ex.getMessage().contains(HlfExceptionMessageUtil.ASSET_NOT_FOUND_MESSAGE)){
                throw new RecordNotFoundException(String.format("Asset %s not found",assetId));
            }
            throw ex;
        }
    }

    @Override
    public List<AssetItemDTO> findAllAssets() throws ContractException {
        byte[] result = contract.evaluateTransaction(TransactionUtil.GET_ALL_ASSETS);
        return jsonUtil.mapToListObject(result, AssetItemDTO.class);
    }

    @Override
    public List<AssetHistoryDTO> findAssetHistory(String assetId) throws ContractException {
        Optional<byte[]> result = Optional.ofNullable(contract.evaluateTransaction(TransactionUtil.GET_ASSET_HISTORY,assetId));
        return result.filter(bytes -> bytes.length > 0)
                .map(bytes -> jsonUtil.mapToListObject(bytes, AssetHistoryDTO.class))
                .orElseThrow(() -> new RecordNotFoundException(String.format("Asset %s not found",assetId)));
    }

    @Override
    public void deleteAsset(String assetId) throws InterruptedException, TimeoutException, ContractException {
        try {
            contract.submitTransaction(TransactionUtil.DELETE_ASSET,assetId);
        } catch (ContractException ex) {
           if(ex.getMessage().contains(HlfExceptionMessageUtil.ASSET_NOT_FOUND_MESSAGE)){
               throw new RecordNotFoundException(String.format("Asset %s not found",assetId));
           }
            throw ex;
        }
    }
}
