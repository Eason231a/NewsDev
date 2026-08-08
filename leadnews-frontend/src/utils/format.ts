export function formatNumber(value: number): string {
  if (value === 0) return '0'
  if (value >= 10000) {
    return (value / 10000).toFixed(value % 10000 === 0 ? 0 : 1) + '万'
  }
  return value.toLocaleString('zh-CN')
}

export function formatPercent(value: number): string {
  if (value === 0) return '0%'
  if (Number.isInteger(value)) return value + '%'
  return value.toFixed(1) + '%'
}
