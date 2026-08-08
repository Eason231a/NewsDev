package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.util.List;

@Data
public class EnumResponse {

    private String field;
    private List<EnumValue> values;

    public EnumResponse(String field, List<EnumValue> values) {
        this.field = field;
        this.values = values;
    }
}
