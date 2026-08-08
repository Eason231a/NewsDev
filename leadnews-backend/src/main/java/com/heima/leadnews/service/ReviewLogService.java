package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.Article;
import com.heima.leadnews.entity.ArticleReviewLog;
import com.heima.leadnews.mapper.ArticleMapper;
import com.heima.leadnews.mapper.ArticleReviewLogMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewLogService {

    private final ArticleReviewLogMapper reviewLogMapper;
    private final ArticleMapper articleMapper;

    public PageResult<ArticleReviewLog> list(Long articleId, int page, int pageSize,
                                              String startDate, String endDate) {
        Long userId = UserContext.getUserId();

        Set<Long> userArticleIds = articleMapper.selectList(
                        new LambdaQueryWrapper<Article>()
                                .select(Article::getId)
                                .eq(Article::getUserId, userId))
                .stream()
                .map(Article::getId)
                .collect(Collectors.toSet());

        if (userArticleIds.isEmpty()) {
            return PageResult.of(List.of(), 0L, page, pageSize);
        }

        LambdaQueryWrapper<ArticleReviewLog> wrapper = new LambdaQueryWrapper<ArticleReviewLog>()
                .in(ArticleReviewLog::getArticleId, userArticleIds)
                .eq(articleId != null, ArticleReviewLog::getArticleId, articleId)
                .orderByDesc(ArticleReviewLog::getReviewedAt);

        if (StringUtils.hasText(startDate)) {
            wrapper.ge(ArticleReviewLog::getReviewedAt, LocalDate.parse(startDate).atStartOfDay());
        }
        if (StringUtils.hasText(endDate)) {
            wrapper.le(ArticleReviewLog::getReviewedAt, LocalDate.parse(endDate).atTime(LocalTime.MAX));
        }

        Page<ArticleReviewLog> result = reviewLogMapper.selectPage(new Page<>(page, pageSize), wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }
}
