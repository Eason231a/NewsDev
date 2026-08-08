<template>
  <div class="material-card">
    <div class="material-card__img">
      <img v-if="material.url" :src="material.url" :alt="material.filename" />
      <img v-else :src="fallbackCover" alt="封面" />
    </div>
    <div class="material-card__actions">
      <span
        :class="{ 'fav-active': material.isFavorite === 1 }"
        @click.stop="$emit('toggle-favorite', material)"
      >
        {{ material.isFavorite === 1 ? '★ 已收藏' : '☆ 收藏' }}
      </span>
      <span @click.stop="$emit('delete', material)">🗑 删除</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { Material } from '@/types/material'

const props = defineProps<{
  material: Material
}>()

defineEmits<{
  'toggle-favorite': [material: Material]
  delete: [material: Material]
}>()

const covers = [
  'Snipaste_2026-08-08_14-46-34.png',
  'Snipaste_2026-08-08_14-46-49.png',
  'Snipaste_2026-08-08_14-47-01.png',
  'Snipaste_2026-08-08_14-47-15.png',
  'Snipaste_2026-08-08_14-47-51.png',
  'Snipaste_2026-08-08_14-47-59.png',
  'Snipaste_2026-08-08_14-48-07.png',
  'Snipaste_2026-08-08_14-48-15.png',
  'Snipaste_2026-08-08_14-48-23.png',
  'Snipaste_2026-08-08_14-49-36.png',
  'Snipaste_2026-08-08_14-49-45.png',
  'Snipaste_2026-08-08_14-50-40.png',
  'Snipaste_2026-08-08_14-50-47.png',
  'Snipaste_2026-08-08_14-51-00.png',
  'Snipaste_2026-08-08_14-51-08.png',
  'Snipaste_2026-08-08_14-51-16.png',
  'Snipaste_2026-08-08_14-51-25.png',
  'Snipaste_2026-08-08_14-51-32.png',
  'Snipaste_2026-08-08_14-51-42.png',
  'Snipaste_2026-08-08_14-51-48.png',
]

const fallbackCover = computed(() => {
  const index = props.material.id % covers.length
  return `/covers/${covers[index]}`
})
</script>

<style lang="scss" scoped>
.material-card {
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.2s;

  &:hover {
    transform: translateY(-2px);
  }

  &__img {
    height: 100px;
    background: #e8e8e8;
    overflow: hidden;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  &__actions {
    display: flex;
    justify-content: space-around;
    padding: 8px;
    font-size: 12px;
    color: #999;

    span {
      cursor: pointer;
      transition: all 0.2s;

      &:hover {
        color: #1890ff;
      }

      &:active {
        transform: scale(0.95);
      }
    }

    .fav-active {
      color: #faad14;
    }
  }
}
</style>
