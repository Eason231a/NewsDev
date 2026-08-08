package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.Channel;
import com.heima.leadnews.entity.dto.ChannelRequest;
import com.heima.leadnews.entity.dto.ChannelStatusRequest;
import com.heima.leadnews.service.ChannelService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "频道管理")
@RestController
@RequestMapping("/channels")
@RequiredArgsConstructor
public class ChannelController {

    private final ChannelService channelService;

    @Operation(summary = "频道列表")
    @GetMapping
    public Result<List<Channel>> list(
            @RequestParam(required = false) Boolean isEnabled) {
        return Result.success(channelService.list(isEnabled));
    }

    @Operation(summary = "频道详情")
    @GetMapping("/{id}")
    public Result<Channel> detail(@PathVariable Long id) {
        return Result.success(channelService.getById(id));
    }

    @Operation(summary = "创建频道")
    @PostMapping
    public Result<Channel> create(@Valid @RequestBody ChannelRequest request) {
        Channel channel = new Channel();
        channel.setName(request.getName());
        channel.setDescription(request.getDescription());
        channel.setSortOrder(request.getSortOrder());
        return Result.success(channelService.create(channel));
    }

    @Operation(summary = "更新频道")
    @PutMapping("/{id}")
    public Result<Channel> update(@PathVariable Long id,
                                   @Valid @RequestBody ChannelRequest request) {
        Channel data = new Channel();
        data.setName(request.getName());
        data.setDescription(request.getDescription());
        data.setSortOrder(request.getSortOrder());
        return Result.success(channelService.update(id, data));
    }

    @Operation(summary = "设置频道启用状态")
    @PatchMapping("/{id}/status")
    public Result<Void> setStatus(@PathVariable Long id,
                                   @Valid @RequestBody ChannelStatusRequest request) {
        channelService.setStatus(id, request.getIsEnabled());
        return Result.success();
    }
}
