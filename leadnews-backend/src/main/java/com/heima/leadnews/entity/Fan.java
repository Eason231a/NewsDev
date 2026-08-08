package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("fans")
public class Fan {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String fanName;

    private String fanAvatar;

    private Integer isBlocked;

    private LocalDateTime followedAt;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
