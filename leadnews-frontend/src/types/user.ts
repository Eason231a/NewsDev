export interface LoginRequest {
  username: string
  password: string
  agreeTerms: boolean
}

export interface LoginResponse {
  token: string
  expiresAt: string
  user: UserInfo
}

export interface UserInfo {
  id: number
  username: string
  avatar: string | null
  status: number
  lastLoginAt: string
}
