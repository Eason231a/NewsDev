import request from '@/utils/request'
import type { ApiResponse, PageResponse } from '@/types/api'
import type {
  FanStatsOverview,
  FanStatsItem,
  TrendData,
  Fan,
  PortraitAllResponse,
} from '@/types/fan'

export function getFanOverview(params?: { startDate?: string; endDate?: string }) {
  return request.get<ApiResponse<FanStatsOverview>>('/fan-stats/overview', { params })
}

export function getFanStats(params: {
  startDate?: string
  endDate?: string
  page: number
  pageSize: number
}) {
  return request.get<ApiResponse<PageResponse<FanStatsItem>>>('/fan-stats', { params })
}

export function getTrend(params?: { statDate?: string }) {
  return request.get<ApiResponse<TrendData>>('/fan-stats/trend', { params })
}

export function getFanPortrait(params?: { statDate?: string }) {
  return request.get<ApiResponse<PortraitAllResponse>>('/fan-stats/portrait', { params })
}

export function getFans(params: { isBlocked?: number; page: number; pageSize: number }) {
  return request.get<ApiResponse<PageResponse<Fan>>>('/fans', { params })
}

export function blockFan(id: number) {
  return request.patch<ApiResponse<null>>(`/fans/${id}/block`)
}

export function unblockFan(id: number) {
  return request.patch<ApiResponse<null>>(`/fans/${id}/unblock`)
}

export function sendMessage(data: { fanId: number; content: string }) {
  return request.post<ApiResponse<null>>('/fan-messages', data)
}
