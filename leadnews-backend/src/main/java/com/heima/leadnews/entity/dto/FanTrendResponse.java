package com.heima.leadnews.entity.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class FanTrendResponse {

    private LocalDate statDate;
    private List<HourItem> hours;

    @Data
    public static class HourItem {
        private Integer hour;
        private Integer readCount;

        public HourItem(Integer hour, Integer readCount) {
            this.hour = hour;
            this.readCount = readCount;
        }
    }
}
