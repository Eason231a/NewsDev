package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.Fan;
import com.heima.leadnews.entity.FanPortraitData;
import com.heima.leadnews.entity.FanReadHourly;
import com.heima.leadnews.entity.FanStatsDaily;
import com.heima.leadnews.entity.dto.*;
import com.heima.leadnews.mapper.FanMapper;
import com.heima.leadnews.mapper.FanPortraitDataMapper;
import com.heima.leadnews.mapper.FanReadHourlyMapper;
import com.heima.leadnews.mapper.FanStatsDailyMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FanStatsService {

    private final FanStatsDailyMapper fanStatsDailyMapper;
    private final FanReadHourlyMapper fanReadHourlyMapper;
    private final FanPortraitDataMapper fanPortraitDataMapper;
    private final FanMapper fanMapper;

    private static final List<DimensionMeta> DIMENSIONS = List.of(
            new DimensionMeta(0, "性别分布", "doughnut"),
            new DimensionMeta(1, "年龄分布", "bar"),
            new DimensionMeta(2, "地域分布", "map"),
            new DimensionMeta(3, "终端分布", "doughnut"),
            new DimensionMeta(4, "活跃时间", "bar"),
            new DimensionMeta(5, "内容偏好", "bar")
    );

    public FanOverviewResponse getOverview(String startDate, String endDate) {
        Long userId = UserContext.getUserId();

        long totalFanCount = fanMapper.selectCount(
                new LambdaQueryWrapper<Fan>()
                        .eq(Fan::getUserId, userId)
                        .eq(Fan::getIsBlocked, 0));

        LambdaQueryWrapper<FanStatsDaily> wrapper = new LambdaQueryWrapper<FanStatsDaily>()
                .eq(FanStatsDaily::getUserId, userId)
                .ge(StringUtils.hasText(startDate), FanStatsDaily::getStatDate, StringUtils.hasText(startDate) ? LocalDate.parse(startDate) : null)
                .le(StringUtils.hasText(endDate), FanStatsDaily::getStatDate, StringUtils.hasText(endDate) ? LocalDate.parse(endDate) : null);

        List<FanStatsDaily> stats = fanStatsDailyMapper.selectList(wrapper);

        long totalFanReadCount = stats.stream().mapToLong(s -> s.getFanReadCount() != null ? s.getFanReadCount() : 0).sum();
        BigDecimal totalFanRevenue = stats.stream()
                .map(s -> s.getFanRevenue() != null ? s.getFanRevenue() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        long totalUnfollowCount = stats.stream().mapToLong(s -> s.getUnfollowCount() != null ? s.getUnfollowCount() : 0).sum();

        return new FanOverviewResponse(totalFanCount, totalFanReadCount, totalFanRevenue, totalUnfollowCount);
    }

    public PageResult<FanStatsResponse> list(int page, int pageSize, String startDate, String endDate) {
        Long userId = UserContext.getUserId();

        LambdaQueryWrapper<FanStatsDaily> wrapper = new LambdaQueryWrapper<FanStatsDaily>()
                .eq(FanStatsDaily::getUserId, userId)
                .ge(StringUtils.hasText(startDate), FanStatsDaily::getStatDate, StringUtils.hasText(startDate) ? LocalDate.parse(startDate) : null)
                .le(StringUtils.hasText(endDate), FanStatsDaily::getStatDate, StringUtils.hasText(endDate) ? LocalDate.parse(endDate) : null)
                .orderByDesc(FanStatsDaily::getStatDate);

        Page<FanStatsDaily> result = fanStatsDailyMapper.selectPage(new Page<>(page, pageSize), wrapper);

        List<FanStatsResponse> list = result.getRecords().stream().map(s -> {
            FanStatsResponse resp = new FanStatsResponse();
            resp.setId(s.getId());
            resp.setStatDate(s.getStatDate());
            resp.setFanCount(s.getTotalFanCount());
            resp.setFanReadCount(s.getFanReadCount());
            resp.setFanRevenue(s.getFanRevenue());
            resp.setUnfollowCount(s.getUnfollowCount());
            resp.setNewFollowCount(s.getNewFollowCount());
            return resp;
        }).toList();

        return PageResult.of(list, result.getTotal(), page, pageSize);
    }

    public FanTrendResponse getTrend(String statDate) {
        Long userId = UserContext.getUserId();
        LocalDate date = resolveStatDate(userId, statDate);

        List<FanReadHourly> records = fanReadHourlyMapper.selectList(
                new LambdaQueryWrapper<FanReadHourly>()
                        .eq(FanReadHourly::getUserId, userId)
                        .eq(FanReadHourly::getStatDate, date)
                        .orderByAsc(FanReadHourly::getHour));

        List<FanTrendResponse.HourItem> hours = new ArrayList<>();
        for (int h = 0; h < 24; h++) {
            int finalH = h;
            int readCount = records.stream()
                    .filter(r -> r.getHour() == finalH)
                    .findFirst()
                    .map(r -> r.getReadCount() != null ? r.getReadCount() : 0)
                    .orElse(0);
            hours.add(new FanTrendResponse.HourItem(h, readCount));
        }

        FanTrendResponse resp = new FanTrendResponse();
        resp.setStatDate(date);
        resp.setHours(hours);
        return resp;
    }

    public Object getPortrait(String statDate, Integer dimension) {
        Long userId = UserContext.getUserId();
        LocalDate date = resolveStatDate(userId, statDate);
        List<FanPortraitData> records = queryPortraitData(userId, date, dimension);

        // Fallback: if no data for resolved date, try latest portrait date
        if (records.isEmpty()) {
            List<FanPortraitData> latestPortrait = fanPortraitDataMapper.selectList(
                    new LambdaQueryWrapper<FanPortraitData>()
                            .eq(FanPortraitData::getUserId, userId)
                            .orderByDesc(FanPortraitData::getStatDate)
                            .last("LIMIT 1"));
            if (!latestPortrait.isEmpty()) {
                date = latestPortrait.get(0).getStatDate();
                records = queryPortraitData(userId, date, dimension);
            }
        }

        final List<FanPortraitData> finalRecords = records;
        final LocalDate finalDate = date;

        if (dimension != null) {
            DimensionMeta meta = getDimensionMeta(dimension);
            List<PortraitItemResponse> items = finalRecords.stream()
                    .map(r -> new PortraitItemResponse(
                            r.getDimensionKey(),
                            resolveKeyLabel(r.getDimension(), r.getDimensionKey()),
                            r.getDimensionValue(),
                            r.getPercentage()))
                    .toList();
            return new PortraitSingleResponse(finalDate, dimension, meta.getLabel(), meta.getChartType(), items);
        }

        List<PortraitDimensionResponse> portraits = DIMENSIONS.stream().map(meta -> {
            List<PortraitItemResponse> items = finalRecords.stream()
                    .filter(r -> r.getDimension().equals(meta.getValue()))
                    .map(r -> new PortraitItemResponse(
                            r.getDimensionKey(),
                            resolveKeyLabel(r.getDimension(), r.getDimensionKey()),
                            r.getDimensionValue(),
                            r.getPercentage()))
                    .toList();
            return new PortraitDimensionResponse(meta.getValue(), meta.getLabel(), meta.getChartType(), items);
        }).toList();

        return new PortraitAllResponse(finalDate, portraits);
    }

    public DimensionListResponse getPortraitDimensions() {
        return new DimensionListResponse(DIMENSIONS);
    }

    private DimensionMeta getDimensionMeta(int dimension) {
        return DIMENSIONS.stream().filter(d -> d.getValue() == dimension).findFirst().orElse(null);
    }

    private LocalDate resolveStatDate(Long userId, String statDate) {
        if (StringUtils.hasText(statDate)) {
            LocalDate requested = LocalDate.parse(statDate);
            Long count = fanReadHourlyMapper.selectCount(
                    new LambdaQueryWrapper<FanReadHourly>()
                            .eq(FanReadHourly::getUserId, userId)
                            .eq(FanReadHourly::getStatDate, requested));
            if (count > 0) return requested;
        }
        List<FanReadHourly> latest = fanReadHourlyMapper.selectList(
                new LambdaQueryWrapper<FanReadHourly>()
                        .eq(FanReadHourly::getUserId, userId)
                        .orderByDesc(FanReadHourly::getStatDate)
                        .last("LIMIT 1"));
        if (!latest.isEmpty()) return latest.get(0).getStatDate();
        return StringUtils.hasText(statDate) ? LocalDate.parse(statDate) : LocalDate.now();
    }

    private List<FanPortraitData> queryPortraitData(Long userId, LocalDate date, Integer dimension) {
        LambdaQueryWrapper<FanPortraitData> wrapper = new LambdaQueryWrapper<FanPortraitData>()
                .eq(FanPortraitData::getUserId, userId)
                .eq(FanPortraitData::getStatDate, date)
                .orderByAsc(FanPortraitData::getDimension)
                .orderByDesc(FanPortraitData::getDimensionValue);
        if (dimension != null) {
            wrapper.eq(FanPortraitData::getDimension, dimension);
        }
        return fanPortraitDataMapper.selectList(wrapper);
    }

    private String resolveKeyLabel(int dimension, String key) {
        if (dimension == 0) {
            return switch (key) {
                case "male" -> "男";
                case "female" -> "女";
                default -> key;
            };
        }
        return key;
    }
}
