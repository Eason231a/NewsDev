package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class PortraitAllResponse {

    private LocalDate statDate;
    private List<PortraitDimensionResponse> portraits;

    public PortraitAllResponse(LocalDate statDate, List<PortraitDimensionResponse> portraits) {
        this.statDate = statDate;
        this.portraits = portraits;
    }
}
