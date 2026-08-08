import request from '@/utils/request'
import type { ApiResponse, PageResponse } from '@/types/api'
import type { ArticleCreateRequest, ArticleDetail, ArticleListItem, ArticleQuery } from '@/types/article'

export function createArticle(data: ArticleCreateRequest) {
  return request.post<ApiResponse<ArticleDetail>>('/articles', data)
}

export function updateArticle(id: number, data: ArticleCreateRequest) {
  return request.put<ApiResponse<ArticleDetail>>(`/articles/${id}`, data)
}

export function getArticleDetail(id: number) {
  return request.get<ApiResponse<ArticleDetail>>(`/articles/${id}`)
}

export function getArticles(params: ArticleQuery) {
  return request.get<ApiResponse<PageResponse<ArticleListItem>>>('/articles', { params })
}

export function deleteArticle(id: number) {
  return request.delete<ApiResponse<null>>(`/articles/${id}`)
}

export function updateArticleStatus(id: number, status: number) {
  return request.patch<ApiResponse<null>>(`/articles/${id}/status`, { status })
}

export function getStatusEnums() {
  return request.get<ApiResponse<Record<number, string>>>('/articles/enums/status')
}

export function getCoverTypeEnums() {
  return request.get<ApiResponse<Record<number, string>>>('/articles/enums/cover-type')
}
