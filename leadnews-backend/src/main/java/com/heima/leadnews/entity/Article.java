package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("articles")
public class Article {

    @TableId(type = IdType.AUTO)
    private Long id;

    @JsonIgnore
    private Long userId;

    private Long channelId;

    private String title;

    private String content;

    private String tag;

    private Integer coverType;

    private Integer status;

    private String reviewComment;

    private LocalDateTime scheduledAt;

    private LocalDateTime publishedAt;

    @JsonIgnore
    @TableLogic
    private LocalDateTime deletedAt;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
