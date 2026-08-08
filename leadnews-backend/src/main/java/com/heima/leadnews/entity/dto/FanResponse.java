package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FanResponse {

    private Long id;
    private String fanName;
    private String fanAvatar;
    private Integer isBlocked;
    private LocalDateTime followedAt;
}
