export interface Material {
  id: number
  filename: string
  url: string
  fileSize: number
  mimeType: string
  isFavorite: number
  createdAt: string
}

export interface MaterialQuery {
  isFavorite?: number
  startDate?: string
  endDate?: string
  page: number
  pageSize: number
}
