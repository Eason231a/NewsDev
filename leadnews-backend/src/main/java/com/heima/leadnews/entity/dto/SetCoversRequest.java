package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class SetCoversRequest {

    @NotNull(message = "封面类型不能为空")
    private Integer coverType;

    private List<Long> materialIds;
}
