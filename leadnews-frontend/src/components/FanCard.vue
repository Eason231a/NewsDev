<template>
  <div class="fan-card">
    <div class="fan-card__avatar">
      <img v-if="fan.fanAvatar" :src="fan.fanAvatar" alt="avatar" />
      <span v-else>{{ fan.fanName?.charAt(0) || '?' }}</span>
    </div>
    <div class="fan-card__name">{{ fan.fanName }}</div>
    <div class="fan-card__actions">
      <button class="fan-card__btn" @click="$emit('message', fan)">发消息</button>
      <button
        v-if="fan.isBlocked"
        class="fan-card__btn fan-card__btn--secondary"
        @click="$emit('unblock', fan)"
      >取消拉黑</button>
      <button
        v-else
        class="fan-card__btn fan-card__btn--secondary"
        @click="$emit('block', fan)"
      >拉黑</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Fan } from '@/types/fan'

defineProps<{
  fan: Fan
}>()

defineEmits<{
  message: [fan: Fan]
  block: [fan: Fan]
  unblock: [fan: Fan]
}>()
</script>

<style lang="scss" scoped>
.fan-card {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 20px 16px;
  text-align: center;
  transition: transform 0.2s;

  &:hover {
    transform: translateY(-2px);
  }
}

.fan-card__avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: #d9d9d9;
  margin: 0 auto 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  color: #999;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.fan-card__name {
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.fan-card__actions {
  display: flex;
  gap: 6px;
  justify-content: center;
}

.fan-card__btn {
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
  background: white;
  color: #666;
  border: 1px solid #e8e8e8;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    color: #1890ff;
    border-color: #1890ff;
    background: #e6f7ff;
  }

  &--secondary {
    &:hover {
      color: #ff4d4f;
      border-color: #ff4d4f;
      background: #fff1f0;
    }
  }
}
</style>
