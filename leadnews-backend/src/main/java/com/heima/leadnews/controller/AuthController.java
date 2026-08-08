package com.heima.leadnews.controller;

import com.heima.leadnews.common.result.Result;
import com.heima.leadnews.entity.dto.LoginRequest;
import com.heima.leadnews.entity.dto.LoginResponse;
import com.heima.leadnews.entity.dto.RegisterRequest;
import com.heima.leadnews.entity.dto.UserResponse;
import com.heima.leadnews.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "认证模块")
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "用户登录")
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return Result.success(authService.login(request));
    }

    @Operation(summary = "用户注册")
    @PostMapping("/register")
    public Result<UserResponse> register(@Valid @RequestBody RegisterRequest request) {
        return Result.success(authService.register(request));
    }

    @Operation(summary = "刷新Token")
    @PostMapping("/refresh")
    public Result<LoginResponse> refresh() {
        return Result.success(authService.refresh());
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/me")
    public Result<UserResponse> me() {
        return Result.success(authService.getCurrentUser());
    }
}
