package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FanOverviewResponse {

    private Long totalFanCount;
    private Long totalFanReadCount;
    private BigDecimal totalFanRevenue;
    private Long totalUnfollowCount;
}
