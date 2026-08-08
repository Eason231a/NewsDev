package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("materials")
public class Material {

    @TableId(type = IdType.AUTO)
    private Long id;

    @JsonIgnore
    private Long userId;

    private String filename;

    @JsonProperty("url")
    private String filePath;

    private Integer fileSize;

    private String mimeType;

    private Integer isFavorite;

    @JsonIgnore
    @TableLogic
    private LocalDateTime deletedAt;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
