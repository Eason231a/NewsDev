package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.util.List;

@Data
public class PortraitDimensionResponse {

    private Integer dimension;
    private String dimensionLabel;
    private String chartType;
    private List<PortraitItemResponse> items;

    public PortraitDimensionResponse(Integer dimension, String dimensionLabel, String chartType, List<PortraitItemResponse> items) {
        this.dimension = dimension;
        this.dimensionLabel = dimensionLabel;
        this.chartType = chartType;
        this.items = items;
    }
}
