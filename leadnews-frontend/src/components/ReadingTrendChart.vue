<template>
  <div class="reading-trend-chart">
    <div class="reading-trend-chart__title">阅读量趋势图</div>
    <div ref="chartRef" class="reading-trend-chart__chart"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import type { TrendPoint } from '@/types/fan'

const props = defineProps<{
  data: TrendPoint[]
}>()

const chartRef = ref<HTMLElement | null>(null)
let chart: echarts.ECharts | null = null

function renderChart() {
  if (!chartRef.value || !props.data.length) return
  if (!chart) {
    chart = echarts.init(chartRef.value)
  }

  const hours = props.data.map(d => String(d.hour).padStart(2, '0') + ':00')
  const values = props.data.map(d => d.readCount)

  chart.setOption({
    tooltip: {
      trigger: 'axis',
      formatter: (params: { data: number; axisValue: string }[]) =>
        `${params[0].axisValue}<br/>阅读量: ${params[0].data}`,
    },
    grid: {
      left: 50,
      right: 20,
      top: 20,
      bottom: 30,
    },
    xAxis: {
      type: 'category',
      data: hours,
      boundaryGap: false,
      axisLine: { lineStyle: { color: '#e8e8e8' } },
      axisLabel: { color: '#999', fontSize: 11 },
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
        type: 'line',
        data: values,
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: { color: '#52c41a', width: 2 },
        itemStyle: { color: '#52c41a' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(82, 196, 26, 0.2)' },
            { offset: 1, color: 'rgba(82, 196, 26, 0)' },
          ]),
        },
      },
    ],
  })
}

watch(() => props.data, renderChart, { deep: true })

onMounted(renderChart)

onBeforeUnmount(() => {
  chart?.dispose()
})
</script>

<style lang="scss" scoped>
.reading-trend-chart {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 24px;
}

.reading-trend-chart__title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-left: 10px;
  border-left: 3px solid #1890ff;
}

.reading-trend-chart__chart {
  height: 220px;
}
</style>
