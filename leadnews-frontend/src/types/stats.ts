export interface StatsOverview {
  totalPublishCount: number
  totalLikeCount: number
  totalFavoriteCount: number
  totalShareCount: number
}

export interface ArticleStatsItem {
  articleId: number
  articleTitle: string
  statDate: string
  readCount: number
  likeCount: number
  commentCount: number
  favoriteCount: number
  shareCount: number
  fanReadCount: number
}

export interface ArticleStatsDetail {
  articleId: number
  articleTitle: string
  summary: StatsDetailSummary
}

export interface StatsDetailSummary {
  totalReadCount: number
  totalLikeCount: number
  totalCommentCount: number
  totalFavoriteCount: number
  totalShareCount: number
  avgReadProgress: number
  bounceRate: number
  avgReadSeconds: number
  totalRecommendShares: number
  totalFanReadCount: number
}

export interface ReadSource {
  sourceType: number
  sourceLabel: string
  readCount: number
  percentage: number
  color: string
}

export interface ReadSourcesResponse {
  articleId: number
  statDate: string
  sources: ReadSource[]
}

export interface ReadCompletion {
  completionRange: number
  rangeLabel: string
  userCount: number
  percentage: number
  color: string
}

export interface ReadCompletionResponse {
  articleId: number
  statDate: string
  completions: ReadCompletion[]
}
