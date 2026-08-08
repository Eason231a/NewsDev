<template>
  <div class="fan-layout">
    <h2>粉丝管理</h2>
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane label="粉丝概况" name="/fan/overview" />
      <el-tab-pane label="粉丝画像" name="/fan/profile" />
      <el-tab-pane label="粉丝列表" name="/fan/list" />
    </el-tabs>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const activeTab = computed(() => route.path)

function handleTabClick(tab: { props: { name: string } }) {
  router.push(tab.props.name)
}
</script>
