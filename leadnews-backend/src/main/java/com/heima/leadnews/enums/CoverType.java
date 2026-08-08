package com.heima.leadnews.enums;

import lombok.Getter;

@Getter
public enum CoverType {

    SINGLE(0, "单图"),
    THREE(1, "三图"),
    NONE(2, "无图");

    private final int code;
    private final String label;

    CoverType(int code, String label) {
        this.code = code;
        this.label = label;
    }

    public static String getLabel(int code) {
        for (CoverType t : values()) {
            if (t.code == code) return t.label;
        }
        return null;
    }
}
