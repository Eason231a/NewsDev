<template>
  <div class="stats-cards">
    <div
      v-for="card in cards"
      :key="card.label"
      :class="['stats-cards__item', card.color]"
    >
      <div class="stats-cards__icon">{{ card.icon }}</div>
      <div class="stats-cards__info">
        <div class="stats-cards__value">{{ card.value }}</div>
        <div class="stats-cards__label">{{ card.label }}</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
export interface StatCard {
  label: string
  value: string | number
  icon: string
  color: 'blue' | 'green' | 'orange' | 'purple'
}

defineProps<{
  cards: StatCard[]
}>()
</script>

<style lang="scss" scoped>
.stats-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.stats-cards__item {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.stats-cards__icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  flex-shrink: 0;
}

.stats-cards__value {
  font-size: 28px;
  font-weight: 600;
  color: #333;
  line-height: 1.2;
}

.stats-cards__label {
  font-size: 14px;
  color: #999;
  margin-top: 4px;
}

.stats-cards__item.blue {
  background: #e6f7ff;
  .stats-cards__icon { background: #1890ff; color: white; }
  .stats-cards__value { color: #1890ff; }
}

.stats-cards__item.green {
  background: #f6ffed;
  .stats-cards__icon { background: #52c41a; color: white; }
  .stats-cards__value { color: #52c41a; }
}

.stats-cards__item.orange {
  background: #fff7e6;
  .stats-cards__icon { background: #fa8c16; color: white; }
  .stats-cards__value { color: #fa8c16; }
}

.stats-cards__item.purple {
  background: #f9f0ff;
  .stats-cards__icon { background: #722ed1; color: white; }
  .stats-cards__value { color: #722ed1; }
}
</style>
