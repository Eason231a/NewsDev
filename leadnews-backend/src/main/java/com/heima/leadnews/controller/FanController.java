package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.FanResponse;
import com.heima.leadnews.service.FanService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "粉丝管理")
@RestController
@RequestMapping("/fans")
@RequiredArgsConstructor
public class FanController {

    private final FanService fanService;

    @Operation(summary = "粉丝列表")
    @GetMapping
    public Result<PageResult<FanResponse>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer isBlocked) {
        return Result.success(fanService.list(page, pageSize, isBlocked));
    }

    @Operation(summary = "拉黑粉丝")
    @PatchMapping("/{id}/block")
    public Result<Void> block(@PathVariable Long id) {
        fanService.block(id);
        return Result.success(null);
    }

    @Operation(summary = "取消拉黑")
    @PatchMapping("/{id}/unblock")
    public Result<Void> unblock(@PathVariable Long id) {
        fanService.unblock(id);
        return Result.success(null);
    }
}
