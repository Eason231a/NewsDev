package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.exception.BusinessException;
import com.heima.leadnews.entity.Channel;
import com.heima.leadnews.mapper.ChannelMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChannelService {

    private final ChannelMapper channelMapper;

    public List<Channel> list(Boolean isEnabled) {
        LambdaQueryWrapper<Channel> wrapper = new LambdaQueryWrapper<Channel>()
                .eq(isEnabled != null, Channel::getIsEnabled, isEnabled != null && isEnabled ? 1 : 0)
                .orderByAsc(Channel::getSortOrder);
        return channelMapper.selectList(wrapper);
    }

    public Channel getById(Long id) {
        Channel channel = channelMapper.selectById(id);
        if (channel == null) {
            throw new BusinessException(404, "频道不存在");
        }
        return channel;
    }

    @Transactional
    public Channel create(Channel channel) {
        requireAuth();
        if (existsByName(channel.getName())) {
            throw new BusinessException(409, "频道名称已存在");
        }
        if (channel.getSortOrder() == null) {
            channel.setSortOrder(0);
        }
        if (channel.getIsEnabled() == null) {
            channel.setIsEnabled(1);
        }
        channelMapper.insert(channel);
        return channel;
    }

    @Transactional
    public Channel update(Long id, Channel data) {
        requireAuth();
        Channel channel = getById(id);
        if (data.getName() != null && !data.getName().equals(channel.getName())) {
            if (existsByName(data.getName())) {
                throw new BusinessException(409, "频道名称已存在");
            }
            channel.setName(data.getName());
        }
        if (data.getDescription() != null) {
            channel.setDescription(data.getDescription());
        }
        if (data.getSortOrder() != null) {
            channel.setSortOrder(data.getSortOrder());
        }
        channelMapper.updateById(channel);
        return channel;
    }

    @Transactional
    public void setStatus(Long id, Integer isEnabled) {
        requireAuth();
        Channel channel = getById(id);
        channel.setIsEnabled(isEnabled);
        channelMapper.updateById(channel);
    }

    private boolean existsByName(String name) {
        return channelMapper.exists(
                new LambdaQueryWrapper<Channel>().eq(Channel::getName, name));
    }

    private void requireAuth() {
        if (UserContext.getUserId() == null) {
            throw new BusinessException(401, "未认证或Token已过期");
        }
    }
}
