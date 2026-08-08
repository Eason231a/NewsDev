package com.heima.leadnews.enums;

import com.heima.leadnews.common.exception.BusinessException;
import lombok.Getter;

import java.util.Map;
import java.util.Set;

@Getter
public enum ArticleStatus {

    DRAFT(0, "草稿"),
    PENDING_REVIEW(1, "待审核"),
    REVIEW_APPROVED(2, "审核通过"),
    REVIEW_FAILED(3, "审核失败"),
    PUBLISHED(4, "已上架"),
    UNPUBLISHED(5, "已下架");

    private final int code;
    private final String label;

    ArticleStatus(int code, String label) {
        this.code = code;
        this.label = label;
    }

    private static final Map<Integer, Set<Integer>> ALLOWED_TRANSITIONS = Map.of(
            0, Set.of(1),           // 草稿 → 待审核
            1, Set.of(2, 3),        // 待审核 → 审核通过/审核失败
            2, Set.of(4),           // 审核通过 → 已上架
            3, Set.of(0),           // 审核失败 → 草稿(重新编辑)
            4, Set.of(5),           // 已上架 → 已下架
            5, Set.of(4)            // 已下架 → 已上架(重新上架)
    );

    public static void validateTransition(int from, int to) {
        Set<Integer> allowed = ALLOWED_TRANSITIONS.get(from);
        if (allowed == null || !allowed.contains(to)) {
            throw new BusinessException(422, "不允许的状态流转: " + from + " → " + to);
        }
    }

    public static String getLabel(int code) {
        for (ArticleStatus s : values()) {
            if (s.code == code) return s.label;
        }
        return null;
    }
}
