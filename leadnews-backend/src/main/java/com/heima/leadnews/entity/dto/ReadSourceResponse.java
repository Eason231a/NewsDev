package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ReadSourceResponse {

    private Long articleId;
    private LocalDate statDate;
    private List<SourceItem> sources;

    @Data
    public static class SourceItem {
        private Integer sourceType;
        private String sourceLabel;
        private Integer readCount;
        private Double percentage;
        private String color;
    }
}
