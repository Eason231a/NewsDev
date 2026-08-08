<template>
  <div class="fan-list">
    <div v-if="loading && fans.length === 0" class="fan-list__grid">
      <div v-for="n in 18" :key="n" class="fan-list__skeleton">
        <div class="fan-list__skeleton-avatar"></div>
        <div class="fan-list__skeleton-line w-60"></div>
        <div class="fan-list__skeleton-line w-80"></div>
      </div>
    </div>
    <div v-else-if="!loading && fans.length === 0" class="fan-list__empty">
      <el-empty description="暂无粉丝" :image-size="100" />
    </div>
    <template v-else>
      <div class="fan-list__grid">
        <FanCard
          v-for="fan in fans"
          :key="fan.id"
          :fan="fan"
          @message="handleMessage"
          @block="handleBlock"
          @unblock="handleUnblock"
        />
      </div>
      <div class="fan-list__more" v-if="hasMore">
        <el-button :loading="loadingMore" @click="loadMore">点击查看更多</el-button>
      </div>
    </template>
    <SendMessageDialog ref="messageDialogRef" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import FanCard from '@/components/FanCard.vue'
import SendMessageDialog from '@/components/SendMessageDialog.vue'
import { getFans, blockFan, unblockFan } from '@/api/fan'
import type { Fan } from '@/types/fan'

const fans = ref<Fan[]>([])
const loading = ref(false)
const loadingMore = ref(false)
const page = ref(1)
const pageSize = 18
const total = ref(0)
const hasMore = ref(true)
const messageDialogRef = ref<InstanceType<typeof SendMessageDialog>>()

async function fetchFans(isLoadMore = false) {
  if (isLoadMore) {
    loadingMore.value = true
  } else {
    loading.value = true
  }
  try {
    const res = await getFans({ page: page.value, pageSize })
    if (isLoadMore) {
      fans.value.push(...res.data.list)
    } else {
      fans.value = res.data.list
    }
    total.value = res.data.total
    hasMore.value = fans.value.length < total.value
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
    loadingMore.value = false
  }
}

function loadMore() {
  page.value++
  fetchFans(true)
}

function handleMessage(fan: Fan) {
  messageDialogRef.value?.open(fan)
}

function handleBlock(fan: Fan) {
  ElMessageBox.confirm(`确定要拉黑粉丝「${fan.fanName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      await blockFan(fan.id)
      ElMessage.success('已拉黑')
      fan.isBlocked = 1
    })
    .catch(() => {
      // cancelled
    })
}

function handleUnblock(fan: Fan) {
  ElMessageBox.confirm(`确定要取消拉黑粉丝「${fan.fanName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      await unblockFan(fan.id)
      ElMessage.success('已取消拉黑')
      fan.isBlocked = 0
    })
    .catch(() => {
      // cancelled
    })
}

onMounted(() => {
  fetchFans()
})
</script>

<style lang="scss" scoped>
.fan-list__grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.fan-list__more {
  text-align: center;
  margin-top: 24px;
}

.fan-list__empty {
  padding: 60px 0;
}

// Skeleton
.fan-list__skeleton {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 20px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.fan-list__skeleton-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: #e8e8e8;
  animation: pulse 1.5s infinite;
}

.fan-list__skeleton-line {
  height: 12px;
  background: #e8e8e8;
  border-radius: 2px;
  animation: pulse 1.5s infinite;

  &.w-60 { width: 60%; }
  &.w-80 { width: 80%; }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
</style>
