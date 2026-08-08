package com.heima.leadnews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.heima.leadnews.common.context.UserContext;
import com.heima.leadnews.common.exception.BusinessException;
import com.heima.leadnews.entity.User;
import com.heima.leadnews.entity.UserAgreementLog;
import com.heima.leadnews.entity.dto.LoginRequest;
import com.heima.leadnews.entity.dto.LoginResponse;
import com.heima.leadnews.entity.dto.RegisterRequest;
import com.heima.leadnews.entity.dto.UserResponse;
import com.heima.leadnews.mapper.UserAgreementLogMapper;
import com.heima.leadnews.mapper.UserMapper;
import com.heima.leadnews.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;
    private final UserAgreementLogMapper agreementLogMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @Transactional
    public LoginResponse login(LoginRequest request) {
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, request.getUsername()));
        if (user == null) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException(403, "账号已被禁用");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(jwtUtil.getExpiration() / 1000);

        user.setLastLoginAt(LocalDateTime.now());
        userMapper.updateById(user);

        recordAgreement(user.getId(), 0);
        recordAgreement(user.getId(), 1);

        return new LoginResponse(token, expiresAt, UserResponse.from(user));
    }

    @Transactional
    public UserResponse register(RegisterRequest request) {
        boolean exists = userMapper.exists(
                new LambdaQueryWrapper<User>().eq(User::getUsername, request.getUsername()));
        if (exists) {
            throw new BusinessException(409, "用户名已存在");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setStatus(1);
        userMapper.insert(user);

        recordAgreement(user.getId(), 0);
        recordAgreement(user.getId(), 1);

        return UserResponse.from(user);
    }

    public LoginResponse refresh() {
        Long userId = UserContext.getUserId();
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(401, "用户不存在");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(jwtUtil.getExpiration() / 1000);

        return new LoginResponse(token, expiresAt, UserResponse.from(user));
    }

    public UserResponse getCurrentUser() {
        Long userId = UserContext.getUserId();
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(404, "用户不存在");
        }
        return UserResponse.from(user);
    }

    private void recordAgreement(Long userId, int agreementType) {
        UserAgreementLog log = new UserAgreementLog();
        log.setUserId(userId);
        log.setAgreementType(agreementType);
        log.setAgreedAt(LocalDateTime.now());
        agreementLogMapper.insert(log);
    }
}
