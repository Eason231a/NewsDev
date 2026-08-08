<template>
  <div class="article-card" @click="handleClick">
    <div class="article-card__cover">
      <img
        v-if="article.covers?.[0]?.url"
        :src="article.covers[0].url"
        alt="封面"
      />
      <img
        v-else
        :src="fallbackCover"
        alt="封面"
      />
    </div>
    <div class="article-card__actions">
      <template v-if="actions.includes('approve')">
        <div class="article-card__action-btn" title="审核通过" @click.stop="$emit('approve', article)">✅</div>
      </template>
      <template v-if="actions.includes('reject')">
        <div class="article-card__action-btn" title="审核失败" @click.stop="$emit('reject', article)">❌</div>
      </template>
      <template v-if="actions.includes('edit')">
        <div class="article-card__action-btn" title="编辑" @click.stop="$emit('edit', article)">✏️</div>
      </template>
      <template v-if="actions.includes('delete')">
        <div class="article-card__action-btn" title="删除" @click.stop="$emit('delete', article)">🗑️</div>
      </template>
      <template v-if="actions.includes('publish')">
        <div class="article-card__action-btn" title="上架" @click.stop="$emit('publish', article)">⬆️</div>
      </template>
      <template v-if="actions.includes('unpublish')">
        <div class="article-card__action-btn" title="下架" @click.stop="$emit('unpublish', article)">⬇️</div>
      </template>
    </div>
    <div class="article-card__info">
      <div class="article-card__title">{{ article.title }}</div>
      <div class="article-card__meta">{{ article.createdAt }}</div>
      <div class="article-card__tags">
        <span :class="['article-card__tag', statusClass]">{{ statusLabel }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { ArticleListItem } from '@/types/article'

const props = defineProps<{
  article: ArticleListItem
}>()

const emit = defineEmits<{
  approve: [article: ArticleListItem]
  reject: [article: ArticleListItem]
  edit: [article: ArticleListItem]
  delete: [article: ArticleListItem]
  publish: [article: ArticleListItem]
  unpublish: [article: ArticleListItem]
}>()

const fallbackCovers = [
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
  const index = props.article.id % fallbackCovers.length
  return `/covers/${fallbackCovers[index]}`
})

const statusMap: Record<number, { label: string; class: string; actions: string[] }> = {
  0: { label: '草稿', class: 'draft', actions: ['edit', 'delete'] },
  1: { label: '待审核', class: 'pending', actions: ['approve', 'reject'] },
  2: { label: '审核通过', class: 'approved', actions: [] },
  3: { label: '审核失败', class: 'rejected', actions: ['edit', 'delete'] },
  4: { label: '已上架', class: 'online', actions: ['unpublish'] },
  5: { label: '已下架', class: 'offline', actions: ['publish'] },
}

const statusInfo = computed(() => statusMap[props.article.status] || { label: '未知', class: 'draft', actions: [] })
const statusLabel = computed(() => statusInfo.value.label)
const statusClass = computed(() => statusInfo.value.class)
const actions = computed(() => statusInfo.value.actions)

function handleClick() {
  emit('edit', props.article)
}
</script>

<style lang="scss" scoped>
.article-card {
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
  cursor: default;
  transition: transform 0.2s;

  &:hover {
    transform: translateY(-2px);

    .article-card__actions {
      display: flex;
    }
  }
}

.article-card__cover {
  height: 100px;
  background: #e8e8e8;
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.article-card__info {
  padding: 12px;
}

.article-card__title {
  font-size: 14px;
  color: #333;
  margin-bottom: 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.article-card__meta {
  font-size: 12px;
  color: #999;
}

.article-card__tags {
  display: flex;
  gap: 6px;
  margin-top: 6px;
}

.article-card__tag {
  padding: 2px 6px;
  border-radius: 2px;
  font-size: 12px;

  &.draft {
    background: #f5f5f5;
    color: #999;
  }
  &.pending {
    background: #ffe7ba;
    color: #fa8c16;
  }
  &.approved {
    background: #d9f7be;
    color: #52c41a;
  }
  &.rejected {
    background: #fff1f0;
    color: #ff4d4f;
  }
  &.online {
    background: #d6e4ff;
    color: #1890ff;
  }
  &.offline {
    background: #f5f5f5;
    color: #999;
  }
}

.article-card__actions {
  position: absolute;
  top: 8px;
  right: 8px;
  display: none;
  gap: 8px;
}

.article-card__action-btn {
  width: 28px;
  height: 28px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.95);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #666;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  cursor: pointer;

  &:hover {
    background: #1890ff;
    color: #fff;
  }
}
</style>
