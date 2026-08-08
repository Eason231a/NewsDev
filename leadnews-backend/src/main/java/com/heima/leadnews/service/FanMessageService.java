package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.Fan;
import com.heima.leadnews.entity.FanMessage;
import com.heima.leadnews.entity.dto.FanMessageRequest;
import com.heima.leadnews.entity.dto.FanMessageResponse;
import com.heima.leadnews.mapper.FanMapper;
import com.heima.leadnews.mapper.FanMessageMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FanMessageService {

    private final FanMessageMapper fanMessageMapper;
    private final FanMapper fanMapper;

    public FanMessageResponse send(FanMessageRequest request) {
        Long userId = UserContext.getUserId();

        Fan fan = fanMapper.selectOne(new LambdaQueryWrapper<Fan>()
                .eq(Fan::getId, request.getFanId())
                .eq(Fan::getUserId, userId));
        if (fan == null) return null;

        FanMessage msg = new FanMessage();
        msg.setUserId(userId);
        msg.setFanId(request.getFanId());
        msg.setContent(request.getContent());
        fanMessageMapper.insert(msg);

        FanMessageResponse resp = new FanMessageResponse();
        resp.setId(msg.getId());
        resp.setFan(new FanMessageResponse.FanMessageFan(fan.getId(), fan.getFanName()));
        resp.setContent(msg.getContent());
        resp.setCreatedAt(msg.getCreatedAt());
        return resp;
    }

    public PageResult<FanMessageResponse> list(Long fanId, int page, int pageSize) {
        Long userId = UserContext.getUserId();

        Fan fan = fanMapper.selectOne(new LambdaQueryWrapper<Fan>()
                .eq(Fan::getId, fanId)
                .eq(Fan::getUserId, userId));
        if (fan == null) return PageResult.of(java.util.List.of(), 0L, page, pageSize);

        LambdaQueryWrapper<FanMessage> wrapper = new LambdaQueryWrapper<FanMessage>()
                .eq(FanMessage::getUserId, userId)
                .eq(FanMessage::getFanId, fanId)
                .orderByDesc(FanMessage::getCreatedAt);

        Page<FanMessage> result = fanMessageMapper.selectPage(new Page<>(page, pageSize), wrapper);

        var list = result.getRecords().stream().map(m -> {
            FanMessageResponse resp = new FanMessageResponse();
            resp.setId(m.getId());
            resp.setFan(new FanMessageResponse.FanMessageFan(fan.getId(), fan.getFanName()));
            resp.setContent(m.getContent());
            resp.setCreatedAt(m.getCreatedAt());
            return resp;
        }).toList();

        return PageResult.of(list, result.getTotal(), page, pageSize);
    }
}
