package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FanMessageResponse {

    private Long id;
    private FanMessageFan fan;
    private String content;
    private LocalDateTime createdAt;

    @Data
    public static class FanMessageFan {
        private Long fanId;
        private String fanName;

        public FanMessageFan(Long fanId, String fanName) {
            this.fanId = fanId;
            this.fanName = fanName;
        }
    }
}
