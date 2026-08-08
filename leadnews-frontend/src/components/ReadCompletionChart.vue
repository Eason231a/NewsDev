<template>
  <div class="read-completion-chart">
    <div class="read-completion-chart__title">阅读完成度分析</div>
    <div class="read-completion-chart__body">
      <div ref="chartRef" class="read-completion-chart__chart"></div>
      <div class="read-completion-chart__legend">
        <div v-for="item in completions" :key="item.completionRange" class="read-completion-chart__legend-item">
          <span class="read-completion-chart__legend-dot" :style="{ background: item.color }"></span>
          <span>{{ item.rangeLabel }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import type { ReadCompletion } from '@/types/stats'

const props = defineProps<{
  completions: ReadCompletion[]
}>()

const chartRef = ref<HTMLElement | null>(null)
let chart: echarts.ECharts | null = null

function renderChart() {
  if (!chartRef.value) return
  if (!chart) {
    chart = echarts.init(chartRef.value)
  }

  const total = props.completions.reduce((sum, c) => sum + c.userCount, 0)

  chart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c}人 ({d}%)',
    },
    series: [
      {
        type: 'pie',
        radius: ['55%', '75%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        label: { show: false },
        emphasis: {
          label: { show: true, fontWeight: 'bold' },
        },
        data: props.completions.map(c => ({
          value: c.userCount,
          name: c.rangeLabel,
          itemStyle: { color: c.color },
        })),
      },
    ],
    graphic: [
      {
        type: 'text',
        left: 'center',
        top: 'center',
        style: {
          text: total.toString() + '人',
          textAlign: 'center',
          fill: '#333',
          fontSize: 16,
          fontWeight: 600,
        },
      },
    ],
  })
}

watch(() => props.completions, renderChart, { deep: true })

onMounted(renderChart)

onBeforeUnmount(() => {
  chart?.dispose()
})
</script>

<style lang="scss" scoped>
.read-completion-chart {
  background: #fafafa;
  border-radius: 8px;
  padding: 24px;
}

.read-completion-chart__title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
  padding-left: 12px;
  border-left: 3px solid #1890ff;
}

.read-completion-chart__body {
  display: flex;
  align-items: center;
  gap: 24px;
}

.read-completion-chart__chart {
  width: 160px;
  height: 160px;
  flex-shrink: 0;
}

.read-completion-chart__legend {
  display: flex;
  flex-direction: column;
  gap: 10px;
  font-size: 13px;
  color: #666;
}

.read-completion-chart__legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.read-completion-chart__legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 2px;
  flex-shrink: 0;
}
</style>
