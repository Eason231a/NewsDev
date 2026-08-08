import axios from 'axios'
import type { AxiosResponse, InternalAxiosRequestConfig } from 'axios'
import { ElMessage } from 'element-plus'
import { getToken, removeToken } from './auth'
import router from '@/router'

const http = axios.create({
  baseURL: '/api',
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor - inject JWT token
http.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getToken()
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  },
)

// Response interceptor - unified error handling, unwrap response body
http.interceptors.response.use(
  (response: AxiosResponse) => {
    const { data } = response
    if (data.code && data.code !== 200 && data.code !== 0) {
      ElMessage.error(data.message || '请求失败')
      return Promise.reject(new Error(data.message || '请求失败'))
    }
    return data
  },
  (error) => {
    if (error.response) {
      const { status } = error.response
      switch (status) {
        case 401:
          removeToken()
          router.push('/login')
          ElMessage.error('登录已过期，请重新登录')
          break
        case 403:
          ElMessage.error('没有权限访问')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 413:
          ElMessage.error('上传文件过大')
          break
        case 422:
          ElMessage.error('请求参数错误')
          break
        case 500:
          ElMessage.error('服务器内部错误')
          break
        default:
          ElMessage.error(error.response.data?.message || '网络错误')
      }
    } else {
      ElMessage.error('网络连接异常')
    }
    return Promise.reject(error)
  },
)

// Typed request methods — the interceptor already unwraps response.data,
// so callers receive the API response body directly.
const request = {
  get<T>(url: string, config?: Record<string, unknown>) {
    return http.get(url, config) as unknown as Promise<T>
  },
  post<T>(url: string, data?: unknown, config?: Record<string, unknown>) {
    return http.post(url, data, config) as unknown as Promise<T>
  },
  put<T>(url: string, data?: unknown, config?: Record<string, unknown>) {
    return http.put(url, data, config) as unknown as Promise<T>
  },
  delete<T>(url: string, config?: Record<string, unknown>) {
    return http.delete(url, config) as unknown as Promise<T>
  },
  patch<T>(url: string, data?: unknown, config?: Record<string, unknown>) {
    return http.patch(url, data, config) as unknown as Promise<T>
  },
}

export default request
