package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("article_read_completion")
public class ArticleReadCompletion {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private LocalDate statDate;

    private Integer completionRange;

    private Integer userCount;

    private BigDecimal percentage;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
