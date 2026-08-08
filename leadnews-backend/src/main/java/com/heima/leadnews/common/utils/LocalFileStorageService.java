package com.heima.leadnews.common.utils;

import com.heima.leadnews.config.FileUploadConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "upload", name = "mode", havingValue = "local", matchIfMissing = true)
public class LocalFileStorageService implements FileStorageService {

    private final FileUploadConfig config;

    @Override
    public String upload(InputStream inputStream, String originalFilename, Long userId) {
        String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String ext = getExtension(originalFilename);
        String newFilename = UUID.randomUUID().toString().replace("-", "") + "." + ext;
        String relativePath = String.format("materials/%d/%s/%s", userId, dateStr, newFilename);

        Path targetPath = Path.of(config.getLocalPath(), relativePath);
        try {
            Files.createDirectories(targetPath.getParent());
            Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
            log.info("File saved: {}", targetPath);
        } catch (IOException e) {
            throw new RuntimeException("文件保存失败", e);
        }

        return "/uploads/" + relativePath;
    }

    @Override
    public void delete(String filePath) {
        if (filePath == null || !filePath.startsWith("/uploads/")) {
            return;
        }
        try {
            Path targetPath = Path.of(config.getLocalPath(), filePath.substring("/uploads/".length()));
            Files.deleteIfExists(targetPath);
            log.info("File deleted: {}", targetPath);
        } catch (IOException e) {
            log.warn("Failed to delete file: {}", filePath, e);
        }
    }

    private String getExtension(String filename) {
        int idx = filename.lastIndexOf('.');
        return idx > 0 ? filename.substring(idx + 1).toLowerCase() : "jpg";
    }
}
