package com.heima.leadnews.common.utils;

import java.io.InputStream;

public interface FileStorageService {

    /**
     * @param inputStream 文件输入流
     * @param originalFilename 原始文件名
     * @param userId 用户ID（用于隔离目录）
     * @return 文件访问URL
     */
    String upload(InputStream inputStream, String originalFilename, Long userId);

    /**
     * @param filePath 文件路径/URL
     */
    void delete(String filePath);
}
