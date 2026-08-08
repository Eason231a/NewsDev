<template>
  <div class="status-filter">
    <label
      v-for="tab in tabs"
      :key="tab.value"
      :class="['status-filter__item', { active: modelValue === tab.value }]"
      @click="$emit('update:modelValue', tab.value)"
    >
      <span class="status-filter__radio"></span>
      <span>{{ tab.label }}</span>
    </label>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: number | undefined
}>()

defineEmits<{
  'update:modelValue': [value: number | undefined]
}>()

const tabs = [
  { label: '全部', value: undefined },
  { label: '草稿', value: 0 },
  { label: '待审核', value: 1 },
  { label: '审核通过', value: 2 },
  { label: '审核失败', value: 3 },
  { label: '已上架', value: 4 },
  { label: '已下架', value: 5 },
]
</script>

<style lang="scss" scoped>
.status-filter {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.status-filter__item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #666;
  cursor: pointer;

  &:hover {
    color: #1890ff;
  }

  &.active {
    color: #1890ff;

    .status-filter__radio {
      border-color: #1890ff;
      background: #1890ff;
      box-shadow: inset 0 0 0 2px #fff;
    }
  }
}

.status-filter__radio {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  border: 1px solid #d9d9d9;
  flex-shrink: 0;
}
</style>
