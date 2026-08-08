import request from '@/utils/request'
import type { LoginRequest, LoginResponse, UserInfo } from '@/types/user'
import type { ApiResponse } from '@/types/api'

export function login(data: LoginRequest) {
  return request.post<ApiResponse<LoginResponse>>('/auth/login', data)
}

export function getUserInfo() {
  return request.get<ApiResponse<UserInfo>>('/auth/me')
}

export function refreshToken() {
  return request.post<ApiResponse<{ token: string }>>('/auth/refresh')
}
