package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.ArticleReviewLog;
import com.heima.leadnews.service.ReviewLogService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "审核日志")
@RestController
@RequestMapping("/review-logs")
@RequiredArgsConstructor
public class ReviewLogController {

    private final ReviewLogService reviewLogService;

    @Operation(summary = "审核记录列表")
    @GetMapping
    public Result<PageResult<ArticleReviewLog>> list(
            @RequestParam(required = false) Long articleId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(reviewLogService.list(articleId, page, pageSize, startDate, endDate));
    }
}
