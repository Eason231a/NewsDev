package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("article_cover_images")
public class ArticleCoverImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private Long materialId;

    private Integer sortOrder;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
