package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.PageResult;
import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.Material;
import com.heima.leadnews.entity.dto.FavoriteRequest;
import com.heima.leadnews.service.MaterialService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "素材管理")
@RestController
@RequestMapping("/materials")
@RequiredArgsConstructor
public class MaterialController {

    private final MaterialService materialService;

    @Operation(summary = "素材列表")
    @GetMapping
    public Result<PageResult<Material>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer isFavorite) {
        return Result.success(materialService.list(page, pageSize, isFavorite));
    }

    @Operation(summary = "素材详情")
    @GetMapping("/{id}")
    public Result<Material> detail(@PathVariable Long id) {
        return Result.success(materialService.getById(id));
    }

    @Operation(summary = "上传素材")
    @PostMapping("/upload")
    public Result<Material> upload(@RequestParam("file") MultipartFile file) {
        return Result.success(materialService.upload(file));
    }

    @Operation(summary = "删除素材")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        materialService.delete(id);
        return Result.success();
    }

    @Operation(summary = "恢复素材")
    @PatchMapping("/{id}/restore")
    public Result<Void> restore(@PathVariable Long id) {
        materialService.restore(id);
        return Result.success();
    }

    @Operation(summary = "切换收藏状态")
    @PatchMapping("/{id}/favorite")
    public Result<Void> favorite(@PathVariable Long id,
                                  @Valid @RequestBody FavoriteRequest request) {
        materialService.toggleFavorite(id, request.getIsFavorite());
        return Result.success();
    }
}
