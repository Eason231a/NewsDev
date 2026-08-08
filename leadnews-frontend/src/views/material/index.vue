<template>
  <div class="material-page">
    <div class="material-header">
      <MaterialFilterTabs v-model="filter" />
      <div class="material-header__right">
        <span class="material-header__count">已上传 {{ total }} 张图片</span>
        <el-button type="primary" @click="showUpload = true">⊕ 上传图片</el-button>
      </div>
    </div>

    <div v-if="loading" class="material-grid">
      <div v-for="n in 14" :key="n" class="material-skeleton">
        <div class="material-skeleton__img"></div>
        <div class="material-skeleton__actions">
          <span></span><span></span>
        </div>
      </div>
    </div>

    <div v-else-if="materials.length === 0" class="material-empty">
      <el-empty description="暂无素材" :image-size="120" />
    </div>

    <template v-else>
      <div class="material-grid">
        <MaterialCard
          v-for="item in materials"
          :key="item.id"
          :material="item"
          @toggle-favorite="handleToggleFavorite"
          @delete="handleDeleteClick"
        />
      </div>

      <div class="material-pagination">
        <el-pagination
          v-model:current-page="page"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[14, 21, 28]"
          layout="total, sizes, prev, pager, next"
          @change="fetchMaterials"
        />
      </div>
    </template>

    <UploadDialog v-model="showUpload" @uploaded="handleUploaded" />
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import MaterialFilterTabs from '@/components/MaterialFilterTabs.vue'
import MaterialCard from '@/components/MaterialCard.vue'
import UploadDialog from '@/components/UploadDialog.vue'
import { getMaterials, toggleFavorite, deleteMaterial } from '@/api/material'
import type { Material } from '@/types/material'

const filter = ref(0)
const materials = ref<Material[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = ref(14)
const loading = ref(false)
const showUpload = ref(false)

async function fetchMaterials() {
  loading.value = true
  try {
    const params = {
      isFavorite: filter.value === 1 ? 1 : undefined,
      page: page.value,
      pageSize: pageSize.value,
    }
    const res = await getMaterials(params)
    materials.value = res.data.list
    total.value = res.data.total
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

async function handleToggleFavorite(item: Material) {
  const newVal = item.isFavorite === 1 ? 0 : 1
  try {
    await toggleFavorite(item.id, newVal)
    item.isFavorite = newVal
    ElMessage.success(newVal === 1 ? '已收藏' : '已取消收藏')
  } catch {
    // handled by interceptor
  }
}

function handleDeleteClick(item: Material) {
  ElMessageBox.confirm('确定要删除该素材吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    await deleteMaterial(item.id)
    ElMessage.success('删除成功')
    fetchMaterials()
  }).catch(() => {
    // cancelled
  })
}

function handleUploaded() {
  ElMessage.success('上传成功')
  page.value = 1
  fetchMaterials()
}

watch(filter, () => {
  page.value = 1
  fetchMaterials()
})

onMounted(() => {
  fetchMaterials()
})
</script>

<style lang="scss" scoped>
.material-page {
  padding: 0;
}

.material-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;

  &__right {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  &__count {
    font-size: 14px;
    color: #666;
  }
}

.material-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 16px;
}

.material-empty {
  padding: 80px 0;
}

.material-pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 24px;
}

// Skeleton loading
.material-skeleton {
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;

  &__img {
    height: 100px;
    background: #e8e8e8;
    animation: pulse 1.5s infinite;
  }

  &__actions {
    display: flex;
    justify-content: space-around;
    padding: 8px;

    span {
      width: 40px;
      height: 12px;
      background: #e8e8e8;
      border-radius: 2px;
      animation: pulse 1.5s infinite;
    }
  }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
</style>
