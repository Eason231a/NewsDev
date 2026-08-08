package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ChannelRequest {

    @NotBlank(message = "频道名称不能为空")
    @Size(max = 32, message = "频道名称最长32字符")
    private String name;

    @Size(max = 255, message = "频道描述最长255字符")
    private String description;

    private Integer sortOrder;
}
