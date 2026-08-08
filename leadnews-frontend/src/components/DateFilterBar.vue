<template>
  <div class="date-filter-bar">
    <div class="date-filter-bar__range">
      <span>{{ label }}</span>
      <el-date-picker
        v-model="startDate"
        type="date"
        placeholder="开始日期"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        style="width: 140px"
        @change="emitSearch"
      />
      <span>至</span>
      <el-date-picker
        v-model="endDate"
        type="date"
        placeholder="结束日期"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        style="width: 140px"
        @change="emitSearch"
      />
    </div>
    <div class="date-filter-bar__quick">
      <span
        v-for="btn in quickButtons"
        :key="btn.key"
        :class="{ active: activeQuick === btn.key }"
        @click="handleQuick(btn.key)"
      >{{ btn.label }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import dayjs from 'dayjs'

withDefaults(defineProps<{
  label?: string
}>(), {
  label: '数据时间：',
})

const emit = defineEmits<{
  search: [dates: { startDate?: string; endDate?: string }]
}>()

const startDate = ref<string | null>(null)
const endDate = ref<string | null>(null)
const activeQuick = ref('7days')

const quickButtons = [
  { key: 'today', label: '今日' },
  { key: 'week', label: '本周' },
  { key: '7days', label: '近7天' },
  { key: '30days', label: '近30天' },
]

function handleQuick(key: string) {
  activeQuick.value = key
  const today = dayjs()
  switch (key) {
    case 'today':
      startDate.value = today.format('YYYY-MM-DD')
      endDate.value = today.format('YYYY-MM-DD')
      break
    case 'week':
      startDate.value = today.startOf('week').format('YYYY-MM-DD')
      endDate.value = today.format('YYYY-MM-DD')
      break
    case '7days':
      startDate.value = today.subtract(6, 'day').format('YYYY-MM-DD')
      endDate.value = today.format('YYYY-MM-DD')
      break
    case '30days':
      startDate.value = today.subtract(29, 'day').format('YYYY-MM-DD')
      endDate.value = today.format('YYYY-MM-DD')
      break
  }
  emitSearch()
}

function emitSearch() {
  activeQuick.value = ''
  emit('search', {
    startDate: startDate.value || undefined,
    endDate: endDate.value || undefined,
  })
}

// Trigger default on creation — disabled; pages should initially show all-time data
// handleQuick('7days')
</script>

<style lang="scss" scoped>
.date-filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.date-filter-bar__range {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #666;
}

.date-filter-bar__quick {
  display: flex;
  gap: 8px;
}

.date-filter-bar__quick span {
  padding: 6px 16px;
  background: #f5f7fa;
  border-radius: 4px;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  transition: all 0.2s;
  user-select: none;

  &:hover {
    color: #1890ff;
    background: #e6f7ff;
  }

  &.active {
    background: #1890ff;
    color: white;

    &:hover {
      background: #40a9ff;
      color: white;
    }
  }
}
</style>
