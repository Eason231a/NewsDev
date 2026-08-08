package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.exception.BusinessException;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.entity.Article;
import com.heima.leadnews.entity.ArticleCoverImage;
import com.heima.leadnews.entity.ArticleReviewLog;
import com.heima.leadnews.entity.Channel;
import com.heima.leadnews.entity.Material;
import com.heima.leadnews.entity.dto.ArticleCreateRequest;
import com.heima.leadnews.entity.dto.ArticleResponse;
import com.heima.leadnews.entity.dto.CoverImageVO;
import com.heima.leadnews.entity.dto.CoversResponse;
import com.heima.leadnews.entity.dto.EnumResponse;
import com.heima.leadnews.entity.dto.EnumValue;
import com.heima.leadnews.enums.ArticleStatus;
import com.heima.leadnews.enums.CoverType;
import com.heima.leadnews.mapper.ArticleCoverImageMapper;
import com.heima.leadnews.mapper.ArticleMapper;
import com.heima.leadnews.mapper.ArticleReviewLogMapper;
import com.heima.leadnews.mapper.ChannelMapper;
import com.heima.leadnews.mapper.MaterialMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleService {

    private final ArticleMapper articleMapper;
    private final ArticleCoverImageMapper coverImageMapper;
    private final ArticleReviewLogMapper reviewLogMapper;
    private final ChannelMapper channelMapper;
    private final MaterialMapper materialMapper;

    @Transactional
    public ArticleResponse create(ArticleCreateRequest request) {
        Long userId = UserContext.getUserId();
        validateCover(request.getCoverType(), request.getCoverMaterialIds());

        Article article = new Article();
        article.setUserId(userId);
        article.setChannelId(request.getChannelId());
        article.setTitle(request.getTitle());
        article.setContent(request.getContent());
        article.setTag(request.getTag());
        article.setCoverType(request.getCoverType());
        int status = request.getStatus() != null ? request.getStatus() : 0;
        if (status != 0 && status != 1) {
            throw new BusinessException(422, "创建时status只能为0(草稿)或1(待审核)");
        }
        article.setStatus(status);
        article.setScheduledAt(request.getScheduledAt());
        articleMapper.insert(article);

        saveCoverImages(article.getId(), request.getCoverMaterialIds());

        if (status == 1) {
            writeReviewLog(article.getId(), 0, 1, null);
        }

        return toResponse(article);
    }

    @Transactional
    public ArticleResponse update(Long id, ArticleCreateRequest request) {
        Article article = getArticleWithCheck(id);

        if (article.getStatus() != 0 && article.getStatus() != 3) {
            throw new BusinessException(422, "仅草稿和审核失败状态可编辑");
        }

        validateCover(request.getCoverType(), request.getCoverMaterialIds());

        article.setChannelId(request.getChannelId());
        article.setTitle(request.getTitle());
        article.setContent(request.getContent());
        article.setTag(request.getTag());
        article.setCoverType(request.getCoverType());
        article.setScheduledAt(request.getScheduledAt());

        int newStatus = request.getStatus() != null ? request.getStatus() : article.getStatus();
        if (newStatus != 0 && newStatus != 1) {
            throw new BusinessException(422, "status只能为0(草稿)或1(待审核)");
        }

        if (newStatus == 1 && article.getStatus() == 0) {
            writeReviewLog(article.getId(), 0, 1, null);
        }

        article.setStatus(newStatus);
        articleMapper.updateById(article);

        coverImageMapper.delete(
                new LambdaQueryWrapper<ArticleCoverImage>().eq(ArticleCoverImage::getArticleId, id));
        saveCoverImages(id, request.getCoverMaterialIds());

        return toResponse(article);
    }

    public ArticleResponse getById(Long id) {
        Article article = getArticleWithCheck(id);
        return toResponse(article);
    }

    public PageResult<ArticleResponse> list(int page, int pageSize, Integer status, Long channelId,
                                             String keyword, String startDate, String endDate,
                                             String sortBy, String order) {
        Long userId = UserContext.getUserId();
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<Article>()
                .eq(Article::getUserId, userId)
                .eq(status != null, Article::getStatus, status)
                .eq(channelId != null, Article::getChannelId, channelId)
                .like(StringUtils.hasText(keyword), Article::getTitle, keyword);

        if (StringUtils.hasText(startDate)) {
            wrapper.ge(Article::getCreatedAt, LocalDate.parse(startDate).atStartOfDay());
        }
        if (StringUtils.hasText(endDate)) {
            wrapper.le(Article::getCreatedAt, LocalDate.parse(endDate).atTime(LocalTime.MAX));
        }

        boolean isAsc = "asc".equalsIgnoreCase(order);
        if ("updatedAt".equals(sortBy)) {
            wrapper.orderBy(true, isAsc, Article::getUpdatedAt);
        } else {
            wrapper.orderBy(true, isAsc, Article::getCreatedAt);
        }

        Page<Article> result = articleMapper.selectPage(new Page<>(page, pageSize), wrapper);

        List<ArticleResponse> list = result.getRecords().stream()
                .map(this::toResponse)
                .toList();

        return PageResult.of(list, result.getTotal(), page, pageSize);
    }

    @Transactional
    public void changeStatus(Long id, Integer newStatus, String comment) {
        Article article = getArticleWithCheck(id);
        int fromStatus = article.getStatus();
        ArticleStatus.validateTransition(fromStatus, newStatus);

        article.setStatus(newStatus);
        if (newStatus == 4) {
            article.setPublishedAt(LocalDateTime.now());
        }
        if (newStatus == 3 && !StringUtils.hasText(comment)) {
            throw new BusinessException(422, "审核失败时必须填写审核意见");
        }
        article.setReviewComment(comment);
        articleMapper.updateById(article);

        writeReviewLog(article.getId(), fromStatus, newStatus, comment);
    }

    @Transactional
    public void delete(Long id) {
        Article article = getArticleWithCheck(id);
        if (article.getStatus() != 0 && article.getStatus() != 3) {
            throw new BusinessException(422, "仅草稿和审核失败状态可删除");
        }
        articleMapper.deleteById(id);
    }

    @Transactional
    public void restore(Long id) {
        articleMapper.recoverById(id);
    }

    public EnumResponse getEnums(String field) {
        if ("status".equals(field)) {
            List<EnumValue> values = List.of(
                    new EnumValue(0, "草稿", "#909399"),
                    new EnumValue(1, "待审核", "#e6a23c"),
                    new EnumValue(2, "审核通过", "#67c23a"),
                    new EnumValue(3, "审核失败", "#f56c6c"),
                    new EnumValue(4, "已上架", "#409eff"),
                    new EnumValue(5, "已下架", "#909399")
            );
            return new EnumResponse("status", values);
        } else if ("coverType".equals(field)) {
            List<EnumValue> values = List.of(
                    new EnumValue(0, "单图", null),
                    new EnumValue(1, "三图", null),
                    new EnumValue(2, "无图", null)
            );
            return new EnumResponse("coverType", values);
        }
        throw new BusinessException(400, "不支持的枚举字段: " + field);
    }

    public CoversResponse getCovers(Long id) {
        Article article = getArticleWithCheck(id);
        return new CoversResponse(article.getCoverType(), buildCoverImages(id));
    }

    @Transactional
    public void setCovers(Long id, Integer coverType, List<Long> materialIds) {
        Article article = getArticleWithCheck(id);
        if (article.getStatus() != 0 && article.getStatus() != 3) {
            throw new BusinessException(422, "仅草稿和审核失败状态可修改封面");
        }
        validateCover(coverType, materialIds);
        article.setCoverType(coverType);
        articleMapper.updateById(article);

        coverImageMapper.delete(
                new LambdaQueryWrapper<ArticleCoverImage>().eq(ArticleCoverImage::getArticleId, id));
        saveCoverImages(id, materialIds);
    }

    private Article getArticleWithCheck(Long id) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new BusinessException(404, "文章不存在");
        }
        if (!article.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException(403, "无权访问该文章");
        }
        return article;
    }

    private void validateCover(Integer coverType, List<Long> materialIds) {
        if (coverType == null) {
            throw new BusinessException(422, "封面类型不能为空");
        }
        int expected;
        if (coverType == 0) {
            expected = 1;
        } else if (coverType == 1) {
            expected = 3;
        } else if (coverType == 2) {
            expected = 0;
        } else {
            throw new BusinessException(422, "无效的封面类型: " + coverType);
        }
        int actual = materialIds != null ? materialIds.size() : 0;
        if (actual != expected) {
            throw new BusinessException(422,
                    String.format("封面类型为%d时需要%d个素材，实际传入%d个", coverType, expected, actual));
        }
    }

    private void saveCoverImages(Long articleId, List<Long> materialIds) {
        if (materialIds == null || materialIds.isEmpty()) return;
        for (int i = 0; i < materialIds.size(); i++) {
            ArticleCoverImage img = new ArticleCoverImage();
            img.setArticleId(articleId);
            img.setMaterialId(materialIds.get(i));
            img.setSortOrder(i);
            coverImageMapper.insert(img);
        }
    }

    private void writeReviewLog(Long articleId, int fromStatus, int toStatus, String comment) {
        ArticleReviewLog log = new ArticleReviewLog();
        log.setArticleId(articleId);
        log.setFromStatus(fromStatus);
        log.setToStatus(toStatus);
        log.setComment(comment);
        log.setReviewedAt(LocalDateTime.now());
        reviewLogMapper.insert(log);
    }

    private ArticleResponse toResponse(Article article) {
        ArticleResponse resp = new ArticleResponse();
        resp.setId(article.getId());
        resp.setUserId(article.getUserId());
        resp.setChannelId(article.getChannelId());
        resp.setTitle(article.getTitle());
        resp.setContent(article.getContent());
        resp.setTag(article.getTag());
        resp.setCoverType(article.getCoverType());
        resp.setStatus(article.getStatus());
        resp.setReviewComment(article.getReviewComment());
        resp.setScheduledAt(article.getScheduledAt());
        resp.setPublishedAt(article.getPublishedAt());
        resp.setCreatedAt(article.getCreatedAt());
        resp.setUpdatedAt(article.getUpdatedAt());

        if (article.getChannelId() != null) {
            Channel channel = channelMapper.selectById(article.getChannelId());
            if (channel != null) {
                resp.setChannelName(channel.getName());
            }
        }

        resp.setCoverImages(buildCoverImages(article.getId()));
        return resp;
    }

    private List<CoverImageVO> buildCoverImages(Long articleId) {
        List<ArticleCoverImage> images = coverImageMapper.selectList(
                new LambdaQueryWrapper<ArticleCoverImage>()
                        .eq(ArticleCoverImage::getArticleId, articleId)
                        .orderByAsc(ArticleCoverImage::getSortOrder));
        List<CoverImageVO> vos = new ArrayList<>();
        for (ArticleCoverImage img : images) {
            Material material = materialMapper.selectById(img.getMaterialId());
            String url = material != null ? material.getFilePath() : null;
            vos.add(new CoverImageVO(img.getId(), img.getMaterialId(), url, img.getSortOrder()));
        }
        return vos;
    }
}
