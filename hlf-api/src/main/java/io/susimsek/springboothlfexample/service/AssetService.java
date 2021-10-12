package io.susimsek.springboothlfexample.service;

import io.susimsek.springboothlfexample.model.request.AssetRegistrationRequestDTO;
import io.susimsek.springboothlfexample.model.request.AssetUpdateRequestDTO;
import io.susimsek.springboothlfexample.model.response.AssetDTO;
import io.susimsek.springboothlfexample.model.response.AssetHistoryDTO;
import io.susimsek.springboothlfexample.model.response.AssetItemDTO;
import org.hyperledger.fabric.gateway.ContractException;

import java.util.List;
import java.util.concurrent.TimeoutException;

public interface AssetService {
    AssetDTO createAsset(AssetRegistrationRequestDTO asset) throws InterruptedException, TimeoutException, ContractException;
    List<AssetItemDTO> findAllAssets() throws ContractException;
    AssetDTO updateAsset(String assetId, AssetUpdateRequestDTO asset) throws InterruptedException, TimeoutException, ContractException;
    List<AssetHistoryDTO> findAssetHistory(String assetId) throws ContractException;
    void deleteAsset(String assetId) throws ContractException, InterruptedException, TimeoutException;
}
