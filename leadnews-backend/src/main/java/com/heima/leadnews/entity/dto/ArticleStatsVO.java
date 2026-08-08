package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ArticleStatsVO {

    private Long readCount;
    private Long likeCount;
    private Long commentCount;
    private Long favoriteCount;
    private Long shareCount;
}
