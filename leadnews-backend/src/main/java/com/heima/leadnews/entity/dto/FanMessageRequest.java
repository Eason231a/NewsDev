package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class FanMessageRequest {

    @NotNull
    private Long fanId;

    @NotBlank
    private String content;
}
