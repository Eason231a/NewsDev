package com.heima.leadnews.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "upload")
public class FileUploadConfig {

    private String localPath = "./uploads";
    private String allowedExtensions = "jpg,jpeg,png";
}
