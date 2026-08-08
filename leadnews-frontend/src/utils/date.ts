import dayjs from 'dayjs'

/**
 * Format date to yyyy-MM-dd HH:mm:ss
 */
export function formatDateTime(date: string | Date): string {
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss')
}

/**
 * Format date to yyyy-MM-dd
 */
export function formatDate(date: string | Date): string {
  return dayjs(date).format('YYYY-MM-DD')
}

/**
 * Format date to time only HH:mm:ss
 */
export function formatTime(date: string | Date): string {
  return dayjs(date).format('HH:mm:ss')
}
