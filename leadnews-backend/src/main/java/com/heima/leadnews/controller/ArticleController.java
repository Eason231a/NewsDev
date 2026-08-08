package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.ArticleCreateRequest;
import com.heima.leadnews.entity.dto.ArticleResponse;
import com.heima.leadnews.entity.dto.ArticleStatusRequest;
import com.heima.leadnews.entity.dto.CoversResponse;
import com.heima.leadnews.entity.dto.EnumResponse;
import com.heima.leadnews.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import com.heima.leadnews.entity.dto.SetCoversRequest;

@Tag(name = "文章管理")
@RestController
@RequestMapping("/articles")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;

    @Operation(summary = "文章列表")
    @GetMapping
    public Result<PageResult<ArticleResponse>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Long channelId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String order) {
        return Result.success(articleService.list(
                page, pageSize, status, channelId, keyword, startDate, endDate, sortBy, order));
    }

    @Operation(summary = "文章详情")
    @GetMapping("/{id}")
    public Result<ArticleResponse> detail(@PathVariable Long id) {
        return Result.success(articleService.getById(id));
    }

    @Operation(summary = "创建文章")
    @PostMapping
    public Result<ArticleResponse> create(@Valid @RequestBody ArticleCreateRequest request) {
        return Result.success(articleService.create(request));
    }

    @Operation(summary = "更新文章")
    @PutMapping("/{id}")
    public Result<ArticleResponse> update(@PathVariable Long id,
                                           @Valid @RequestBody ArticleCreateRequest request) {
        return Result.success(articleService.update(id, request));
    }

    @Operation(summary = "变更文章状态")
    @PatchMapping("/{id}/status")
    public Result<Void> changeStatus(@PathVariable Long id,
                                      @Valid @RequestBody ArticleStatusRequest request) {
        articleService.changeStatus(id, request.getStatus(), request.getComment());
        return Result.success();
    }

    @Operation(summary = "删除文章")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        articleService.delete(id);
        return Result.success();
    }

    @Operation(summary = "恢复文章")
    @PatchMapping("/{id}/restore")
    public Result<Void> restore(@PathVariable Long id) {
        articleService.restore(id);
        return Result.success();
    }

    @Operation(summary = "获取枚举值")
    @GetMapping("/enums/{field}")
    public Result<EnumResponse> enums(@PathVariable String field) {
        return Result.success(articleService.getEnums(field));
    }

    @Operation(summary = "获取文章封面")
    @GetMapping("/{id}/covers")
    public Result<CoversResponse> getCovers(@PathVariable Long id) {
        return Result.success(articleService.getCovers(id));
    }

    @Operation(summary = "设置文章封面")
    @PutMapping("/{id}/covers")
    public Result<Void> setCovers(@PathVariable Long id,
                                   @Valid @RequestBody SetCoversRequest request) {
        articleService.setCovers(id, request.getCoverType(), request.getMaterialIds());
        return Result.success();
    }
}
