package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("article_stats_daily")
public class ArticleStatsDaily {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private LocalDate statDate;

    private Integer readCount;

    private Integer likeCount;

    private Integer commentCount;

    private Integer favoriteCount;

    private Integer shareCount;

    private BigDecimal avgReadProgress;

    private BigDecimal bounceRate;

    private Integer avgReadSeconds;

    private Integer recommendShares;

    private Integer fanReadCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
