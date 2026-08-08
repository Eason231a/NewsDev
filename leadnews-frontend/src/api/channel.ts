import request from '@/utils/request'
import type { ApiResponse } from '@/types/api'

export function getChannels() {
  return request.get<ApiResponse<Array<{ id: number; name: string }>>>('/channels')
}
