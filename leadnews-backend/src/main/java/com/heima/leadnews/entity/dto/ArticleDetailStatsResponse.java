package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ArticleDetailStatsResponse {

    private Long articleId;
    private String articleTitle;
    private Summary summary;
    private List<Daily> daily;

    @Data
    public static class Summary {
        private Long totalReadCount;
        private Long totalLikeCount;
        private Long totalCommentCount;
        private Long totalFavoriteCount;
        private Long totalShareCount;
        private Double avgReadProgress;
        private Double bounceRate;
        private Integer avgReadSeconds;
        private Long totalRecommendShares;
        private Long totalFanReadCount;
    }

    @Data
    public static class Daily {
        private LocalDate statDate;
        private Integer readCount;
        private Integer likeCount;
        private Integer commentCount;
        private Integer favoriteCount;
        private Integer shareCount;
    }
}
