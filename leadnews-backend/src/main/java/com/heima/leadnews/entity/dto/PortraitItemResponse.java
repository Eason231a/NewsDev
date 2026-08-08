package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class PortraitItemResponse {

    private String dimensionKey;
    private String dimensionKeyLabel;
    private Integer dimensionValue;
    private BigDecimal percentage;

    public PortraitItemResponse(String dimensionKey, String dimensionKeyLabel, Integer dimensionValue, BigDecimal percentage) {
        this.dimensionKey = dimensionKey;
        this.dimensionKeyLabel = dimensionKeyLabel;
        this.dimensionValue = dimensionValue;
        this.percentage = percentage;
    }
}
