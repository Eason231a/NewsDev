<template>
  <div class="dashboard">
    <DateFilterBar @search="handleDateSearch" />
    <div style="margin-top: 24px;">
      <StatsCards :cards="overviewCards" />
    </div>
    <div style="margin-top: 24px;">
      <el-table
        v-loading="loading"
        :data="list"
        stripe
        empty-text="暂无数据"
      >
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="articleTitle" label="文章名称" min-width="200" show-overflow-tooltip />
        <el-table-column prop="readCount" label="阅读" width="100" />
        <el-table-column prop="commentCount" label="评论量" width="100" />
        <el-table-column prop="favoriteCount" label="收藏量" width="100" />
        <el-table-column prop="shareCount" label="转发量" width="100" />
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <span class="dashboard__link" @click="handleDetail(row)">详细分析</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="dashboard__pagination" v-if="total > 0">
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
import { useRouter } from 'vue-router'
import DateFilterBar from '@/components/DateFilterBar.vue'
import StatsCards from '@/components/StatsCards.vue'
import type { StatCard } from '@/components/StatsCards.vue'
import { getStatsOverview, getArticleStats } from '@/api/stats'
import type { ArticleStatsItem } from '@/types/stats'
import { formatNumber } from '@/utils/format'

const router = useRouter()
const loading = ref(false)
const list = ref<ArticleStatsItem[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(10)

const dateRange = ref<{ startDate?: string; endDate?: string }>({})

const overview = ref({
  totalPublishCount: 0,
  totalLikeCount: 0,
  totalFavoriteCount: 0,
  totalShareCount: 0,
})

const overviewCards = computed<StatCard[]>(() => [
  { label: '图文发布量', value: formatNumber(overview.value.totalPublishCount), icon: '📝', color: 'blue' },
  { label: '点赞数量', value: formatNumber(overview.value.totalLikeCount), icon: '👍', color: 'green' },
  { label: '收藏数量', value: formatNumber(overview.value.totalFavoriteCount), icon: '⭐', color: 'orange' },
  { label: '转发数量', value: formatNumber(overview.value.totalShareCount), icon: '🔄', color: 'purple' },
])

async function fetchOverview() {
  try {
    const res = await getStatsOverview(dateRange.value)
    overview.value = res.data
  } catch {
    // handled by interceptor
  }
}

async function fetchList() {
  loading.value = true
  try {
    const res = await getArticleStats({
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

function handleDateSearch(dates: { startDate?: string; endDate?: string }) {
  dateRange.value = dates
  page.value = 1
  fetchOverview()
  fetchList()
}

function handleDetail(item: ArticleStatsItem) {
  router.push(`/dashboard/article/${item.articleId}`)
}

onMounted(() => {
  fetchOverview()
  fetchList()
})
</script>

<style lang="scss" scoped>
.dashboard__link {
  color: #1890ff;
  font-size: 14px;
  cursor: pointer;

  &:hover {
    color: #40a9ff;
  }
}

.dashboard__pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 24px;
}
</style>
