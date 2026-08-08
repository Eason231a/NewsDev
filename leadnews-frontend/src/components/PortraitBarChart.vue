<template>
  <div class="portrait-bar">
    <div class="portrait-bar__title">{{ title }}</div>
    <div class="portrait-bar__track">
      <div
        v-for="(item, i) in items"
        :key="item.dimensionKey"
        class="portrait-bar__segment"
        :style="{ width: item.percentage + '%', background: colors[i % colors.length] }"
      >
        <span>{{ item.dimensionKeyLabel }} {{ item.percentage }}%</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { PortraitItem } from '@/types/fan'

defineProps<{
  title: string
  items: PortraitItem[]
}>()

const colors = ['#1890ff', '#52c41a', '#722ed1', '#fa8c16', '#ff4d4f', '#87ceeb']
</script>

<style lang="scss" scoped>
.portrait-bar {
  margin-bottom: 24px;
}

.portrait-bar__title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  padding-left: 12px;
  border-left: 3px solid #1890ff;
}

.portrait-bar__track {
  display: flex;
  height: 36px;
  border-radius: 18px;
  overflow: hidden;
  gap: 2px;
}

.portrait-bar__segment {
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 14px;
  font-weight: 500;
  transition: width 0.3s;
}
</style>
