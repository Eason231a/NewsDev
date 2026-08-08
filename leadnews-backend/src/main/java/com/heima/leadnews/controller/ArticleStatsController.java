package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.*;
import com.heima.leadnews.service.ArticleStatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "文章数据统计")
@RestController
@RequestMapping("/article-stats")
@RequiredArgsConstructor
public class ArticleStatsController {

    private final ArticleStatsService articleStatsService;

    @Operation(summary = "统计概览卡片")
    @GetMapping("/overview")
    public Result<StatsOverviewResponse> overview(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(articleStatsService.getOverview(startDate, endDate));
    }

    @Operation(summary = "文章统计列表")
    @GetMapping
    public Result<PageResult<ArticleStatsResponse>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "readCount") String sortBy,
            @RequestParam(defaultValue = "desc") String order) {
        return Result.success(articleStatsService.list(
                page, pageSize, startDate, endDate, sortBy, order));
    }

    @Operation(summary = "文章详情统计")
    @GetMapping("/{articleId}")
    public Result<ArticleDetailStatsResponse> detail(
            @PathVariable Long articleId,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(articleStatsService.getArticleDetail(articleId, startDate, endDate));
    }

    @Operation(summary = "阅读来源分析")
    @GetMapping("/{articleId}/read-sources")
    public Result<ReadSourceResponse> readSources(
            @PathVariable Long articleId,
            @RequestParam(required = false) String statDate) {
        return Result.success(articleStatsService.getReadSources(articleId, statDate));
    }

    @Operation(summary = "阅读完成度分析")
    @GetMapping("/{articleId}/read-completion")
    public Result<ReadCompletionResponse> readCompletion(
            @PathVariable Long articleId,
            @RequestParam(required = false) String statDate) {
        return Result.success(articleStatsService.getReadCompletion(articleId, statDate));
    }
}
