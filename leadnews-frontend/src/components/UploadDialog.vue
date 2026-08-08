<template>
  <el-dialog
    v-model="visible"
    title="上传图片"
    width="520px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="upload-body">
      <label
        :class="['upload-dropzone', { 'has-file': selectedFile }]"
        @dragover.prevent
        @drop.prevent="handleDrop"
      >
        <input
          ref="fileInput"
          type="file"
          accept="image/jpeg,image/png"
          hidden
          @change="handleFileChange"
        />
        <span class="upload-icon">📷</span>
        <span class="upload-text">
          {{ selectedFile ? selectedFile.name : '点击或拖拽文件到此区域上传' }}
        </span>
      </label>
      <p class="upload-hint">支持 jpg、png 格式，单张不超过 2MB</p>

      <div v-if="uploading" class="upload-progress">
        <div class="upload-progress-bar">
          <div class="upload-progress-fill" :style="{ width: progress + '%' }"></div>
        </div>
        <span class="upload-progress-text">上传中 {{ progress }}%</span>
      </div>

      <button
        :class="['upload-start-btn', { active: selectedFile && !uploading }]"
        :disabled="!selectedFile || uploading"
        @click="handleUpload"
      >
        {{ uploading ? '上传中...' : '开始上传' }}
      </button>
    </div>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'

const props = defineProps<{
  modelValue: boolean
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  uploaded: []
}>()

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const fileInput = ref<HTMLInputElement | null>(null)
const selectedFile = ref<File | null>(null)
const uploading = ref(false)
const progress = ref(0)

function handleClose() {
  selectedFile.value = null
  uploading.value = false
  progress.value = 0
}

function handleFileChange(e: Event) {
  const target = e.target as HTMLInputElement
  if (target.files && target.files[0]) {
    validateAndSetFile(target.files[0])
  }
}

function handleDrop(e: DragEvent) {
  const file = e.dataTransfer?.files?.[0]
  if (file) {
    validateAndSetFile(file)
  }
}

function validateAndSetFile(file: File) {
  const allowed = ['image/jpeg', 'image/png']
  if (!allowed.includes(file.type)) {
    ElMessage.error('仅支持 jpg、png 格式的图片')
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    ElMessage.error('图片大小不能超过 2MB')
    return
  }
  selectedFile.value = file
}

async function handleUpload() {
  if (!selectedFile.value) return
  uploading.value = true
  progress.value = 0

  const { uploadMaterial } = await import('@/api/material')
  try {
    await uploadMaterial(selectedFile.value)
    ElMessage.success('上传成功')
    emit('uploaded')
    visible.value = false
  } catch {
    ElMessage.error('上传失败')
  } finally {
    uploading.value = false
    progress.value = 0
  }
}
</script>

<style lang="scss" scoped>
.upload-body {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8px 0;
}

.upload-dropzone {
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

.upload-icon {
  font-size: 40px;
  margin-bottom: 8px;
}

.upload-text {
  font-size: 13px;
  color: #86909c;
  text-align: center;
  padding: 0 8px;
  word-break: break-all;
}

.upload-hint {
  font-size: 13px;
  color: #86909c;
  margin-top: 16px;
}

.upload-progress {
  width: 100%;
  margin-top: 20px;
}

.upload-progress-bar {
  width: 100%;
  height: 8px;
  background: #f2f3f5;
  border-radius: 4px;
  overflow: hidden;
}

.upload-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #1677ff, #4096ff);
  border-radius: 4px;
  transition: width 0.3s;
}

.upload-progress-text {
  display: block;
  text-align: center;
  font-size: 13px;
  color: #1677ff;
  margin-top: 8px;
}

.upload-start-btn {
  margin-top: 24px;
  padding: 10px 32px;
  border-radius: 8px;
  border: none;
  background: #e5e6eb;
  color: #86909c;
  font-size: 14px;
  cursor: not-allowed;

  &.active {
    background: #1890ff;
    color: #fff;
    cursor: pointer;

    &:hover {
      background: #1677ff;
    }
  }
}
</style>
