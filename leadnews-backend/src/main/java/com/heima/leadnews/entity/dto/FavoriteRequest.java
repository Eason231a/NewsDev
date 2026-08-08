package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class FavoriteRequest {

    @NotNull(message = "isFavorite不能为空")
    private Integer isFavorite;
}
