<template>
  <div class="fan-overview">
    <DateFilterBar label="统计日期：" @search="handleDateSearch" />
    <div style="margin-top: 24px;">
      <StatsCards :cards="overviewCards" />
    </div>
    <div style="margin-top: 24px;">
      <ReadingTrendChart :data="trendData" />
    </div>
    <div class="fan-overview__table-section">
      <div class="fan-overview__table-header">
        <div class="fan-overview__table-title">数据列表</div>
      </div>
      <el-table v-loading="loading" :data="list" stripe empty-text="暂无数据">
        <el-table-column prop="statDate" label="时间" width="140" />
        <el-table-column prop="fanCount" label="粉丝数量" width="120" />
        <el-table-column prop="fanReadCount" label="粉丝阅读量" width="120" />
        <el-table-column prop="fanRevenue" label="粉丝收益（元）" width="140" />
        <el-table-column prop="unfollowCount" label="取消关注量" width="120" />
      </el-table>
    </div>
    <div class="fan-overview__pagination" v-if="total > 0">
      <el-pagination
        v-model:current-page="page"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next"
        @change="fetchList"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import dayjs from 'dayjs'
import DateFilterBar from '@/components/DateFilterBar.vue'
import StatsCards from '@/components/StatsCards.vue'
import ReadingTrendChart from '@/components/ReadingTrendChart.vue'
import type { StatCard } from '@/components/StatsCards.vue'
import { getFanOverview, getFanStats, getTrend } from '@/api/fan'
import type { FanStatsItem, TrendPoint } from '@/types/fan'
import { formatNumber } from '@/utils/format'

const loading = ref(false)
const list = ref<FanStatsItem[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(10)
const trendData = ref<TrendPoint[]>([])

const dateRange = ref<{ startDate?: string; endDate?: string }>({})

const overview = ref({
  totalFanCount: 0,
  totalFanReadCount: 0,
  totalFanRevenue: 0,
  totalUnfollowCount: 0,
})

const overviewCards = computed<StatCard[]>(() => [
  { label: '累计粉丝数量', value: formatNumber(overview.value.totalFanCount), icon: '👤', color: 'green' },
  { label: '粉丝累计阅读量', value: formatNumber(overview.value.totalFanReadCount), icon: '👁️', color: 'orange' },
  { label: '粉丝收益（元）', value: overview.value.totalFanRevenue.toFixed(0), icon: '💰', color: 'purple' },
  { label: '取消关注量', value: formatNumber(overview.value.totalUnfollowCount), icon: '📉', color: 'blue' },
])

async function fetchOverview() {
  try {
    const res = await getFanOverview(dateRange.value)
    overview.value = res.data
  } catch {
    // handled by interceptor
  }
}

async function fetchList() {
  loading.value = true
  try {
    const res = await getFanStats({
      ...dateRange.value,
      page: page.value,
      pageSize: pageSize.value,
    })
    list.value = res.data.list
    total.value = res.data.total
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

async function fetchTrend() {
  try {
    const statDate = dateRange.value.endDate || dayjs().format('YYYY-MM-DD')
    const res = await getTrend({ statDate })
    trendData.value = res.data.hours
  } catch {
    // handled by interceptor
  }
}

function handleDateSearch(dates: { startDate?: string; endDate?: string }) {
  dateRange.value = dates
  page.value = 1
  fetchOverview()
  fetchList()
  fetchTrend()
}

onMounted(() => {
  fetchOverview()
  fetchList()
  fetchTrend()
})
</script>

<style lang="scss" scoped>
.fan-overview__table-section {
  margin-top: 24px;
}

.fan-overview__table-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}

.fan-overview__table-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  padding-left: 10px;
  border-left: 3px solid #1890ff;
}

.fan-overview__pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 24px;
}
</style>
