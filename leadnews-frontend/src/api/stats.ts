import request from '@/utils/request'
import type { ApiResponse, PageResponse } from '@/types/api'
import type {
  StatsOverview,
  ArticleStatsItem,
  ArticleStatsDetail,
  ReadSourcesResponse,
  ReadCompletionResponse,
} from '@/types/stats'

export function getStatsOverview(params?: { startDate?: string; endDate?: string }) {
  return request.get<ApiResponse<StatsOverview>>('/article-stats/overview', { params })
}

export function getArticleStats(params: {
  startDate?: string
  endDate?: string
  page: number
  pageSize: number
}) {
  return request.get<ApiResponse<PageResponse<ArticleStatsItem>>>('/article-stats', { params })
}

export function getArticleStatsDetail(articleId: number, params?: { startDate?: string; endDate?: string }) {
  return request.get<ApiResponse<ArticleStatsDetail>>(`/article-stats/${articleId}`, { params })
}

export function getReadSources(articleId: number, params?: { startDate?: string; endDate?: string }) {
  return request.get<ApiResponse<ReadSourcesResponse>>(`/article-stats/${articleId}/read-sources`, { params })
}

export function getReadCompletion(articleId: number, params?: { startDate?: string; endDate?: string }) {
  return request.get<ApiResponse<ReadCompletionResponse>>(`/article-stats/${articleId}/read-completion`, { params })
}
