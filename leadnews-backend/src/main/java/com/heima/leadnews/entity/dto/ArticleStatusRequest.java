package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ArticleStatusRequest {

    @NotNull(message = "status不能为空")
    private Integer status;

    private String comment;
}
