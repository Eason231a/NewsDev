<template>
  <el-dialog
    v-model="visible"
    title="选择图片"
    width="800px"
    :close-on-click-modal="false"
  >
    <div class="image-selector">
      <div class="image-selector__tabs">
        <button
          :class="['image-selector__tab', { active: activeTab === 'library' }]"
          @click="activeTab = 'library'"
        >
          素材库
        </button>
        <button
          :class="['image-selector__tab', { active: activeTab === 'upload' }]"
          @click="activeTab = 'upload'"
        >
          本地上传
        </button>
      </div>

      <template v-if="activeTab === 'library'">
        <div class="image-selector__body">
          <div class="image-selector__sidebar">
            <div
              :class="['image-selector__sidebar-item', { active: filterSidebar === 0 }]"
              @click="filterSidebar = 0"
            >
              全部
            </div>
            <div
              :class="['image-selector__sidebar-item', { active: filterSidebar === 1 }]"
              @click="filterSidebar = 1"
            >
              收藏
            </div>
          </div>
          <div class="image-selector__content">
            <div v-if="loading" class="image-selector__loading">加载中...</div>
            <div v-else-if="images.length === 0" class="image-selector__empty">暂无素材</div>
            <div v-else class="image-selector__grid">
              <div
                v-for="img in images"
                :key="img.id"
                :class="['image-selector__item', { selected: selected && selected.id === img.id }]"
                @click="selected = img"
              >
                <img :src="img.url" :alt="img.filename" />
                <div v-if="selected && selected.id === img.id" class="image-selector__check">✓</div>
              </div>
            </div>
            <div v-if="total > pageSize" class="image-selector__pagination">
              <el-pagination
                v-model:current-page="page"
                :total="total"
                :page-size="pageSize"
                layout="prev, pager, next"
                small
                @current-change="fetchImages"
              />
            </div>
          </div>
        </div>
      </template>

      <template v-else>
        <div class="image-selector__upload">
          <label
            :class="['image-selector__dropzone', { 'has-file': uploadFile }]"
            @dragover.prevent
            @drop.prevent="handleDrop"
          >
            <input
              type="file"
              accept="image/jpeg,image/png"
              hidden
              @change="handleFileChange"
            />
            <span class="image-selector__upload-icon">📷</span>
            <span class="image-selector__upload-text">
              {{ uploadFile ? uploadFile.name : '点击或拖拽文件上传' }}
            </span>
          </label>
          <p class="image-selector__upload-hint">支持 jpg、png 格式，单张不超过 2MB</p>
          <el-button
            type="primary"
            :disabled="!uploadFile"
            :loading="uploading"
            @click="handleUpload"
          >
            开始上传
          </el-button>
        </div>
      </template>
    </div>

    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" :disabled="!selected && activeTab === 'library'" @click="handleConfirm">
        确定
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getMaterials, uploadMaterial } from '@/api/material'
import type { Material } from '@/types/material'

const props = defineProps<{
  modelValue: boolean
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  confirm: [data: { id: number; url: string }]
}>()

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const activeTab = ref<'library' | 'upload'>('library')
const filterSidebar = ref(0)
const images = ref<Material[]>([])
const selected = ref<Material | null>(null)
const loading = ref(false)
const total = ref(0)
const page = ref(1)
const pageSize = ref(12)

// Upload state
const uploadFile = ref<File | null>(null)
const uploading = ref(false)

async function fetchImages() {
  loading.value = true
  try {
    const res = await getMaterials({
      isFavorite: filterSidebar.value === 1 ? 1 : undefined,
      page: page.value,
      pageSize: pageSize.value,
    })
    images.value = res.data.list
    total.value = res.data.total
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

function handleFileChange(e: Event) {
  const target = e.target as HTMLInputElement
  if (target.files?.[0]) {
    validateAndSet(target.files[0])
  }
}

function handleDrop(e: DragEvent) {
  const file = e.dataTransfer?.files?.[0]
  if (file) validateAndSet(file)
}

function validateAndSet(file: File) {
  if (!['image/jpeg', 'image/png'].includes(file.type)) {
    ElMessage.error('仅支持 jpg、png 格式')
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    ElMessage.error('图片大小不能超过 2MB')
    return
  }
  uploadFile.value = file
}

async function handleUpload() {
  if (!uploadFile.value) return
  uploading.value = true
  try {
    const res = await uploadMaterial(uploadFile.value)
    ElMessage.success('上传成功')
    uploadFile.value = null
    // Switch to library tab and select the uploaded image
    activeTab.value = 'library'
    fetchImages()
    selected.value = res.data
  } catch {
    // handled by interceptor
  } finally {
    uploading.value = false
  }
}

function handleConfirm() {
  if (activeTab.value === 'library' && selected.value) {
    emit('confirm', { id: selected.value.id, url: selected.value.url })
  }
  visible.value = false
}

watch(visible, (val) => {
  if (val) {
    activeTab.value = 'library'
    filterSidebar.value = 0
    selected.value = null
    page.value = 1
    fetchImages()
  }
})

watch(filterSidebar, () => {
  page.value = 1
  fetchImages()
})
</script>

<style lang="scss" scoped>
.image-selector__tabs {
  display: flex;
  justify-content: center;
  gap: 0;
  background: #f5f5f5;
  border-radius: 4px;
  padding: 2px;
  margin-bottom: 16px;
  width: fit-content;
  margin-left: auto;
  margin-right: auto;
}

.image-selector__tab {
  padding: 6px 16px;
  font-size: 14px;
  color: #666;
  background: transparent;
  border: none;
  cursor: pointer;
  border-radius: 3px;
  transition: all 0.2s;

  &.active {
    background: #fff;
    color: #333;
    font-weight: 500;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }
}

.image-selector__body {
  display: flex;
  min-height: 320px;
}

.image-selector__sidebar {
  width: 80px;
  border-right: 1px solid #e8e8e8;
  padding: 8px 0;
  flex-shrink: 0;
}

.image-selector__sidebar-item {
  padding: 10px 16px;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  border-left: 2px solid transparent;
  transition: all 0.2s;

  &:hover {
    color: #1890ff;
    background: #e6f7ff;
  }

  &.active {
    color: #1890ff;
    border-left-color: #1890ff;
    background: #e6f7ff;
  }
}

.image-selector__content {
  flex: 1;
  padding: 8px 16px;
}

.image-selector__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.image-selector__item {
  aspect-ratio: 4 / 3;
  background: #f5f5f5;
  border-radius: 4px;
  border: 2px solid transparent;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.2s;

  &:hover {
    border-color: #1890ff;
  }

  &.selected {
    border-color: #1890ff;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.image-selector__check {
  position: absolute;
  top: 4px;
  right: 4px;
  width: 20px;
  height: 20px;
  background: #1890ff;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

.image-selector__loading,
.image-selector__empty {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 200px;
  color: #999;
}

.image-selector__pagination {
  display: flex;
  justify-content: center;
  margin-top: 16px;
}

// Upload tab
.image-selector__upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 0;
}

.image-selector__dropzone {
  width: 200px;
  height: 160px;
  border: 2px dashed #d9d9d9;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  background: #fafafa;
  transition: all 0.3s;

  &:hover {
    border-color: #1677ff;
    background: #e6f4ff;
  }

  &.has-file {
    border-color: #52c41a;
    background: #f6ffed;
  }
}

.image-selector__upload-icon {
  font-size: 40px;
  margin-bottom: 8px;
}

.image-selector__upload-text {
  font-size: 13px;
  color: #86909c;
  text-align: center;
  padding: 0 8px;
  word-break: break-all;
}

.image-selector__upload-hint {
  font-size: 13px;
  color: #86909c;
  margin: 16px 0;
}
</style>
