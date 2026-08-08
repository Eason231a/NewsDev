<template>
  <div class="cover-upload">
    <div class="cover-upload__options">
      <label v-for="opt in coverOptions" :key="opt.value" class="cover-upload__option">
        <input
          type="radio"
          :value="opt.value"
          :checked="coverType === opt.value"
          @change="$emit('update:coverType', opt.value)"
        />
        <span class="cover-upload__radio"></span>
        <span>{{ opt.label }}</span>
      </label>
    </div>

    <div v-if="coverType !== 2" class="cover-upload__areas">
      <div
        v-for="(item, idx) in coverSlots"
        :key="idx"
        class="cover-upload__slot"
        @click="openSelector(idx)"
      >
        <template v-if="item.url">
          <img :src="item.url" alt="封面" class="cover-upload__preview" />
          <span class="cover-upload__remove" @click.stop="removeImage(idx)">✕</span>
        </template>
        <template v-else>
          <span class="cover-upload__placeholder">🖼️</span>
          <span class="cover-upload__placeholder-text">选择图片</span>
        </template>
      </div>
    </div>

    <ImageSelectorDialog
      v-model="showSelector"
      @confirm="(data) => handleImageSelected(data)"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import ImageSelectorDialog from './ImageSelectorDialog.vue'

const props = defineProps<{
  coverType: number
  images: { materialId: number; url: string }[]
}>()

const emit = defineEmits<{
  'update:coverType': [value: number]
  'update:images': [value: { materialId: number; url: string }[]]
}>()

const coverOptions = [
  { value: 0, label: '单图' },
  { value: 1, label: '三图' },
  { value: 2, label: '无图' },
]

const showSelector = ref(false)
const activeSlot = ref(0)

const slotCount = computed(() => (props.coverType === 1 ? 3 : 1))

const coverSlots = computed(() => {
  const slots: { materialId: number; url: string }[] = []
  for (let i = 0; i < slotCount.value; i++) {
    slots.push(props.images[i] || { materialId: 0, url: '' })
  }
  return slots
})

function openSelector(idx: number) {
  activeSlot.value = idx
  showSelector.value = true
}

function handleImageSelected(data: { id: number; url: string }) {
  const newImages = [...props.images]
  newImages[activeSlot.value] = { materialId: data.id, url: data.url }
  // Pad or trim to slot count
  const slots: { materialId: number; url: string }[] = []
  for (let i = 0; i < slotCount.value; i++) {
    slots.push(newImages[i] || { materialId: 0, url: '' })
  }
  emit('update:images', slots)
}

function removeImage(idx: number) {
  const newImages = [...props.images]
  newImages[idx] = { materialId: 0, url: '' }
  emit('update:images', newImages.filter((img) => img.url !== ''))
}
</script>

<style lang="scss" scoped>
.cover-upload__options {
  display: flex;
  gap: 24px;
  margin-bottom: 16px;
}

.cover-upload__option {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;

  input {
    display: none;
  }
}

.cover-upload__radio {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 1.5px solid #d9d9d9;
  display: inline-block;

  input:checked + & {
    border-color: #1890ff;
    background: #1890ff;
    box-shadow: inset 0 0 0 2px #fff;
  }
}

.cover-upload__areas {
  display: flex;
  gap: 16px;
}

.cover-upload__slot {
  width: 160px;
  height: 100px;
  border: 1px dashed #d9d9d9;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  background: #fafafa;
  transition: border-color 0.2s;

  &:hover {
    border-color: #1890ff;
  }
}

.cover-upload__placeholder {
  font-size: 24px;
}

.cover-upload__placeholder-text {
  font-size: 14px;
  color: #999;
}

.cover-upload__preview {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cover-upload__remove {
  position: absolute;
  top: 4px;
  right: 4px;
  width: 18px;
  height: 18px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
}
</style>
