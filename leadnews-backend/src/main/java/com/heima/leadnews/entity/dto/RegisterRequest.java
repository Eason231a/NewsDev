package com.heima.leadnews.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {

    @NotBlank(message = "用户名不能为空")
    @Size(max = 64, message = "用户名最长64个字符")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;

    @NotNull(message = "请先同意用户协议和隐私政策")
    private Boolean agreeTerms;
}
