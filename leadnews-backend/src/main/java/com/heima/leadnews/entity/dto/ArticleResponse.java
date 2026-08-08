package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ArticleResponse {

    private Long id;
    private Long userId;
    private Long channelId;
    private String channelName;
    private String title;
    private String content;
    private String tag;
    private Integer coverType;
    private Integer status;
    private String reviewComment;
    private LocalDateTime scheduledAt;
    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<CoverImageVO> coverImages;
    private ArticleStatsVO stats;
}
