<template>
  <div class="material-tabs">
    <button
      v-for="tab in tabs"
      :key="tab.value"
      :class="['material-tabs__item', { active: modelValue === tab.value }]"
      @click="$emit('update:modelValue', tab.value)"
    >
      {{ tab.label }}
    </button>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: number
}>()

defineEmits<{
  'update:modelValue': [value: number]
}>()

const tabs = [
  { label: '全部', value: 0 },
  { label: '收藏', value: 1 },
]
</script>

<style lang="scss" scoped>
.material-tabs {
  display: flex;
  gap: 8px;

  &__item {
    padding: 8px 20px;
    border-radius: 4px;
    font-size: 14px;
    background: #f5f7fa;
    color: #666;
    border: none;
    cursor: pointer;
    transition: all 0.2s;

    &:hover {
      color: #1890ff;
      background: #e6f7ff;
    }

    &.active {
      background: #1890ff;
      color: #fff;
    }
  }
}
</style>
