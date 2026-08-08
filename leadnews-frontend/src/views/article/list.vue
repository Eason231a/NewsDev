<template>
  <div class="article-list">
    <StatusFilterTabs v-model="filters.status" @update:model-value="handleSearch" />
    <ArticleSearchBar @search="handleSearch" @update:filters="handleFilters" />
    <div v-if="loading" class="article-list__grid">
      <div v-for="n in 14" :key="n" class="article-list__skeleton">
        <div class="article-list__skeleton-cover"></div>
        <div class="article-list__skeleton-info">
          <div class="article-list__skeleton-line w-80"></div>
          <div class="article-list__skeleton-line w-40"></div>
          <div class="article-list__skeleton-line w-20"></div>
        </div>
      </div>
    </div>
    <div v-else-if="articles.length === 0" class="article-list__empty">
      <el-empty description="暂无内容" :image-size="120" />
    </div>
    <template v-else>
      <div class="article-list__grid">
        <ArticleCard
          v-for="item in articles"
          :key="item.id"
          :article="item"
          @edit="handleEdit"
          @delete="handleDelete"
          @approve="handleApprove"
          @reject="handleReject"
          @publish="handlePublish"
          @unpublish="handleUnpublish"
        />
      </div>
      <div class="article-list__pagination">
        <el-pagination
          v-model:current-page="page"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[14, 21, 28]"
          layout="total, sizes, prev, pager, next"
          @change="fetchArticles"
        />
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import StatusFilterTabs from '@/components/StatusFilterTabs.vue'
import ArticleSearchBar from '@/components/ArticleSearchBar.vue'
import ArticleCard from '@/components/ArticleCard.vue'
import { getArticles, deleteArticle, updateArticleStatus } from '@/api/article'
import type { ArticleListItem } from '@/types/article'

const router = useRouter()
const loading = ref(false)
const articles = ref<ArticleListItem[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(14)

const filters = reactive({
  status: undefined as number | undefined,
  keyword: undefined as string | undefined,
  channelId: undefined as number | undefined,
  startDate: undefined as string | undefined,
  endDate: undefined as string | undefined,
})

function handleFilters(f: {
  keyword?: string
  channelId?: number
  startDate?: string
  endDate?: string
}) {
  filters.keyword = f.keyword
  filters.channelId = f.channelId
  filters.startDate = f.startDate
  filters.endDate = f.endDate
}

function handleSearch() {
  page.value = 1
  fetchArticles()
}

async function fetchArticles() {
  loading.value = true
  try {
    const res = await getArticles({
      status: filters.status,
      keyword: filters.keyword,
      channelId: filters.channelId,
      startDate: filters.startDate,
      endDate: filters.endDate,
      page: page.value,
      pageSize: pageSize.value,
    })
    articles.value = res.data.list
    total.value = res.data.total
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

function handleEdit(item: ArticleListItem) {
  router.push(`/article/edit/${item.id}`)
}

function handleDelete(item: ArticleListItem) {
  ElMessageBox.confirm('确定要删除这篇文章吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      await deleteArticle(item.id)
      ElMessage.success('删除成功')
      fetchArticles()
    })
    .catch(() => {
      // cancelled
    })
}

async function handleApprove(item: ArticleListItem) {
  try {
    await updateArticleStatus(item.id, 2)
    ElMessage.success('审核通过')
    fetchArticles()
  } catch {
    // handled by interceptor
  }
}

async function handleReject(item: ArticleListItem) {
  try {
    await updateArticleStatus(item.id, 3)
    ElMessage.success('已设为审核失败')
    fetchArticles()
  } catch {
    // handled by interceptor
  }
}

async function handlePublish(item: ArticleListItem) {
  try {
    await updateArticleStatus(item.id, 4)
    ElMessage.success('上架成功')
    fetchArticles()
  } catch {
    // handled by interceptor
  }
}

async function handleUnpublish(item: ArticleListItem) {
  ElMessageBox.confirm('确定要下架这篇文章吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      await updateArticleStatus(item.id, 5)
      ElMessage.success('下架成功')
      fetchArticles()
    })
    .catch(() => {
      // cancelled
    })
}

onMounted(() => {
  fetchArticles()
})
</script>

<style lang="scss" scoped>
.article-list {
  padding: 0;
}

.article-list__grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 16px;
  margin-top: 20px;
}

.article-list__empty {
  padding: 80px 0;
}

.article-list__pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 24px;
}

// Skeleton
.article-list__skeleton {
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
}

.article-list__skeleton-cover {
  height: 100px;
  background: #e8e8e8;
  animation: pulse 1.5s infinite;
}

.article-list__skeleton-info {
  padding: 12px;
}

.article-list__skeleton-line {
  height: 12px;
  background: #e8e8e8;
  border-radius: 2px;
  margin-bottom: 6px;
  animation: pulse 1.5s infinite;

  &.w-80 {
    width: 80%;
  }
  &.w-40 {
    width: 40%;
  }
  &.w-20 {
    width: 20%;
  }
}

@keyframes pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}
</style>
