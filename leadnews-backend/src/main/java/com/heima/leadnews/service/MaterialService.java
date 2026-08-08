package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.exception.BusinessException;
import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.utils.FileStorageService;
import com.heima.leadnews.config.FileUploadConfig;
import com.heima.leadnews.entity.Material;
import com.heima.leadnews.mapper.MaterialMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MaterialService {

    private final MaterialMapper materialMapper;
    private final FileStorageService fileStorageService;
    private final FileUploadConfig fileUploadConfig;

    public PageResult<Material> list(int page, int pageSize, Integer isFavorite) {
        Long userId = UserContext.getUserId();
        LambdaQueryWrapper<Material> wrapper = new LambdaQueryWrapper<Material>()
                .eq(Material::getUserId, userId)
                .eq(isFavorite != null, Material::getIsFavorite, isFavorite)
                .orderByDesc(Material::getCreatedAt);
        Page<Material> result = materialMapper.selectPage(new Page<>(page, pageSize), wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }

    public Material getById(Long id) {
        Material material = materialMapper.selectById(id);
        if (material == null) {
            throw new BusinessException(404, "素材不存在");
        }
        if (!material.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException(403, "无权访问该素材");
        }
        return material;
    }

    @Transactional
    public Material upload(MultipartFile file) {
        validateFile(file);

        Long userId = UserContext.getUserId();
        String url;
        try {
            url = fileStorageService.upload(file.getInputStream(), file.getOriginalFilename(), userId);
        } catch (IOException e) {
            throw new RuntimeException("文件上传失败", e);
        }

        Material material = new Material();
        material.setUserId(userId);
        material.setFilename(file.getOriginalFilename());
        material.setFilePath(url);
        material.setFileSize((int) file.getSize());
        material.setMimeType(file.getContentType());
        material.setIsFavorite(0);
        materialMapper.insert(material);

        return material;
    }

    @Transactional
    public void delete(Long id) {
        Material material = getById(id);
        // 注意：已被设为文章封面的素材不允许删除，由数据库 RESTRICT 约束保证
        materialMapper.deleteById(id);
    }

    @Transactional
    public void restore(Long id) {
        materialMapper.recoverById(id);
    }

    @Transactional
    public void toggleFavorite(Long id, Integer isFavorite) {
        Material material = getById(id);
        material.setIsFavorite(isFavorite);
        materialMapper.updateById(material);
    }

    private void validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BusinessException(400, "文件不能为空");
        }
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.contains(".")) {
            throw new BusinessException(422, "无法识别的文件类型");
        }
        String ext = originalFilename.substring(originalFilename.lastIndexOf('.') + 1).toLowerCase();
        List<String> allowed = Arrays.asList(fileUploadConfig.getAllowedExtensions().split(","));
        if (!allowed.contains(ext)) {
            throw new BusinessException(422, "不支持的文件类型，仅允许 " + String.join(", ", allowed));
        }
    }
}
