package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("fan_read_hourly")
public class FanReadHourly {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private LocalDate statDate;

    private Integer hour;

    private Integer readCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
