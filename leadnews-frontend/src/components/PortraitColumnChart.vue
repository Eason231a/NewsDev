<template>
  <div class="portrait-column">
    <div class="portrait-column__title">{{ title }}</div>
    <div ref="chartRef" class="portrait-column__chart"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import type { PortraitItem } from '@/types/fan'

const props = defineProps<{
  title: string
  items: PortraitItem[]
}>()

const chartRef = ref<HTMLElement | null>(null)
let chart: echarts.ECharts | null = null

const colors = ['#1890ff', '#52c41a', '#722ed1', '#fa8c16', '#ff4d4f', '#87ceeb', '#2c3e50', '#4096ff', '#73d13d', '#b37feb']

function renderChart() {
  if (!chartRef.value || !props.items.length) return
  if (!chart) {
    chart = echarts.init(chartRef.value)
  }

  chart.setOption({
    tooltip: {
      trigger: 'axis',
      formatter: (params: { data: number; name: string }[]) =>
        `${params[0].name}<br/>数量: ${params[0].data}`,
    },
    grid: {
      left: 50,
      right: 20,
      top: 10,
      bottom: 40,
    },
    xAxis: {
      type: 'category',
      data: props.items.map(i => i.dimensionKeyLabel),
      axisLabel: { color: '#666', fontSize: 12, rotate: props.items.length > 6 ? 30 : 0 },
      axisTick: { show: false },
    },
    yAxis: {
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: '#f0f0f0', type: 'dashed' } },
      axisLabel: { color: '#999', fontSize: 12 },
    },
    series: [
      {
        type: 'bar',
        data: props.items.map((item, i) => ({
          value: item.dimensionValue,
          itemStyle: {
            color: colors[i % colors.length],
            borderRadius: [4, 4, 0, 0],
          },
        })),
        barMaxWidth: 40,
      },
    ],
  })
}

watch(() => props.items, renderChart, { deep: true })

onMounted(renderChart)

onBeforeUnmount(() => {
  chart?.dispose()
})
</script>

<style lang="scss" scoped>
.portrait-column {
  margin-bottom: 24px;
}

.portrait-column__title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  padding-left: 12px;
  border-left: 3px solid #1890ff;
}

.portrait-column__chart {
  height: 260px;
}
</style>
