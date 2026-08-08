package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class FanStatsResponse {

    private Long id;
    private LocalDate statDate;
    private Integer fanCount;
    private Integer fanReadCount;
    private BigDecimal fanRevenue;
    private Integer unfollowCount;
    private Integer newFollowCount;
}
