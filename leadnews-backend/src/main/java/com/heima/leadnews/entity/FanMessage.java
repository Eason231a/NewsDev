package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("fan_messages")
public class FanMessage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long fanId;

    private String content;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
