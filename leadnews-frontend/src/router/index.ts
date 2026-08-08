import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { getToken } from '@/utils/auth'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { requiresAuth: false },
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    meta: { requiresAuth: true },
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/dashboard/index.vue'),
        meta: { title: '图文数据', icon: 'DataLine' },
      },
      {
        path: 'article/create',
        name: 'ArticleCreate',
        component: () => import('@/views/article/create.vue'),
        meta: { title: '发布文章', icon: 'Edit' },
      },
      {
        path: 'article/edit/:id',
        name: 'ArticleEdit',
        component: () => import('@/views/article/edit.vue'),
        meta: { title: '编辑文章', hidden: true },
      },
      {
        path: 'article/list',
        name: 'ArticleList',
        component: () => import('@/views/article/list.vue'),
        meta: { title: '内容列表', icon: 'Document' },
      },
      {
        path: 'material',
        name: 'Material',
        component: () => import('@/views/material/index.vue'),
        meta: { title: '素材管理', icon: 'Picture' },
      },
      {
        path: 'dashboard/article/:articleId',
        name: 'ArticleDetail',
        component: () => import('@/views/stats/article-detail.vue'),
        meta: { title: '文章数据详情', hidden: true },
      },
      {
        path: 'fan',
        name: 'FanLayout',
        component: () => import('@/views/fan/index.vue'),
        meta: { title: '粉丝管理', icon: 'User' },
        redirect: '/fan/overview',
        children: [
          {
            path: 'overview',
            name: 'FanOverview',
            component: () => import('@/views/fan/overview.vue'),
            meta: { title: '粉丝概况' },
          },
          {
            path: 'profile',
            name: 'FanProfile',
            component: () => import('@/views/fan/profile.vue'),
            meta: { title: '粉丝画像' },
          },
          {
            path: 'list',
            name: 'FanList',
            component: () => import('@/views/fan/list.vue'),
            meta: { title: '粉丝列表' },
          },
        ],
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// Global navigation guard
router.beforeEach((to, _from, next) => {
  const token = getToken()

  if (to.path === '/login') {
    if (token) {
      next('/dashboard')
    } else {
      next()
    }
    return
  }

  if (!token) {
    next('/login')
    return
  }

  next()
})

export default router
