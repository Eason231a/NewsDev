package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoverImageVO {

    private Long id;
    private Long materialId;
    private String url;
    private Integer sortOrder;
}
