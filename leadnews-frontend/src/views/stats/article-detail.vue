<template>
  <div class="article-detail">
    <div class="article-detail__back" @click="$router.back()">
      <el-icon><ArrowLeft /></el-icon>
      <span>返回</span>
    </div>
    <DateFilterBar @search="handleDateSearch" />
    <div style="margin-top: 24px;">
      <StatsCards :cards="topCards" />
    </div>
    <div style="margin-top: 20px;">
      <StatsCards :cards="bottomCards" />
    </div>
    <div class="article-detail__charts" v-if="sources.length || completions.length">
      <ReadSourceChart :sources="sources" />
      <ReadCompletionChart :completions="completions" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import DateFilterBar from '@/components/DateFilterBar.vue'
import StatsCards from '@/components/StatsCards.vue'
import ReadSourceChart from '@/components/ReadSourceChart.vue'
import ReadCompletionChart from '@/components/ReadCompletionChart.vue'
import type { StatCard } from '@/components/StatsCards.vue'
import { getArticleStatsDetail, getReadSources, getReadCompletion } from '@/api/stats'
import type { StatsDetailSummary, ReadSource, ReadCompletion } from '@/types/stats'
import { formatNumber, formatPercent } from '@/utils/format'

const route = useRoute()
const articleId = Number(route.params.articleId)
const dateRange = ref<{ startDate?: string; endDate?: string }>({})

const summary = ref<StatsDetailSummary>({
  totalReadCount: 0,
  totalLikeCount: 0,
  totalCommentCount: 0,
  totalFavoriteCount: 0,
  totalShareCount: 0,
  avgReadProgress: 0,
  bounceRate: 0,
  avgReadSeconds: 0,
  totalRecommendShares: 0,
  totalFanReadCount: 0,
})

const sources = ref<ReadSource[]>([])
const completions = ref<ReadCompletion[]>([])

const topCards = computed<StatCard[]>(() => [
  { label: '平均阅读进度', value: formatPercent(summary.value.avgReadProgress), icon: '📖', color: 'blue' },
  { label: '跳出率', value: formatPercent(summary.value.bounceRate), icon: '👋', color: 'green' },
  { label: '平均阅读时间（秒）', value: summary.value.avgReadSeconds, icon: '⏱️', color: 'orange' },
  { label: '推荐转发量', value: formatNumber(summary.value.totalRecommendShares), icon: '🔄', color: 'purple' },
])

const bottomCards = computed<StatCard[]>(() => [
  { label: '评论量', value: formatNumber(summary.value.totalCommentCount), icon: '💬', color: 'green' },
  { label: '总阅读量', value: formatNumber(summary.value.totalReadCount), icon: '👁️', color: 'orange' },
  { label: '粉丝阅读量', value: formatNumber(summary.value.totalFanReadCount), icon: '👥', color: 'blue' },
])

async function fetchDetail() {
  try {
    const res = await getArticleStatsDetail(articleId, dateRange.value)
    summary.value = res.data.summary
  } catch {
    // handled by interceptor
  }
}

async function fetchCharts() {
  try {
    const [sourcesRes, completionRes] = await Promise.all([
      getReadSources(articleId, dateRange.value),
      getReadCompletion(articleId, dateRange.value),
    ])
    sources.value = sourcesRes.data.sources
    completions.value = completionRes.data.completions
  } catch {
    // handled by interceptor
  }
}

function handleDateSearch(dates: { startDate?: string; endDate?: string }) {
  dateRange.value = dates
  fetchDetail()
  fetchCharts()
}

onMounted(() => {
  fetchDetail()
  fetchCharts()
})
</script>

<style lang="scss" scoped>
.article-detail__back {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #666;
  margin-bottom: 20px;
  cursor: pointer;

  &:hover {
    color: #1890ff;
  }
}

.article-detail__charts {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 32px;
  margin-top: 32px;
}
</style>
