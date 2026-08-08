package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.Fan;
import com.heima.leadnews.entity.dto.FanResponse;
import com.heima.leadnews.mapper.FanMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FanService {

    private final FanMapper fanMapper;

    public PageResult<FanResponse> list(int page, int pageSize, Integer isBlocked) {
        Long userId = UserContext.getUserId();

        LambdaQueryWrapper<Fan> wrapper = new LambdaQueryWrapper<Fan>()
                .eq(Fan::getUserId, userId)
                .eq(isBlocked != null, Fan::getIsBlocked, isBlocked)
                .orderByDesc(Fan::getFollowedAt);

        Page<Fan> result = fanMapper.selectPage(new Page<>(page, pageSize), wrapper);

        var list = result.getRecords().stream().map(f -> {
            FanResponse resp = new FanResponse();
            resp.setId(f.getId());
            resp.setFanName(f.getFanName());
            resp.setFanAvatar(f.getFanAvatar());
            resp.setIsBlocked(f.getIsBlocked());
            resp.setFollowedAt(f.getFollowedAt());
            return resp;
        }).toList();

        return PageResult.of(list, result.getTotal(), page, pageSize);
    }

    public void block(Long fanId) {
        Long userId = UserContext.getUserId();
        Fan fan = fanMapper.selectOne(new LambdaQueryWrapper<Fan>()
                .eq(Fan::getId, fanId)
                .eq(Fan::getUserId, userId));
        if (fan == null) return;
        fan.setIsBlocked(1);
        fanMapper.updateById(fan);
    }

    public void unblock(Long fanId) {
        Long userId = UserContext.getUserId();
        Fan fan = fanMapper.selectOne(new LambdaQueryWrapper<Fan>()
                .eq(Fan::getId, fanId)
                .eq(Fan::getUserId, userId));
        if (fan == null) return;
        fan.setIsBlocked(0);
        fanMapper.updateById(fan);
    }
}
