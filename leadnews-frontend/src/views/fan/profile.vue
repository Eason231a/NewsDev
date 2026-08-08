<template>
  <div class="fan-profile">
    <DateFilterBar label="统计日期：" @search="handleDateSearch" />
    <div class="fan-profile__grid" v-loading="loading">
      <template v-for="dim in portraits" :key="dim.dimension">
        <PortraitBarChart
          v-if="dim.chartType === 'doughnut'"
          :title="dim.dimensionLabel"
          :items="dim.items"
        />
        <PortraitColumnChart
          v-else
          :title="dim.dimensionLabel"
          :items="dim.items"
        />
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import dayjs from 'dayjs'
import DateFilterBar from '@/components/DateFilterBar.vue'
import PortraitBarChart from '@/components/PortraitBarChart.vue'
import PortraitColumnChart from '@/components/PortraitColumnChart.vue'
import { getFanPortrait } from '@/api/fan'
import type { PortraitDimensionData } from '@/types/fan'

const loading = ref(false)
const portraits = ref<PortraitDimensionData[]>([])

async function fetchPortrait(statDate?: string) {
  loading.value = true
  try {
    const res = await getFanPortrait({ statDate })
    portraits.value = res.data.portraits
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

function handleDateSearch(dates: { startDate?: string; endDate?: string }) {
  fetchPortrait(dates.endDate || dates.startDate)
}

// Load with today's date by default
fetchPortrait(dayjs().format('YYYY-MM-DD'))
</script>

<style lang="scss" scoped>
.fan-profile__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 32px;
  margin-top: 24px;
}
</style>
