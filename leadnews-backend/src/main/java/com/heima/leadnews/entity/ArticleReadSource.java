package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("article_read_sources")
public class ArticleReadSource {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private LocalDate statDate;

    private Integer sourceType;

    private Integer readCount;

    private BigDecimal percentage;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
