export interface FanStatsOverview {
  totalFanCount: number
  totalFanReadCount: number
  totalFanRevenue: number
  totalUnfollowCount: number
}

export interface FanStatsItem {
  id: number
  statDate: string
  fanCount: number
  fanReadCount: number
  fanRevenue: number
  unfollowCount: number
  newFollowCount: number
}

export interface TrendPoint {
  hour: number
  readCount: number
}

export interface TrendData {
  statDate: string
  hours: TrendPoint[]
}

export interface Fan {
  id: number
  fanName: string
  fanAvatar: string | null
  isBlocked: number
  followedAt: string
}

export interface FanMessageRequest {
  content: string
}

export interface PortraitItem {
  dimensionKey: string
  dimensionKeyLabel: string
  dimensionValue: number
  percentage: number
}

export interface PortraitDimensionData {
  dimension: number
  dimensionLabel: string
  chartType: string
  items: PortraitItem[]
}

export interface PortraitAllResponse {
  statDate: string
  portraits: PortraitDimensionData[]
}

export interface PortraitSingleResponse {
  statDate: string
  dimension: number
  dimensionLabel: string
  chartType: string
  items: PortraitItem[]
}
