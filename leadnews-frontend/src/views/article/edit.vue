<template>
  <div class="article-edit" v-loading="loading">
    <div class="article-edit__editor-section">
      <input
        v-model="form.title"
        type="text"
        class="article-edit__title-input"
        placeholder="请在这里输入标题"
      />
      <QuillEditor v-model="form.content" />
    </div>

    <div class="article-edit__form-section">
      <div class="article-edit__form-row">
        <label class="article-edit__label">标签：</label>
        <input
          v-model="form.tag"
          type="text"
          class="article-edit__text-input"
          placeholder="请输入标签"
          maxlength="20"
          style="max-width: 200px"
        />
        <span class="article-edit__counter">{{ (form.tag || '').length }}/20</span>

        <label class="article-edit__label">频道：</label>
        <el-select
          v-model="form.channelId"
          placeholder="请选择频道"
          style="width: 200px"
          clearable
        >
          <el-option
            v-for="ch in channels"
            :key="ch.id"
            :label="ch.name"
            :value="ch.id"
          />
        </el-select>

        <label class="article-edit__label">定时：</label>
        <el-date-picker
          v-model="form.scheduledAt"
          type="datetime"
          placeholder="请选择日期时间"
          format="YYYY-MM-DD HH:mm:ss"
          value-format="YYYY-MM-DD HH:mm:ss"
          style="width: 200px"
        />
      </div>

      <div class="article-edit__form-row">
        <label class="article-edit__label">封面：</label>
        <CoverUploadArea
          v-model:cover-type="form.coverType"
          v-model:images="coverImages"
        />
      </div>
    </div>

    <div class="article-edit__actions">
      <el-button size="large" @click="handleSaveDraft" :loading="saving">存入草稿</el-button>
      <el-button type="primary" size="large" @click="handleSubmit" :loading="submitting">
        提交审核
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import QuillEditor from '@/components/QuillEditor.vue'
import CoverUploadArea from '@/components/CoverUploadArea.vue'
import { getArticleDetail, updateArticle, updateArticleStatus } from '@/api/article'
import { getChannels } from '@/api/channel'

const route = useRoute()
const router = useRouter()
const loading = ref(true)
const saving = ref(false)
const submitting = ref(false)
const channels = ref<Array<{ id: number; name: string }>>([])

const articleId = Number(route.params.id)

const form = reactive({
  title: '',
  content: '',
  tag: '',
  channelId: undefined as number | undefined,
  coverType: 0,
  scheduledAt: null as string | null,
})

const coverImages = ref<{ materialId: number; url: string }[]>([])

onMounted(async () => {
  try {
    const [detailRes, channelsRes] = await Promise.all([
      getArticleDetail(articleId),
      getChannels(),
    ])
    const article = detailRes.data
    form.title = article.title
    form.content = article.content
    form.tag = article.tag || ''
    form.channelId = article.channelId
    form.coverType = article.coverType
    form.scheduledAt = article.scheduledAt
    coverImages.value = (article.covers || []).map((c) => ({
      materialId: c.materialId,
      url: c.url,
    }))
    channels.value = channelsRes.data
  } catch {
    ElMessage.error('加载文章失败')
  } finally {
    loading.value = false
  }
})

async function buildPayload() {
  return {
    title: form.title,
    content: form.content,
    tag: form.tag || undefined,
    channelId: form.channelId,
    coverType: form.coverType,
    coverMaterialIds: coverImages.value.filter((img) => img.materialId > 0).map((img) => img.materialId),
    scheduledAt: form.scheduledAt || undefined,
  }
}

async function handleSaveDraft() {
  if (!form.title) {
    ElMessage.warning('请输入文章标题')
    return
  }
  saving.value = true
  try {
    await updateArticle(articleId, await buildPayload())
    ElMessage.success('已保存')
    router.push('/article/list')
  } catch {
    // handled by interceptor
  } finally {
    saving.value = false
  }
}

async function handleSubmit() {
  if (!form.title) {
    ElMessage.warning('请输入文章标题')
    return
  }
  if (!form.channelId) {
    ElMessage.warning('请选择频道')
    return
  }
  submitting.value = true
  try {
    await updateArticle(articleId, await buildPayload())
    await updateArticleStatus(articleId, 1)
    ElMessage.success('已提交审核')
    router.push('/article/list')
  } catch {
    // handled by interceptor
  } finally {
    submitting.value = false
  }
}
</script>

<style lang="scss" scoped>
.article-edit {
  max-width: 960px;
  margin: 0 auto;
}

.article-edit__editor-section {
  margin-bottom: 24px;
}

.article-edit__title-input {
  width: 100%;
  font-size: 18px;
  font-weight: 600;
  color: #333;
  padding: 16px 0;
  margin-bottom: 16px;
  border: none;
  border-bottom: 1px solid #f0f0f0;
  outline: none;

  &::placeholder {
    color: #999;
  }
}

.article-edit__form-section {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  padding: 20px;
  margin-bottom: 24px;
}

.article-edit__form-row {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;

  & + & {
    margin-top: 16px;
  }
}

.article-edit__label {
  font-size: 14px;
  color: #666;
  flex-shrink: 0;
}

.article-edit__text-input {
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  font-size: 14px;
  outline: none;

  &:focus {
    border-color: #1890ff;
  }
}

.article-edit__counter {
  font-size: 12px;
  color: #999;
}

.article-edit__actions {
  display: flex;
  justify-content: center;
  gap: 16px;
}
</style>
