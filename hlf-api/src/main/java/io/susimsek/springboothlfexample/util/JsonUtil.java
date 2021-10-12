package io.susimsek.springboothlfexample.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class JsonUtil {

    private final ObjectMapper objectMapper;

    public <T> List<T> mapToListObject(byte[] data, Class<T> t){
        try {
            return objectMapper.readValue(data, new TypeReference<List<T>>() {});
        } catch (IOException ex) {
            throw new RuntimeException(ex);
        }
    }

    public <T> T mapToObject(byte[] data, Class<T> t){
        try {
            return objectMapper.readValue(data, t);
        } catch (IOException ex) {
            throw new RuntimeException(ex);
        }
    }
}
