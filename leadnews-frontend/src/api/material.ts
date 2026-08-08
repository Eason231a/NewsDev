import request from '@/utils/request'
import type { ApiResponse, PageResponse } from '@/types/api'
import type { Material, MaterialQuery } from '@/types/material'

export function getMaterials(params: MaterialQuery) {
  return request.get<ApiResponse<PageResponse<Material>>>('/materials', { params })
}

export function uploadMaterial(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post<ApiResponse<Material>>('/materials/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

export function toggleFavorite(id: number, isFavorite: number) {
  return request.patch<ApiResponse<null>>(`/materials/${id}/favorite`, { isFavorite })
}

export function deleteMaterial(id: number) {
  return request.delete<ApiResponse<null>>(`/materials/${id}`)
}
