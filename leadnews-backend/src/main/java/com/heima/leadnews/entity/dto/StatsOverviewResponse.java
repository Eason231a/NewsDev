package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StatsOverviewResponse {

    private Long totalPublishCount;
    private Long totalLikeCount;
    private Long totalFavoriteCount;
    private Long totalShareCount;
}
