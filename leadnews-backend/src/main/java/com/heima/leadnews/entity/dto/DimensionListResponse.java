package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.util.List;

@Data
public class DimensionListResponse {

    private List<DimensionMeta> dimensions;

    public DimensionListResponse(List<DimensionMeta> dimensions) {
        this.dimensions = dimensions;
    }
}
