<template>
  <div class="article-search">
    <input
      v-model="keyword"
      type="text"
      class="article-search__input"
      placeholder="请输入关键字"
      @input="debounceSearch"
    />
    <el-select
      v-model="channelId"
      placeholder="全部频道"
      clearable
      style="width: 160px"
      @change="emitSearch"
    >
      <el-option
        v-for="ch in channels"
        :key="ch.id"
        :label="ch.name"
        :value="ch.id"
      />
    </el-select>
    <el-date-picker
      v-model="dateRange"
      type="daterange"
      start-placeholder="开始日期"
      end-placeholder="结束日期"
      format="YYYY-MM-DD"
      value-format="YYYY-MM-DD"
      @change="emitSearch"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getChannels } from '@/api/channel'

const emit = defineEmits<{
  search: []
  'update:filters': [
    filters: {
      keyword?: string
      channelId?: number
      startDate?: string
      endDate?: string
    },
  ]
}>()

const keyword = ref('')
const channelId = ref<number | undefined>(undefined)
const dateRange = ref<[string, string] | null>(null)
const channels = ref<Array<{ id: number; name: string }>>([])

let timer: ReturnType<typeof setTimeout> | null = null

function debounceSearch() {
  if (timer) clearTimeout(timer)
  timer = setTimeout(() => {
    emitSearch()
  }, 400)
}

function emitSearch() {
  emit('update:filters', {
    keyword: keyword.value || undefined,
    channelId: channelId.value,
    startDate: dateRange.value?.[0],
    endDate: dateRange.value?.[1],
  })
  emit('search')
}

onMounted(async () => {
  try {
    const res = await getChannels()
    channels.value = res.data
  } catch {
    // handled by interceptor
  }
})
</script>

<style lang="scss" scoped>
.article-search {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.article-search__input {
  background: #fff;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  padding: 8px 12px;
  font-size: 14px;
  color: #333;
  outline: none;
  width: 200px;

  &::placeholder {
    color: #999;
  }

  &:focus {
    border-color: #1890ff;
  }
}
</style>
