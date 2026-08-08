package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ArticleCreateRequest {

    private Long channelId;

    @NotBlank(message = "文章标题不能为空")
    @Size(max = 255, message = "文章标题最长255字符")
    private String title;

    private String content;

    @Size(max = 20, message = "标签最长20字符")
    private String tag;

    @NotNull(message = "封面类型不能为空")
    private Integer coverType;

    private Integer status;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime scheduledAt;

    private List<Long> coverMaterialIds;
}
