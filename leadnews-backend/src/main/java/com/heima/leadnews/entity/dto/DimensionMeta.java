package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DimensionMeta {

    private Integer value;
    private String label;
    private String chartType;
}
