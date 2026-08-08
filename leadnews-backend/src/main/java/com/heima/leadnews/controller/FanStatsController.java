package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.*;
import com.heima.leadnews.service.FanStatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "粉丝数据统计")
@RestController
@RequestMapping("/fan-stats")
@RequiredArgsConstructor
public class FanStatsController {

    private final FanStatsService fanStatsService;

    @Operation(summary = "粉丝概况概览")
    @GetMapping("/overview")
    public Result<FanOverviewResponse> overview(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(fanStatsService.getOverview(startDate, endDate));
    }

    @Operation(summary = "粉丝数据列表")
    @GetMapping
    public Result<PageResult<FanStatsResponse>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(fanStatsService.list(page, pageSize, startDate, endDate));
    }

    @Operation(summary = "阅读量小时趋势")
    @GetMapping("/trend")
    public Result<FanTrendResponse> trend(
            @RequestParam String statDate) {
        return Result.success(fanStatsService.getTrend(statDate));
    }

    @Operation(summary = "粉丝画像数据")
    @GetMapping("/portrait")
    public Result<Object> portrait(
            @RequestParam(required = false) String statDate,
            @RequestParam(required = false) Integer dimension) {
        return Result.success(fanStatsService.getPortrait(statDate, dimension));
    }

    @Operation(summary = "画像维度列表")
    @GetMapping("/portrait/dimensions")
    public Result<DimensionListResponse> portraitDimensions() {
        return Result.success(fanStatsService.getPortraitDimensions());
    }
}
