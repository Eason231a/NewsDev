<template>
  <div class="read-source-chart">
    <div class="read-source-chart__title">阅读来源分析</div>
    <div class="read-source-chart__body">
      <div ref="chartRef" class="read-source-chart__chart"></div>
      <div class="read-source-chart__legend">
        <div v-for="item in sources" :key="item.sourceType" class="read-source-chart__legend-item">
          <span class="read-source-chart__legend-dot" :style="{ background: item.color }"></span>
          <span>{{ item.sourceLabel }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import type { ReadSource } from '@/types/stats'

const props = defineProps<{
  sources: ReadSource[]
}>()

const chartRef = ref<HTMLElement | null>(null)
let chart: echarts.ECharts | null = null

function renderChart() {
  if (!chartRef.value) return
  if (!chart) {
    chart = echarts.init(chartRef.value)
  }

  const total = props.sources.reduce((sum, s) => sum + s.readCount, 0)

  chart.setOption({
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)',
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
        data: props.sources.map(s => ({
          value: s.readCount,
          name: s.sourceLabel,
          itemStyle: { color: s.color },
        })),
      },
    ],
    graphic: [
      {
        type: 'text',
        left: 'center',
        top: 'center',
        style: {
          text: total.toString(),
          textAlign: 'center',
          fill: '#333',
          fontSize: 18,
          fontWeight: 600,
        },
      },
    ],
  })
}

watch(() => props.sources, renderChart, { deep: true })

onMounted(renderChart)

onBeforeUnmount(() => {
  chart?.dispose()
})
</script>

<style lang="scss" scoped>
.read-source-chart {
  background: #fafafa;
  border-radius: 8px;
  padding: 24px;
}

.read-source-chart__title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
  padding-left: 12px;
  border-left: 3px solid #1890ff;
}

.read-source-chart__body {
  display: flex;
  align-items: center;
  gap: 24px;
}

.read-source-chart__chart {
  width: 160px;
  height: 160px;
  flex-shrink: 0;
}

.read-source-chart__legend {
  display: flex;
  flex-direction: column;
  gap: 10px;
  font-size: 13px;
  color: #666;
}

.read-source-chart__legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.read-source-chart__legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 2px;
  flex-shrink: 0;
}
</style>
