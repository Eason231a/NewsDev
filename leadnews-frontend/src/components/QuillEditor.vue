<template>
  <div class="quill-editor-wrapper">
    <QuillEditor
      ref="quillRef"
      v-model:content="content"
      :content-type="contentType"
      :toolbar="toolbarOptions"
      :placeholder="placeholder"
      theme="snow"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

const props = withDefaults(defineProps<{
  modelValue?: string
  placeholder?: string
}>(), {
  modelValue: '',
  placeholder: '请输入正文',
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const content = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const contentType = 'html'
const quillRef = ref<InstanceType<typeof QuillEditor> | null>(null)

const toolbarOptions = [
  ['bold', 'italic', 'underline'],
  ['blockquote'],
  [{ header: [1, 2, 3, false] }],
  [{ list: 'ordered' }, { list: 'bullet' }],
  ['image'],
  [{ align: [] }],
]

</script>

<style lang="scss" scoped>
.quill-editor-wrapper :deep(.ql-editor) {
  min-height: 320px;
  font-size: 14px;
  line-height: 1.8;
}

.quill-editor-wrapper :deep(.ql-toolbar) {
  border-radius: 4px 4px 0 0;
  border-color: #e8e8e8;
}

.quill-editor-wrapper :deep(.ql-container) {
  border-radius: 0 0 4px 4px;
  border-color: #e8e8e8;
}
</style>
