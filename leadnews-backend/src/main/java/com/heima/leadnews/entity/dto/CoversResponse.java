package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.util.List;

@Data
public class CoversResponse {

    private Integer coverType;
    private List<CoverImageVO> images;

    public CoversResponse(Integer coverType, List<CoverImageVO> images) {
        this.coverType = coverType;
        this.images = images;
    }
}
