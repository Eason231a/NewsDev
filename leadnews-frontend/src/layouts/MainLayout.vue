<template>
  <el-container class="main-layout">
    <el-aside :width="sidebarWidth" class="main-sidebar">
      <div class="sidebar-header">
        <span class="sidebar-header__icon">H</span>
        <span v-show="!appStore.sidebarCollapsed" class="sidebar-header__title">黑马头条</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        :collapse="appStore.sidebarCollapsed"
        background-color="#ffffff"
        text-color="#666666"
        active-text-color="#1890ff"
        router
      >
        <template v-for="item in menuItems" :key="item.path">
          <el-sub-menu v-if="item.children" :index="item.path">
            <template #title>
              <el-icon><component :is="item.icon" /></el-icon>
              <span>{{ item.title }}</span>
            </template>
            <el-menu-item
              v-for="child in item.children"
              :key="child.path"
              :index="child.path"
            >
              {{ child.title }}
            </el-menu-item>
          </el-sub-menu>
          <el-menu-item v-else :index="item.path">
            <el-icon><component :is="item.icon" /></el-icon>
            <template #title>{{ item.title }}</template>
          </el-menu-item>
        </template>
      </el-menu>
      <div class="sidebar-footer">
        <el-dropdown trigger="click" @command="handleCommand">
          <div class="sidebar-footer__user">
            <el-avatar :size="32" :src="userStore.userInfo?.avatar" class="sidebar-footer__avatar">
              <el-icon :size="16"><UserFilled /></el-icon>
            </el-avatar>
            <span v-show="!appStore.sidebarCollapsed" class="sidebar-footer__name">
              {{ userStore.userInfo?.username || '用户' }}
            </span>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-aside>
    <el-container>
      <el-header class="main-header">
        <div class="header-left">
          <el-icon
            class="collapse-btn"
            :size="22"
            @click="appStore.toggleSidebar"
          >
            <Fold v-if="!appStore.sidebarCollapsed" />
            <Expand v-else />
          </el-icon>
        </div>
        <div class="header-right">
          <el-icon :size="20"><Bell /></el-icon>
        </div>
      </el-header>
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  DataLine,
  Edit,
  Document,
  Picture,
  User,
  Fold,
  Expand,
  Bell,
  UserFilled,
} from '@element-plus/icons-vue'
import { useAppStore } from '@/stores/app'
import { useUserStore } from '@/stores/user'
import type { Component } from 'vue'

interface MenuItem {
  path: string
  title: string
  icon: Component
  children?: MenuItem[]
}

const route = useRoute()
const router = useRouter()
const appStore = useAppStore()
const userStore = useUserStore()

const sidebarWidth = computed(() =>
  appStore.sidebarCollapsed ? '64px' : '210px',
)

const activeMenu = computed(() => route.path)

const menuItems: MenuItem[] = [
  { path: '/dashboard', title: '图文数据', icon: DataLine },
  { path: '/article/create', title: '发布文章', icon: Edit },
  { path: '/article/list', title: '内容列表', icon: Document },
  { path: '/material', title: '素材管理', icon: Picture },
  { path: '/fan', title: '粉丝管理', icon: User },
]

function handleCommand(command: string) {
  if (command === 'logout') {
    userStore.logout()
    router.push('/login')
  }
}

watch(
  () => userStore.token,
  (val) => {
    if (val) {
      userStore.fetchUser()
    }
  },
  { immediate: true },
)
</script>

<style lang="scss" scoped>
.main-layout {
  height: 100%;
}

.main-sidebar {
  background-color: #f5f7fa;
  border-right: 1px solid #e8e8e8;
  transition: width 0.3s;
  overflow: hidden;
  display: flex;
  flex-direction: column;

  .sidebar-header {
    display: flex;
    align-items: center;
    height: 60px;
    padding: 0 16px;
    border-bottom: 1px solid #e8e8e8;
    gap: 10px;

    &__icon {
      width: 32px;
      height: 32px;
      background: #1890ff;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 16px;
      font-weight: 600;
      flex-shrink: 0;
    }

    &__title {
      font-size: 14px;
      font-weight: 600;
      color: #333;
      white-space: nowrap;
    }
  }

  .el-menu {
    border-right: none;
    flex: 1;
  }

  .sidebar-footer {
    border-top: 1px solid #e8e8e8;
    padding: 12px 16px;

    &__user {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
    }

    &__avatar {
      flex-shrink: 0;
    }

    &__name {
      font-size: 14px;
      color: #333;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
}

.main-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
  padding: 0 20px;

  .collapse-btn {
    cursor: pointer;
    &:hover {
      color: #409eff;
    }
  }

  .header-right {
    color: #666;
    cursor: pointer;
  }
}

.main-content {
  background: #f5f7fa;
  padding: 20px;
  overflow-y: auto;
}
</style>
