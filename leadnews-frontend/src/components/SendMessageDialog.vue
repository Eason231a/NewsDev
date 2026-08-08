<template>
  <el-dialog
    v-model="visible"
    title="发送私信"
    width="420px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-input
      v-model="content"
      type="textarea"
      :rows="4"
      placeholder="请输入消息内容"
      maxlength="500"
      show-word-limit
    />
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" :disabled="!content.trim()" :loading="sending" @click="handleSend">
        发送
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { sendMessage } from '@/api/fan'
import type { Fan } from '@/types/fan'

const visible = ref(false)
const content = ref('')
const sending = ref(false)
let currentFan: Fan | null = null

function open(fan: Fan) {
  currentFan = fan
  content.value = ''
  visible.value = true
}

async function handleSend() {
  if (!currentFan || !content.value.trim()) return
  sending.value = true
  try {
    await sendMessage({ fanId: currentFan.id, content: content.value.trim() })
    ElMessage.success('发送成功')
    visible.value = false
  } catch {
    // handled by interceptor
  } finally {
    sending.value = false
  }
}

function handleClose() {
  content.value = ''
}

defineExpose({ open })
</script>
