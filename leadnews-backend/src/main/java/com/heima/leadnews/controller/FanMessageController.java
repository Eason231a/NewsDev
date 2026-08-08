package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.FanMessageRequest;
import com.heima.leadnews.entity.dto.FanMessageResponse;
import com.heima.leadnews.service.FanMessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "粉丝私信")
@RestController
@RequestMapping("/fan-messages")
@RequiredArgsConstructor
public class FanMessageController {

    private final FanMessageService fanMessageService;

    @Operation(summary = "发送私信")
    @PostMapping
    public Result<FanMessageResponse> send(@Valid @RequestBody FanMessageRequest request) {
        FanMessageResponse resp = fanMessageService.send(request);
        if (resp == null) {
            return Result.error(404, "粉丝不存在");
        }
        return Result.success(resp);
    }

    @Operation(summary = "私信记录")
    @GetMapping
    public Result<PageResult<FanMessageResponse>> list(
            @RequestParam Long fanId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return Result.success(fanMessageService.list(fanId, page, pageSize));
    }
}
