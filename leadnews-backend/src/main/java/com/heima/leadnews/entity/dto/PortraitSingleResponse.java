package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class PortraitSingleResponse {

    private LocalDate statDate;
    private Integer dimension;
    private String dimensionLabel;
    private String chartType;
    private List<PortraitItemResponse> items;

    public PortraitSingleResponse(LocalDate statDate, Integer dimension, String dimensionLabel, String chartType, List<PortraitItemResponse> items) {
        this.statDate = statDate;
        this.dimension = dimension;
        this.dimensionLabel = dimensionLabel;
        this.chartType = chartType;
        this.items = items;
    }
}
