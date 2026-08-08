export interface ArticleCreateRequest {
  channelId?: number
  title: string
  content?: string
  tag?: string
  coverType?: number
  coverMaterialIds?: number[]
  scheduledAt?: string
}

export interface ArticleDetail {
  id: number
  userId: number
  username: string
  channelId: number
  channelName: string
  title: string
  content: string
  tag: string
  coverType: number
  status: number
  reviewComment: string | null
  scheduledAt: string | null
  publishedAt: string | null
  createdAt: string
  updatedAt: string
  covers: CoverImage[]
}

export interface CoverImage {
  id: number
  materialId: number
  sortOrder: number
  url: string
}

export interface ArticleQuery {
  status?: number
  channelId?: number
  keyword?: string
  startDate?: string
  endDate?: string
  sortBy?: string
  order?: string
  page: number
  pageSize: number
}

export interface ArticleListItem {
  id: number
  title: string
  status: number
  coverType: number
  channelName: string
  createdAt: string
  updatedAt: string
  covers: CoverImage[]
}
