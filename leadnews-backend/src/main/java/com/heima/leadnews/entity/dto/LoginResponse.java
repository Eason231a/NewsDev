package com.heima.leadnews.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class LoginResponse {

    private String token;
    private LocalDateTime expiresAt;
    private UserResponse user;
}
