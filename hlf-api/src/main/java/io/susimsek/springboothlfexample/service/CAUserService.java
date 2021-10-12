package io.susimsek.springboothlfexample.service;

import io.susimsek.springboothlfexample.model.request.CAUserRegistrationDTO;
import io.susimsek.springboothlfexample.model.response.CAUserDTO;

public interface CAUserService {

    CAUserDTO registerUser(CAUserRegistrationDTO user) throws Exception;
}
