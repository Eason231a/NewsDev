package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class ArticleStatsResponse {

    private Long articleId;
    private String articleTitle;
    private LocalDate statDate;
    private Integer readCount;
    private Integer likeCount;
    private Integer commentCount;
    private Integer favoriteCount;
    private Integer shareCount;
    private Integer fanReadCount;
}
