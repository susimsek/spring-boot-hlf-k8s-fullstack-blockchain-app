package io.susimsek.springboothlfexample.service.impl;


import io.github.susimsek.hlf.ca.user.service.FabricCAUserService;
import io.susimsek.springboothlfexample.exception.RecordAlreadyExistsException;
import io.susimsek.springboothlfexample.model.request.CAUserRegistrationDTO;
import io.susimsek.springboothlfexample.model.response.CAUserDTO;
import io.susimsek.springboothlfexample.service.CAUserService;
import io.susimsek.springboothlfexample.service.mapper.CAUserMapper;
import io.susimsek.springboothlfexample.util.CAUserUtil;
import io.susimsek.springboothlfexample.util.HlfExceptionMessageUtil;
import lombok.RequiredArgsConstructor;
import org.hyperledger.fabric_ca.sdk.exception.RegistrationException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CAUserServiceImpl implements CAUserService {

    private final FabricCAUserService fabricCAUserService;
    private final CAUserMapper caUserMapper;

    @Override
    public CAUserDTO registerUser(CAUserRegistrationDTO user) throws Exception {
        try {
            fabricCAUserService.enrollAdmin(user.getOrg());
            fabricCAUserService.registerAndEnrollUser(user.getOrg(),user.getUserId(), CAUserUtil.AFFILIATION);
            CAUserDTO caUserDTO = caUserMapper.cAUserRegistrationDTOToCAUserDTO(user);
            caUserDTO.setAffiliation(CAUserUtil.AFFILIATION);
            return caUserDTO;
        } catch (RegistrationException ex) {
            if(ex.getMessage().contains(HlfExceptionMessageUtil.IDENTITY_ALREADY_EXISTS_MESSAGE)){
                throw new RecordAlreadyExistsException(String.format("Identity %s is already registered",user.getUserId()));
            }
            throw ex;
        }
    }
}
