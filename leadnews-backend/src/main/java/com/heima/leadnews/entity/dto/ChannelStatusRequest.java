package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ChannelStatusRequest {

    @NotNull(message = "isEnabled不能为空")
    private Integer isEnabled;
}
