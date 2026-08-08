package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("article_review_logs")
public class ArticleReviewLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private Long reviewerId;

    private Integer fromStatus;

    private Integer toStatus;

    private String comment;

    private LocalDateTime reviewedAt;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
