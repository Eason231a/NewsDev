package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ReadCompletionResponse {

    private Long articleId;
    private LocalDate statDate;
    private List<CompletionItem> completions;

    @Data
    public static class CompletionItem {
        private Integer completionRange;
        private String rangeLabel;
        private Integer userCount;
        private Double percentage;
        private String color;
    }
}
