package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.exception.BusinessException;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.*;
import com.heima.leadnews.entity.dto.*;
import com.heima.leadnews.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ArticleStatsService {

    private static final Map<Integer, String> SOURCE_LABELS = Map.of(
            0, "推荐", 1, "频道", 2, "相关阅读", 3, "应用外", 4, "其他");
    private static final Map<Integer, String> SOURCE_COLORS = Map.of(
            0, "#1890ff", 1, "#52c41a", 2, "#722ed1", 3, "#faad14", 4, "#ff4d4f");
    private static final Map<Integer, String> COMPLETION_LABELS = Map.of(
            0, "低于20%", 1, "20%-80%", 2, "高于80%");
    private static final Map<Integer, String> COMPLETION_COLORS = Map.of(
            0, "#1890ff", 1, "#52c41a", 2, "#722ed1");

    private final ArticleMapper articleMapper;
    private final ArticleStatsDailyMapper statsDailyMapper;
    private final ArticleReadSourceMapper readSourceMapper;
    private final ArticleReadCompletionMapper readCompletionMapper;
    private final MaterialMapper materialMapper;

    public StatsOverviewResponse getOverview(String startDate, String endDate) {
        Long userId = UserContext.getUserId();
        Set<Long> articleIds = getUserArticleIds(userId);

        long totalPublishCount = articleMapper.selectCount(new LambdaQueryWrapper<Article>()
                .eq(Article::getUserId, userId)
                .in(Article::getStatus, List.of(4, 5))
                .ge(StringUtils.hasText(startDate), Article::getPublishedAt, parseStart(startDate))
                .le(StringUtils.hasText(endDate), Article::getPublishedAt, parseEnd(endDate)));

        Long totalFavoriteCount = materialMapper.selectCount(new LambdaQueryWrapper<Material>()
                .eq(Material::getUserId, userId)
                .eq(Material::getIsFavorite, 1));
        Long totalLikeCount = 0L;
        Long totalShareCount = 0L;

        if (!articleIds.isEmpty()) {
            List<ArticleStatsDaily> stats = statsDailyMapper.selectList(
                    new LambdaQueryWrapper<ArticleStatsDaily>()
                            .select(ArticleStatsDaily::getLikeCount,
                                    ArticleStatsDaily::getShareCount)
                            .in(ArticleStatsDaily::getArticleId, articleIds)
                            .ge(StringUtils.hasText(startDate), ArticleStatsDaily::getStatDate, parseStartDate(startDate))
                            .le(StringUtils.hasText(endDate), ArticleStatsDaily::getStatDate, parseEndDate(endDate)));

            totalLikeCount = stats.stream().mapToLong(s -> s.getLikeCount()).sum();
            totalShareCount = stats.stream().mapToLong(s -> s.getShareCount()).sum();
        }

        return new StatsOverviewResponse(totalPublishCount, totalLikeCount, totalFavoriteCount, totalShareCount);
    }

    public PageResult<ArticleStatsResponse> list(int page, int pageSize, String startDate,
                                                  String endDate, String sortBy, String order) {
        Long userId = UserContext.getUserId();
        Set<Long> articleIds = getUserArticleIds(userId);

        if (articleIds.isEmpty()) {
            return PageResult.of(List.of(), 0L, page, pageSize);
        }

        LambdaQueryWrapper<ArticleStatsDaily> wrapper = new LambdaQueryWrapper<ArticleStatsDaily>()
                .in(ArticleStatsDaily::getArticleId, articleIds)
                .ge(StringUtils.hasText(startDate), ArticleStatsDaily::getStatDate, parseStartDate(startDate))
                .le(StringUtils.hasText(endDate), ArticleStatsDaily::getStatDate, parseEndDate(endDate));

        boolean isAsc = "asc".equalsIgnoreCase(order);
        String sortCol = StringUtils.hasText(sortBy) ? sortBy : "readCount";
        applySort(wrapper, sortCol, isAsc);

        Page<ArticleStatsDaily> result = statsDailyMapper.selectPage(new Page<>(page, pageSize), wrapper);

        Map<Long, String> titleMap = getArticleTitleMap(
                result.getRecords().stream().map(ArticleStatsDaily::getArticleId).distinct().toList());

        List<ArticleStatsResponse> list = result.getRecords().stream().map(s -> {
            ArticleStatsResponse resp = new ArticleStatsResponse();
            resp.setArticleId(s.getArticleId());
            resp.setArticleTitle(titleMap.get(s.getArticleId()));
            resp.setStatDate(s.getStatDate());
            resp.setReadCount(s.getReadCount());
            resp.setLikeCount(s.getLikeCount());
            resp.setCommentCount(s.getCommentCount());
            resp.setFavoriteCount(s.getFavoriteCount());
            resp.setShareCount(s.getShareCount());
            resp.setFanReadCount(s.getFanReadCount());
            return resp;
        }).toList();

        return PageResult.of(list, result.getTotal(), page, pageSize);
    }

    public ArticleDetailStatsResponse getArticleDetail(Long articleId, String startDate, String endDate) {
        Article article = getArticleWithCheck(articleId);

        LambdaQueryWrapper<ArticleStatsDaily> wrapper = new LambdaQueryWrapper<ArticleStatsDaily>()
                .eq(ArticleStatsDaily::getArticleId, articleId)
                .ge(StringUtils.hasText(startDate), ArticleStatsDaily::getStatDate, parseStartDate(startDate))
                .le(StringUtils.hasText(endDate), ArticleStatsDaily::getStatDate, parseEndDate(endDate));

        List<ArticleStatsDaily> stats = statsDailyMapper.selectList(wrapper);

        ArticleDetailStatsResponse.Summary summary = new ArticleDetailStatsResponse.Summary();
        summary.setTotalReadCount(stats.stream().mapToLong(s -> s.getReadCount()).sum());
        summary.setTotalLikeCount(stats.stream().mapToLong(s -> s.getLikeCount()).sum());
        summary.setTotalCommentCount(stats.stream().mapToLong(s -> s.getCommentCount()).sum());
        summary.setTotalFavoriteCount(stats.stream().mapToLong(s -> s.getFavoriteCount()).sum());
        summary.setTotalShareCount(stats.stream().mapToLong(s -> s.getShareCount()).sum());
        summary.setTotalRecommendShares(stats.stream().mapToLong(s -> s.getRecommendShares()).sum());
        summary.setTotalFanReadCount(stats.stream().mapToLong(s -> s.getFanReadCount()).sum());
        summary.setAvgReadProgress(avgDecimal(stats, ArticleStatsDaily::getAvgReadProgress));
        summary.setBounceRate(avgDecimal(stats, ArticleStatsDaily::getBounceRate));
        summary.setAvgReadSeconds((int) stats.stream().mapToInt(s ->
                s.getAvgReadSeconds() != null ? s.getAvgReadSeconds() : 0).average().orElse(0));

        List<ArticleDetailStatsResponse.Daily> daily = stats.stream().map(s -> {
            ArticleDetailStatsResponse.Daily d = new ArticleDetailStatsResponse.Daily();
            d.setStatDate(s.getStatDate());
            d.setReadCount(s.getReadCount());
            d.setLikeCount(s.getLikeCount());
            d.setCommentCount(s.getCommentCount());
            d.setFavoriteCount(s.getFavoriteCount());
            d.setShareCount(s.getShareCount());
            return d;
        }).toList();

        ArticleDetailStatsResponse resp = new ArticleDetailStatsResponse();
        resp.setArticleId(articleId);
        resp.setArticleTitle(article.getTitle());
        resp.setSummary(summary);
        resp.setDaily(daily);
        return resp;
    }

    public ReadSourceResponse getReadSources(Long articleId, String statDate) {
        Article article = getArticleWithCheck(articleId);

        LambdaQueryWrapper<ArticleReadSource> wrapper = new LambdaQueryWrapper<ArticleReadSource>()
                .eq(ArticleReadSource::getArticleId, articleId);

        if (StringUtils.hasText(statDate)) {
            wrapper.eq(ArticleReadSource::getStatDate, LocalDate.parse(statDate));
        } else {
            wrapper.orderByDesc(ArticleReadSource::getStatDate).last("LIMIT 5");
        }
        wrapper.orderByAsc(ArticleReadSource::getSourceType);

        List<ArticleReadSource> sources = readSourceMapper.selectList(wrapper);
        LocalDate actualDate = sources.isEmpty() ? null : sources.get(0).getStatDate();

        ReadSourceResponse resp = new ReadSourceResponse();
        resp.setArticleId(articleId);
        resp.setStatDate(actualDate);
        resp.setSources(sources.stream().map(s -> {
            ReadSourceResponse.SourceItem item = new ReadSourceResponse.SourceItem();
            item.setSourceType(s.getSourceType());
            item.setSourceLabel(SOURCE_LABELS.getOrDefault(s.getSourceType(), "未知"));
            item.setReadCount(s.getReadCount());
            item.setPercentage(s.getPercentage() != null ? s.getPercentage().doubleValue() : 0);
            item.setColor(SOURCE_COLORS.getOrDefault(s.getSourceType(), "#909399"));
            return item;
        }).toList());
        return resp;
    }

    public ReadCompletionResponse getReadCompletion(Long articleId, String statDate) {
        Article article = getArticleWithCheck(articleId);

        LambdaQueryWrapper<ArticleReadCompletion> wrapper = new LambdaQueryWrapper<ArticleReadCompletion>()
                .eq(ArticleReadCompletion::getArticleId, articleId);

        if (StringUtils.hasText(statDate)) {
            wrapper.eq(ArticleReadCompletion::getStatDate, LocalDate.parse(statDate));
        } else {
            wrapper.orderByDesc(ArticleReadCompletion::getStatDate).last("LIMIT 3");
        }
        wrapper.orderByAsc(ArticleReadCompletion::getCompletionRange);

        List<ArticleReadCompletion> completions = readCompletionMapper.selectList(wrapper);
        LocalDate actualDate = completions.isEmpty() ? null : completions.get(0).getStatDate();

        ReadCompletionResponse resp = new ReadCompletionResponse();
        resp.setArticleId(articleId);
        resp.setStatDate(actualDate);
        resp.setCompletions(completions.stream().map(c -> {
            ReadCompletionResponse.CompletionItem item = new ReadCompletionResponse.CompletionItem();
            item.setCompletionRange(c.getCompletionRange());
            item.setRangeLabel(COMPLETION_LABELS.getOrDefault(c.getCompletionRange(), "未知"));
            item.setUserCount(c.getUserCount());
            item.setPercentage(c.getPercentage() != null ? c.getPercentage().doubleValue() : 0);
            item.setColor(COMPLETION_COLORS.getOrDefault(c.getCompletionRange(), "#909399"));
            return item;
        }).toList());
        return resp;
    }

    private Article getArticleWithCheck(Long articleId) {
        Article article = articleMapper.selectById(articleId);
        if (article == null) {
            throw new BusinessException(404, "文章不存在");
        }
        if (!article.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException(403, "无权访问该文章");
        }
        return article;
    }

    private Set<Long> getUserArticleIds(Long userId) {
        return articleMapper.selectList(
                        new LambdaQueryWrapper<Article>()
                                .select(Article::getId)
                                .eq(Article::getUserId, userId))
                .stream()
                .map(Article::getId)
                .collect(Collectors.toSet());
    }

    private Map<Long, String> getArticleTitleMap(List<Long> articleIds) {
        if (articleIds.isEmpty()) return Map.of();
        return articleMapper.selectList(
                        new LambdaQueryWrapper<Article>()
                                .select(Article::getId, Article::getTitle)
                                .in(Article::getId, articleIds))
                .stream()
                .collect(Collectors.toMap(Article::getId, Article::getTitle, (a, b) -> a));
    }

    private Double avgDecimal(List<ArticleStatsDaily> stats,
                              java.util.function.Function<ArticleStatsDaily, BigDecimal> getter) {
        return stats.stream()
                .map(getter)
                .filter(Objects::nonNull)
                .mapToDouble(BigDecimal::doubleValue)
                .average()
                .orElse(0);
    }

    private void applySort(LambdaQueryWrapper<ArticleStatsDaily> wrapper, String sortBy, boolean isAsc) {
        switch (sortBy) {
            case "readCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getReadCount);
            case "likeCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getLikeCount);
            case "commentCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getCommentCount);
            case "favoriteCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getFavoriteCount);
            case "shareCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getShareCount);
            case "fanReadCount" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getFanReadCount);
            case "statDate" -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getStatDate);
            default -> wrapper.orderBy(true, isAsc, ArticleStatsDaily::getReadCount);
        }
    }

    private LocalDateTime parseStart(String date) {
        return StringUtils.hasText(date) ? LocalDate.parse(date).atStartOfDay() : null;
    }

    private LocalDateTime parseEnd(String date) {
        return StringUtils.hasText(date) ? LocalDate.parse(date).atTime(LocalTime.MAX) : null;
    }

    private LocalDate parseStartDate(String date) {
        return StringUtils.hasText(date) ? LocalDate.parse(date) : null;
    }

    private LocalDate parseEndDate(String date) {
        return StringUtils.hasText(date) ? LocalDate.parse(date) : null;
    }
}
