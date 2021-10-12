package io.susimsek.springboothlfexample.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(ApiDocProperties.class)
public class ApiDocConfig {

    @Bean
    public OpenAPI customOpenAPI(ApiDocProperties apiDocProperties) {
        return new OpenAPI()
                .components(new Components())
                .info(metaData(apiDocProperties));
    }


    private Info metaData(ApiDocProperties apiDocProperties) {
        return new Info()
                .title(apiDocProperties.getTitle())
                .description(apiDocProperties.getDescription())
                .version(apiDocProperties.getVersion())
                .termsOfService(apiDocProperties.getTermsOfServiceUrl())
                .license(new License().
                        name(apiDocProperties.getLicense())
                        .url(apiDocProperties.getLicenseUrl()));
    }
}
