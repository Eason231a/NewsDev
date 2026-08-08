# 黑马头条前端 - 开发执行计划

> **版本**: V1.0 | **创建时间**: 2026-06-30
> **状态**: 🟡 待启动
>
> **约束规则**: 请遵守 `../CLAUDE.md` 和根目录 `CLAUDE.md` 中的全局规范。
>
> **Figma 链接**: 每个阶段开发前向用户获取，在此文件中标注对应阶段的 Figma 链接。

---

## 进度总览

| 阶段 | 模块 | 状态 | 开始时间 | 完成时间 | 备注 |
|------|------|:----:|---------|---------|------|
| 1 | 基础环境工程 | ✅ 已完成 | 2026-06-30 | 2026-08-08 | Vite 6.4 + Vue 3.5 + TS 5.7 + Element Plus 2.14 + Pinia 2.3 |
| 2 | 认证模块 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | 登录页100%还原原型 + 左侧品牌区+右侧表单 + 侧边栏用户信息 + Token管理 + 路由守卫 |
| 3 | 素材管理 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | 原型还原：卡片网格(7列)+分段控件+上传弹窗+收藏/删除+分页 |
| 4 | 发布文章 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | Quill编辑器+自定义工具栏+图片选择弹窗+封面单图/三图/无图+存草稿/提交审核 |
| 5 | 内容列表 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | 状态筛选标签+关键字搜索+频道/日期筛选+7列卡片网格+悬停操作+分页 |
| 6 | 图文数据 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | DateFilterBar+StatsCards+ECharts环形图+数据概览+文章详情 |
| 7 | 粉丝管理-粉丝概况 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | DateFilterBar+4统计卡片+24h趋势折线图+数据表格+分页 |
| 8 | 粉丝管理-粉丝画像 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | PortraitBarChart+PortraitColumnChart+6维度画像+2列网格布局 |
| 9 | 粉丝管理-粉丝列表 | ✅ 已完成 | 2026-08-08 | 2026-08-08 | FanCard+SendMessageDialog+6列网格+点击加载更多+拉黑/取消拉黑 |

> **上次更新**: 2026-08-08 - 阶段9粉丝列表完成（全部9个阶段已完成）

---

## 阶段1：基础环境工程

### 1.1 目标
搭建 Vue 3 + TypeScript + Vite 前端工程，配置基础依赖、项目结构、路由、状态管理、HTTP 客户端，确保项目可启动运行。

### 1.2 Figma 链接
无需 Figma 链接（基础工程无页面）。

### 1.3 技术栈与版本

| 依赖 | 版本 | 用途 |
|------|------|------|
| vue | ^3.5 | 核心框架 |
| typescript | ~5.7 | 类型安全 |
| vite | ^6.3 | 构建工具 |
| element-plus | ^2.14 | UI 组件库 |
| pinia | ^2.3 | 状态管理 |
| vue-router | ^4.5 | 路由 |
| axios | ^1.10 | HTTP 客户端 |
| @vueup/vue-quill | ^2.2 | 富文本编辑器 |
| dayjs | ^1.11 | 日期处理 |
| echarts | ^5.6 | 图表库 |
| sass | ^1.86 | CSS 预处理 |

### 1.4 项目初始化任务

| # | 任务 | 说明 |
|---|------|------|
| 1.1 | 创建 Vite + Vue 3 + TS 项目 | `npm create vite@latest leadnews-frontend -- --template vue-ts` |
| 1.2 | 安装全部依赖 | npm install 上述所有依赖 |
| 1.3 | 创建项目目录结构 | 按照 CLAUDE.md 规定的目录结构创建 |
| 1.4 | 配置 Vite | 配置 `@` 别名指向 `src/`，配置 SCSS 全局变量 |
| 1.5 | 配置 TypeScript | 配置路径别名、严格模式 |
| 1.6 | 创建 `src/utils/request.ts` | Axios 实例 + 请求拦截器（注入 Token）+ 响应拦截器（统一错误处理、401 跳转） |
| 1.7 | 创建 `src/utils/auth.ts` | Token 存取工具函数（localStorage） |
| 1.8 | 创建 `src/utils/date.ts` | 日期格式化工具函数（dayjs） |
| 1.9 | 创建 `src/stores/user.ts` | 用户 Store（Token、用户信息、登录/登出/获取信息方法） |
| 1.10 | 创建 `src/stores/app.ts` | 应用 Store（侧边栏折叠状态等） |
| 1.11 | 创建 `src/router/index.ts` | 路由配置 + 全局守卫（未登录→/login，已登录→/login则跳转/dashboard） |
| 1.12 | 创建 `src/layouts/MainLayout.vue` | 主布局：左侧可折叠侧边栏 + 顶部导航栏 + 右侧 `<router-view>` 内容区 |
| 1.13 | 创建 `src/styles/variables.scss` | Element Plus 主题变量覆盖、全局 SCSS 变量 |
| 1.14 | 创建 `src/styles/global.scss` | 全局样式重置、通用工具类 |
| 1.15 | 创建 `src/types/` | 通用 TypeScript 类型定义（API 响应、分页等） |
| 1.16 | 修改 `src/main.ts` | 注册 Element Plus、Router、Pinia、全局样式 |
| 1.17 | 修改 `src/App.vue` | 根组件，放置 `<router-view>` |

### 1.5 项目目录结构（目标）

```
src/
├── api/                  # 接口请求模块
│   ├── auth.ts
│   ├── article.ts
│   ├── channel.ts
│   ├── material.ts
│   ├── stats.ts
│   └── fan.ts
├── assets/               # 静态资源
├── components/            # 全局公共组件
├── composables/           # 组合式函数
├── layouts/
│   └── MainLayout.vue     # 主布局（侧边栏 + 顶栏 + 内容区）
├── router/
│   └── index.ts           # 路由配置 + 守卫
├── stores/
│   ├── user.ts            # 用户状态
│   └── app.ts             # 应用状态
├── styles/
│   ├── variables.scss     # SCSS 变量
│   └── global.scss        # 全局样式
├── types/
│   ├── api.ts             # API 通用类型
│   ├── user.ts            # 用户类型
│   ├── article.ts         # 文章类型
│   ├── material.ts        # 素材类型
│   ├── stats.ts           # 统计类型
│   └── fan.ts             # 粉丝类型
├── utils/
│   ├── request.ts         # Axios 实例
│   ├── auth.ts            # Token 工具
│   └── date.ts            # 日期工具
├── views/
│   ├── login/             # 登录页
│   ├── dashboard/         # 图文数据
│   ├── article/           # 发布文章 + 内容列表
│   ├── material/          # 素材管理
│   ├── fan/               # 粉丝管理
│   └── stats/             # 图文数据统计
├── App.vue
└── main.ts
```

### 1.6 关键架构设计

#### 请求流程
```
组件 → api/xxx.ts → request.ts(Axios实例) → 请求拦截器(注入JWT) → 后端
                                                  ↓
                              响应拦截器(统一错误处理、ElMessage提示、401→/login)
```

#### 路由守卫
```
未登录 + 非/login → 重定向 /login
已登录 + /login → 重定向 /dashboard（默认首页为图文数据）
Token过期 + 401响应 → 清除Token → 跳转 /login
```

#### 侧边栏菜单
| 菜单项 | 图标 | 路由 | Vue组件 |
|--------|------|------|---------|
| 图文数据 | DataLine | `/dashboard` | views/dashboard/index.vue |
| 发布文章 | Edit | `/article/create` | views/article/create.vue |
| 内容列表 | Document | `/article/list` | views/article/list.vue |
| 素材管理 | Picture | `/material` | views/material/index.vue |
| 粉丝管理 | User | `/fan` | views/fan/index.vue |

### 1.7 测试验证

| # | 验证项 | 方法 |
|---|--------|------|
| 1 | `npm run dev` 启动无报错 | 终端检查 |
| 2 | 浏览器打开 http://localhost:5173 能看到页面 | 浏览器验证 |
| 3 | 未登录时自动跳转 /login | 访问任意路径 |
| 4 | 登录页（空白占位）正常显示 | 浏览器截图 |

---

## 阶段2：认证模块

### 2.1 目标
实现登录页面和认证逻辑，包括：登录表单、用户协议确认、登录/登出、Token 管理、路由守卫集成。

### 2.2 Figma 链接
> ✅ 已获取
> - 登录页: `https://www.figma.com/design/H17BihSfMCKFCLYUoAMKMd/黑马头条?node-id=30-68`
> - 侧边栏布局: `https://www.figma.com/design/H17BihSfMCKFCLYUoAMKMd/黑马头条?node-id=240-264`

### 2.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/login` | 登录页 | 公开 |

### 2.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| LoginPage | `src/views/login/index.vue` | 登录页主组件 |

### 2.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 登录 | POST | `/auth/login` | 用户名+密码+同意协议 |
| 获取用户信息 | GET | `/auth/me` | 获取当前登录用户信息 |
| 刷新Token | POST | `/auth/refresh` | Token续期 |

### 2.6 类型定义

```typescript
// src/types/user.ts
interface LoginRequest { username: string; password: string; agreeTerms: boolean }
interface LoginResponse { token: string; expiresAt: string; user: UserInfo }
interface UserInfo { id: number; username: string; avatar: string | null; status: number; lastLoginAt: string }
```

```typescript
// src/types/api.ts
interface ApiResponse<T> { code: number; message: string; data: T }
```

### 2.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 2.1 | 获取 Figma 设计稿 | 向用户索要登录页 Figma 链接，用 MCP 获取设计数据 |
| 2.2 | 创建 `src/types/api.ts` | 通用 API 响应类型、分页类型 |
| 2.3 | 创建 `src/types/user.ts` | 用户相关类型定义 |
| 2.4 | 创建 `src/api/auth.ts` | 登录 `login()`、获取用户信息 `getUserInfo()`、刷新 Token `refreshToken()` |
| 2.5 | 完善 `src/stores/user.ts` | 实现 `login()` action（调接口→存Token→存用户信息）、`logout()`（清Token→跳登录）、`fetchUser()`（获取用户信息） |
| 2.6 | 实现 `src/views/login/index.vue` | 左侧品牌展示区 + 右侧登录表单（用户名、密码、同意协议复选框、登录按钮） |
| 2.7 | 完善路由守卫 | 登录成功后跳转 `/dashboard`，401 时清除状态跳转 `/login` |
| 2.8 | 侧边栏用户信息显示 | MainLayout 底部显示头像 + 用户名，点击可登出 |

### 2.8 登录页布局（参考需求文档）

- **左侧**: "欢迎使用 黑马头条自媒体人管理系统" + 品牌插图
- **右侧**: 登录表单
  - 用户名输入框（必填）
  - 密码输入框（必填）
  - "我已阅读并同意用户协议和隐私政策条款" 复选框
  - 登录按钮（未勾选协议时不可点击或提示）

### 2.9 测试验证

| # | 验证项 |
|---|--------|
| 1 | 登录页 UI 与 Figma 设计稿 100% 一致 |
| 2 | 未勾选协议时登录按钮禁用或提示 |
| 3 | 输入正确用户名密码，登录成功跳转 /dashboard |
| 4 | 输入错误密码，显示错误提示 |
| 5 | 登录成功后刷新页面，Token 仍在 localStorage，无需重新登录 |
| 6 | Token 过期后访问接口，自动跳转登录页 |

---

## 阶段3：素材管理

### 3.1 目标
实现素材管理页面，包括：图片网格展示、上传图片、收藏/取消收藏、删除素材、分页。

### 3.2 Figma 链接
> ✅ 已获取
> - 素材管理页: `https://www.figma.com/design/H17BihSfMCKFCLYUoAMKMd/黑马头条?node-id=104-4`
> - 上传弹窗: `https://www.figma.com/design/H17BihSfMCKFCLYUoAMKMd/黑马头条?node-id=148-6`

### 3.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/material` | 素材管理页 | 需登录 |

### 3.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| MaterialPage | `src/views/material/index.vue` | 素材管理主页面 |
| MaterialCard | `src/components/MaterialCard.vue` | 素材卡片（图片预览+收藏+删除） |
| UploadDialog | `src/components/UploadDialog.vue` | 上传图片弹窗 |
| MaterialFilterTabs | `src/components/MaterialFilterTabs.vue` | 全部/收藏标签切换 |

### 3.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 素材列表 | GET | `/materials` | `isFavorite`/`startDate`/`endDate`/`page`/`pageSize` |
| 上传素材 | POST | `/materials/upload` | multipart/form-data，`file` 字段 |
| 切换收藏 | PATCH | `/materials/{id}/favorite` | `isFavorite`: 1=收藏/0=取消 |
| 删除素材 | DELETE | `/materials/{id}` | 软删除 |

### 3.6 类型定义

```typescript
// src/types/material.ts
interface Material {
  id: number
  filename: string
  url: string
  fileSize: number
  mimeType: string
  isFavorite: number  // 0=未收藏 1=已收藏
  createdAt: string
}
interface MaterialQuery {
  isFavorite?: number
  startDate?: string
  endDate?: string
  page: number
  pageSize: number
}
```

### 3.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 3.1 | 获取 Figma 设计稿 | 向用户索要素材管理页 Figma 链接 |
| 3.2 | 创建 `src/types/material.ts` | 素材相关类型定义 |
| 3.3 | 创建 `src/api/material.ts` | `getMaterials()`、`uploadMaterial()`、`toggleFavorite()`、`deleteMaterial()` |
| 3.4 | 实现 MaterialFilterTabs | 全部 / 收藏标签切换，显示已上传图片总数 |
| 3.5 | 实现 MaterialCard | 图片预览、☆收藏/★已收藏切换、删除按钮 |
| 3.6 | 实现 UploadDialog | 文件选择区（虚线框）、格式说明（jpg/png ≤2MB）、开始上传按钮、进度条 |
| 3.7 | 实现 MaterialPage | 组合上述组件，分页逻辑 |
| 3.8 | 删除确认 | 删除时弹出确认框（ElMessageBox） |
| 3.9 | 空状态处理 | 无素材时显示空状态提示 |

### 3.8 页面状态

| 状态 | 处理 |
|------|------|
| 加载中 | 骨架屏或 loading 动画 |
| 空数据 | 显示"暂无素材"空状态插画 |
| 上传中 | 进度条 + 禁用上传按钮 |
| 上传失败 | 错误提示 |
| 删除成功 | 列表刷新 + 成功提示 |

### 3.9 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 全部/收藏标签切换正常，数据正确 |
| 3 | 上传图片（jpg/png ≤2MB）成功 |
| 4 | 超过 2MB 或非 jpg/png 上传失败并提示 |
| 5 | 收藏/取消收藏切换正常 |
| 6 | 删除素材成功，列表刷新 |
| 7 | 分页功能正常 |
| 8 | 空状态显示正常 |

---

## 阶段4：发布文章

### 4.1 目标
实现文章创作与发布页面：富文本编辑、标签/频道/封面/定时发布设置、插入图片（从素材库选择或本地上传）、存入草稿/提交审核。

### 4.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供发布文章页 Figma 链接。

### 4.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/article/create` | 发布文章页 | 需登录 |
| `/article/edit/:id` | 编辑文章页 | 需登录（草稿/审核失败可编辑） |

### 4.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| ArticleCreatePage | `src/views/article/create.vue` | 发布文章主页面 |
| ArticleEditPage | `src/views/article/edit.vue` | 编辑文章页面（复用 create 组件） |
| ImageSelectorDialog | `src/components/ImageSelectorDialog.vue` | 插入图片弹窗（素材库标签+本地上传标签） |
| CoverUploadArea | `src/components/CoverUploadArea.vue` | 封面图片上传区域（单图/三图/无图） |

### 4.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 创建文章 | POST | `/articles` | 标题+正文+标签+频道+封面+定时 |
| 更新文章 | PUT | `/articles/{id}` | 编辑后保存（草稿/驳回） |
| 获取文章详情 | GET | `/articles/{id}` | 编辑时回显数据 |
| 提交审核 | PATCH | `/articles/{id}/status` | `action: "submit"` |
| 频道列表 | GET | `/channels` | 频道下拉框数据 |
| 状态枚举 | GET | `/articles/enums/status` | 获取状态枚举值 |
| 封面类型枚举 | GET | `/articles/enums/cover-type` | 获取封面类型枚举值 |
| 素材列表 | GET | `/materials` | 插入图片弹窗数据源 |
| 上传素材 | POST | `/materials/upload` | 本地上传（插入图片弹窗内） |

### 4.6 类型定义

```typescript
// src/types/article.ts
interface ArticleCreateRequest {
  channelId?: number
  title: string
  content?: string        // JSON 字符串（Quill Delta格式）
  tag?: string            // 逗号分隔，单标签≤20字符
  coverType?: number      // 0=单图 1=三图 2=无图
  coverMaterialIds?: number[]
  scheduledAt?: string    // yyyy-MM-dd HH:mm:ss
}

interface ArticleDetail {
  id: number
  userId: number
  username: string
  channelId: number
  channelName: string
  title: string
  content: string         // JSON 字符串
  tag: string
  coverType: number
  status: number
  reviewComment: string | null
  scheduledAt: string | null
  publishedAt: string | null
  createdAt: string
  updatedAt: string
  covers: CoverImage[]
}

interface CoverImage {
  id: number
  materialId: number
  sortOrder: number
  url: string
}
```

### 4.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 4.1 | 获取 Figma 设计稿 | 向用户索要发布文章页 Figma 链接 |
| 4.2 | 创建 `src/types/article.ts` | 文章相关类型定义 |
| 4.3 | 创建 `src/api/article.ts` | `createArticle()`、`updateArticle()`、`getArticleDetail()`、`submitForReview()` |
| 4.4 | 创建 `src/api/channel.ts` | `getChannels()` 获取频道列表 |
| 4.5 | 初始化 Quill 编辑器 | 配置工具栏：加粗/斜体/下划线/标题/引用/有序列表/无序列表/插入图片/对齐方式 |
| 4.6 | 实现 ImageSelectorDialog | 双标签（素材库+本地上传），素材库左侧筛选（全部/收藏），图片网格单选，分页，确定/取消按钮 |
| 4.7 | 实现 CoverUploadArea | 根据封面类型（单图/三图/无图）显示不同上传区域 |
| 4.8 | 实现文章表单区域 | 标签输入（≤20字符，显示计数0/20）、频道下拉、定时日期时间选择器、封面类型单选 |
| 4.9 | 实现 ArticleCreatePage | 组合编辑器、表单、封面区域，存草稿/提交审核按钮 |
| 4.10 | 实现 ArticleEditPage | 复用创建页组件，回显已有数据 |
| 4.11 | 表单校验 | 标题必填、频道必填（提交审核时） |
| 4.12 | 状态处理 | 加载中、保存中、错误提示 |
| 4.13 | 离开确认 | 内容有修改未保存时，离开页面前确认 |

### 4.8 发布文章页布局（参考需求文档）

```
┌──────────────────────────────────────────────┐
│ [标题输入框]                                   │
├──────────────────────────────────────────────┤
│ [富文本编辑器工具栏: B I U H 引用 OL UL 图 对齐] │
├──────────────────────────────────────────────┤
│ [正文编辑区]                                   │
│                                              │
├──────────────────────────────────────────────┤
│ 标签: [_______] 0/20  频道: [___选择___]      │
│ 定时: [日期时间选择器]                         │
│ 封面: ○单图 ○三图 ○无图                        │
│ [封面图片上传区域]                             │
├──────────────────────────────────────────────┤
│              [存入草稿]  [提交审核]             │
└──────────────────────────────────────────────┘
```

### 4.9 富文本编辑器 Quill 工具栏配置

```typescript
const toolbarOptions = [
  ['bold', 'italic', 'underline'],    // 加粗、斜体、下划线
  ['blockquote'],                      // 引用
  [{ header: [1, 2, 3, false] }],     // 标题
  [{ list: 'ordered' }, { list: 'bullet' }], // 有序/无序列表
  ['image'],                           // 插入图片（触发素材弹窗）
  [{ align: [] }],                     // 对齐方式
]
```

### 4.10 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 富文本编辑器所有工具栏按钮正常工作 |
| 3 | 插入图片弹窗：素材库标签显示已有素材，本地上传标签可上传新图片 |
| 4 | 选择素材库图片后，点击确定插入到编辑器光标位置 |
| 5 | 标签输入显示字符计数（0/20），超过20字符截断 |
| 6 | 频道下拉框正常加载数据 |
| 7 | 封面类型切换（单图→三图→无图），上传区域动态变化 |
| 8 | 存入草稿：调 POST /articles（status字段后端默认为0），跳转内容列表 |
| 9 | 提交审核：先创建文章，再调 PATCH /articles/{id}/status action=submit |
| 10 | 编辑草稿：回显数据，修改后保存成功 |

---

## 阶段5：内容列表

### 5.1 目标
实现文章内容列表页面：状态筛选标签、关键字搜索、频道筛选、日期范围筛选、文章卡片展示、状态标签颜色、悬停操作按钮。

### 5.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供内容列表页 Figma 链接。

### 5.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/article/list` | 内容列表页 | 需登录 |

### 5.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| ArticleListPage | `src/views/article/list.vue` | 内容列表主页面 |
| ArticleCard | `src/components/ArticleCard.vue` | 文章卡片（封面、标题、日期、状态、操作按钮） |
| StatusFilterTabs | `src/components/StatusFilterTabs.vue` | 状态筛选标签（全部/草稿/待审核/审核通过/审核失败） |
| ArticleSearchBar | `src/components/ArticleSearchBar.vue` | 关键字搜索、频道筛选、日期筛选 |

### 5.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 文章列表 | GET | `/articles` | status/channelId/keyword/startDate/endDate/sortBy/order/page/pageSize |
| 删除文章 | DELETE | `/articles/{id}` | 软删除（草稿+审核失败可删） |
| 上架 | PATCH | `/articles/{id}/status` | `action: "publish"` |
| 下架 | PATCH | `/articles/{id}/status` | `action: "unpublish"` |
| 状态枚举 | GET | `/articles/enums/status` | 获取状态标签颜色和文字 |
| 频道列表 | GET | `/channels` | 频道下拉筛选 |

### 5.6 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 5.1 | 获取 Figma 设计稿 | 向用户索要内容列表页 Figma 链接 |
| 5.2 | 实现 StatusFilterTabs | 全部/草稿/待审核/审核通过/审核失败 标签切换（单选） |
| 5.3 | 实现 ArticleSearchBar | 关键字输入框、频道下拉筛选、创建日期范围筛选 |
| 5.4 | 实现 ArticleCard | 卡片布局：封面图、标题、创建日期、状态标签（带颜色）、悬停显示操作按钮 |
| 5.5 | 实现状态标签 | 草稿(灰)、待审核(橙)、审核通过(绿)、审核失败(红)、已上架(蓝)、已下架(灰) |
| 5.6 | 实现操作按钮逻辑 | 草稿→编辑+删除；审核失败→编辑+删除；已上架→下架；已下架→上架；待审核→无操作 |
| 5.7 | 实现 ArticleListPage | 组合筛选区 + 卡片列表 + 分页 |
| 5.8 | 加载/空/错误状态 | Skeleton loading、空数据提示、错误重试 |
| 5.9 | 操作确认 | 删除、下架等敏感操作弹出确认框 |
| 5.10 | 编辑跳转 | 点击"编辑"跳转 `/article/edit/:id` |

### 5.7 状态标签映射

| 状态值 | 标签 | 颜色 | 可用操作 |
|--------|------|------|---------|
| 0 | 草稿 | #999 灰色 | 编辑、删除 |
| 1 | 待审核 | #fa8c16 橙色 | — |
| 2 | 审核通过 | #52c41a 绿色 | — |
| 3 | 审核失败 | #ff4d4f 红色 | 编辑、删除 |
| 4 | 已上架 | #1890ff 蓝色 | 下架 |
| 5 | 已下架 | #999 灰色 | 上架 |

### 5.8 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 默认显示全部文章，卡片正常渲染 |
| 3 | 状态筛选标签切换，数据正确 |
| 4 | 关键字搜索 + 频道筛选 + 日期范围筛选组合可用 |
| 5 | 卡片悬停显示对应操作按钮 |
| 6 | 编辑按钮跳转到编辑页 |
| 7 | 删除确认后文章从列表移除 |
| 8 | 上架/下架操作后状态更新 |
| 9 | 分页正常 |
| 10 | 空状态显示 |

---

## 阶段6：图文数据

### 6.1 目标
实现图文数据列表页（数据概览 + 文章数据表格）和文章数据详情页（统计卡片 + 阅读来源/完成度分析图表）。

### 6.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供以下 Figma 链接：
> - 图文数据列表页
> - 文章数据详情页

### 6.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/dashboard` | 图文数据列表页 | 需登录（默认首页） |
| `/dashboard/article/:articleId` | 文章数据详情页 | 需登录 |

### 6.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| DashboardPage | `src/views/dashboard/index.vue` | 图文数据列表主页面 |
| ArticleDetailPage | `src/views/stats/article-detail.vue` | 文章数据详情页（统计卡片+图表） |
| StatsCards | `src/components/StatsCards.vue` | 统计指标卡片组（可复用） |
| DateFilterBar | `src/components/DateFilterBar.vue` | 日期筛选区（日期选择器+快捷按钮） |
| ReadSourceChart | `src/components/ReadSourceChart.vue` | 阅读来源分析环形图 |
| ReadCompletionChart | `src/components/ReadCompletionChart.vue` | 阅读完成度分析环形图 |

### 6.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 图文数据概览 | GET | `/article-stats/overview` | startDate/endDate，返回4个汇总指标 |
| 图文数据列表 | GET | `/article-stats` | startDate/endDate/page/pageSize |
| 文章数据详情 | GET | `/article-stats/{articleId}` | startDate/endDate，返回8个指标 |
| 阅读来源分析 | GET | `/articles/{articleId}/read-sources` | startDate/endDate |
| 阅读完成度分析 | GET | `/articles/{articleId}/read-completion` | startDate/endDate |

### 6.6 类型定义

```typescript
// src/types/stats.ts
interface StatsOverview {
  totalArticles: number    // 图文发布量
  totalReads: number
  totalLikes: number       // 点赞数量
  totalComments: number
  totalFavorites: number   // 收藏数量
  totalShares: number      // 转发数量
}

interface ArticleStatsItem {
  articleId: number
  articleTitle: string
  readCount: number        // 阅读
  likeCount: number
  commentCount: number     // 评论量
  favoriteCount: number    // 收藏量
  shareCount: number       // 转发量
  statDate: string
}

interface ArticleStatsDetail {
  articleId: number
  articleTitle: string
  readCount: number        // 总阅读量
  likeCount: number
  commentCount: number      // 评论量
  favoriteCount: number
  shareCount: number
  avgReadProgress: number   // 平均阅读进度
  bounceRate: number        // 跳出率
  avgReadSeconds: number    // 平均阅读时间
  recommendShares: number   // 推荐转发量
  fanReadCount: number      // 粉丝阅读量
}

interface ReadSource {
  sourceType: number
  label: string
  readCount: number
  percentage: number
  color: string
}

interface ReadCompletion {
  range: number
  label: string
  userCount: number
  percentage: number
  color: string
}
```

### 6.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 6.1 | 获取 Figma 设计稿 | 向用户索要图文数据两个页面的 Figma 链接 |
| 6.2 | 创建 `src/types/stats.ts` | 统计相关类型定义 |
| 6.3 | 创建 `src/api/stats.ts` | `getOverview()`、`getArticleStats()`、`getArticleDetail()`、`getReadSources()`、`getReadCompletion()` |
| 6.4 | 实现 DateFilterBar | 开始日期+结束日期选择器、今日/本周/近7天(默认)/近30天快捷按钮 |
| 6.5 | 实现 StatsCards | 可配置的统计卡片组（接收指标列表，渲染对应颜色的卡片） |
| 6.6 | 实现图文数据列表页 | DateFilterBar + 4个统计卡片（图文发布量/点赞数量/收藏数量/转发数量）+ 数据表格 + 分页 |
| 6.7 | 表格操作列 | "详细分析" 链接，点击跳转文章数据详情页 |
| 6.8 | 实现文章数据详情页 | 返回按钮 + DateFilterBar + 8个统计卡片（分两行4+3）+ 2个环形图 |
| 6.9 | 实现 ReadSourceChart | 使用 ECharts 环形图，5种来源不同颜色，中间显示总阅读量 |
| 6.10 | 实现 ReadCompletionChart | 使用 ECharts 环形图，3个区间不同颜色 |
| 6.11 | ECharts 初始化 | 安装 echarts 依赖，按需引入，响应式 resize |

### 6.8 页面布局

#### 图文数据列表页（/dashboard）
```
┌─────────────────────────────────────────────────────┐
│ [日期筛选: 开始日期][结束日期] [今日][本周][近7天][近30天] │
├─────────────────────────────────────────────────────┤
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐               │
│ │图文发│ │点赞数│ │收藏数│ │转发数│               │
│ │ 布量 │ │  量  │ │  量  │ │  量  │               │
│ └──────┘ └──────┘ └──────┘ └──────┘               │
├─────────────────────────────────────────────────────┤
│ 序号 | 文章名称 | 阅读 | 评论量 | 收藏量 | 转发量 | 操作  │
│  1   | ...     | ... | ...   | ...   | ...   |详细分析│
├─────────────────────────────────────────────────────┤
│                   分页                               │
└─────────────────────────────────────────────────────┘
```

#### 文章数据详情页（/dashboard/article/:id）
```
┌─────────────────────────────────────────────────────┐
│ [←返回] [日期筛选: ...]                              │
├─────────────────────────────────────────────────────┤
│ ┌────────┐ ┌──────┐ ┌──────┐ ┌──────┐              │
│ │平均阅读│ │跳出率│ │平均阅│ │推荐转│              │
│ │ 进度   │ │      │ │读时间│ │ 发量 │              │
│ └────────┘ └──────┘ └──────┘ └──────┘              │
│ ┌────────┐ ┌──────┐ ┌──────┐                       │
│ │评论量  │ │总阅读│ │粉丝阅│                       │
│ │        │ │  量  │ │ 读量 │                       │
│ └────────┘ └──────┘ └──────┘                       │
├─────────────────────────────────────────────────────┤
│ ┌─────────────────┐  ┌─────────────────┐            │
│ │  阅读来源分析    │  │  阅读完成度分析  │            │
│ │    (环形图)     │  │    (环形图)     │            │
│ └─────────────────┘  └─────────────────┘            │
└─────────────────────────────────────────────────────┘
```

### 6.9 测试验证

| # | 验证项 |
|---|--------|
| 1 | 两个页面 UI 与 Figma 设计稿一致 |
| 2 | 日期快捷按钮切换，数据正确刷新 |
| 3 | 4个统计卡片数据正确显示 |
| 4 | 图文列表表格数据 + 分页正常 |
| 5 | 点击"详细分析"跳转文章详情页 |
| 6 | 详情页8个统计卡片数据正确 |
| 7 | 阅读来源环形图渲染正确（5种颜色+占比） |
| 8 | 阅读完成度环形图渲染正确（3种颜色+占比） |
| 9 | 返回按钮回到列表页 |
| 10 | 加载中、空数据、错误状态处理 |

---

## 阶段7：粉丝管理-粉丝概况

### 7.1 目标
实现粉丝概况页面：标签页切换（概况/画像/列表）、日期筛选、4个统计卡片、阅读量趋势折线图、粉丝数据列表。

### 7.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供粉丝概况页 Figma 链接。

### 7.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/fan` | 粉丝概况页（默认） | 需登录 |
| `/fan/profile` | 粉丝画像页 | 需登录 |
| `/fan/list` | 粉丝列表页 | 需登录 |

### 7.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| FanLayout | `src/views/fan/index.vue` | 粉丝管理布局（标签页切换） |
| FanOverviewPage | `src/views/fan/overview.vue` | 粉丝概况主页面 |
| FanProfilePage | `src/views/fan/profile.vue` | 粉丝画像页面（阶段8） |
| FanListPage | `src/views/fan/list.vue` | 粉丝列表页面（阶段9） |
| FanTabNav | `src/components/FanTabNav.vue` | 粉丝管理标签导航（概况/画像/列表） |
| ReadingTrendChart | `src/components/ReadingTrendChart.vue` | 阅读量趋势折线图 |

### 7.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 粉丝概况概览 | GET | `/fan-stats/overview` | startDate/endDate，返回4个汇总指标 |
| 粉丝概况列表 | GET | `/fan-stats` | startDate/endDate/page/pageSize |
| 阅读量趋势 | GET | `/fan-stats/trend` | statDate，返回24小时阅读量趋势 |

### 7.6 类型定义

```typescript
// src/types/fan.ts
interface FanStatsOverview {
  totalFanCount: number      // 累计粉丝数量
  fanReadCount: number       // 粉丝累计阅读量
  fanRevenue: number         // 粉丝收益（元）
  unfollowCount: number      // 取消关注量
  newFollowCount: number     // 新增关注量
}

interface FanStatsItem {
  statDate: string
  totalFanCount: number
  fanReadCount: number
  fanRevenue: number
  unfollowCount: number
  newFollowCount: number
}

interface TrendPoint {
  hour: number
  readCount: number
}

interface TrendData {
  statDate: string
  trend: TrendPoint[]
}
```

### 7.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 7.1 | 获取 Figma 设计稿 | 向用户索要粉丝概况页 Figma 链接 |
| 7.2 | 创建 `src/types/fan.ts` | 粉丝相关类型定义 |
| 7.3 | 创建 `src/api/fan.ts` | `getFanOverview()`、`getFanStats()`、`getTrend()` |
| 7.4 | 实现 FanTabNav | 粉丝概况/粉丝画像/粉丝列表三个标签页导航 |
| 7.5 | 实现 FanLayout | 标签页导航 + `<router-view>` 子路由 |
| 7.6 | 实现 FanOverviewPage | DateFilterBar + 4个统计卡片 + 阅读量趋势图 + 数据表格 + 分页 |
| 7.7 | 实现 ReadingTrendChart | ECharts 折线图，横轴0-23小时，纵轴阅读量 |
| 7.8 | 路由配置 | 粉丝管理使用嵌套路由，默认展示概况 |

### 7.8 统计卡片样式（参考需求文档）

| 卡片 | 指标 | 建议颜色 |
|------|------|---------|
| 第1个 | 累计粉丝数量 | 绿色 |
| 第2个 | 粉丝累计阅读量 | 橙色 |
| 第3个 | 粉丝收益（元） | 紫色 |
| 第4个 | 取消关注量 | 蓝色 |

### 7.9 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 标签切换（概况/画像/列表）正常，路由跳转正确 |
| 3 | 日期筛选 + 快捷按钮正常 |
| 4 | 4个统计卡片数据正确 |
| 5 | 阅读量趋势折线图渲染正确（24小时数据） |
| 6 | 粉丝数据列表 + 分页正常 |
| 7 | 加载中、空数据、错误状态处理 |

---

## 阶段8：粉丝管理-粉丝画像

### 8.1 目标
实现粉丝画像页面：复用粉丝管理布局标签页，在概况页基础上增加画像分析图表区域。

### 8.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供粉丝画像页 Figma 链接。

### 8.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/fan/profile` | 粉丝画像页 | 需登录 |

### 8.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| GenderChart | `src/components/GenderChart.vue` | 性别分布-横向条形图 |
| AgeChart | `src/components/AgeChart.vue` | 年龄分布-柱状图 |
| DeviceChart | `src/components/DeviceChart.vue` | 终端分布-横向条形图 |
| RegionChart | `src/components/RegionChart.vue` | 地域分布-柱状图 |
| ActiveTimeChart | `src/components/ActiveTimeChart.vue` | 活跃时间分布-柱状图 |
| ContentPreferenceChart | `src/components/ContentPreferenceChart.vue` | 内容偏好-柱状图 |

### 8.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 粉丝画像数据 | GET | `/fan-stats/portrait` | statDate/dimension，可一次获取全部维度 |
| 画像维度列表 | GET | `/fan-stats/portrait/dimensions` | 获取所有可用维度元信息 |

### 8.6 类型定义

```typescript
interface PortraitDimensionMeta {
  key: string
  label: string
  chartType: string
  dimension: number
}

interface PortraitItem {
  key: string
  label: string
  value: number
  percentage: number
}

interface PortraitDimension {
  label: string
  chartType: string
  items: PortraitItem[]
}

interface PortraitData {
  statDate: string
  dimensions: Record<string, PortraitDimension>
}
```

### 8.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 8.1 | 获取 Figma 设计稿 | 向用户索要粉丝画像页 Figma 链接 |
| 8.2 | 实现 FanProfilePage | 日期筛选 + 6个分析图表区域 |
| 8.3 | 实现 GenderChart | 横向分段条形图：男性/女性占比 |
| 8.4 | 实现 AgeChart | 柱状图：各年龄段占比 |
| 8.5 | 实现 DeviceChart | 横向分段条形图：iOS/Android/PC占比 |
| 8.6 | 实现 RegionChart | 柱状图：各省市粉丝分布 |
| 8.7 | 实现 ActiveTimeChart | 柱状图：各时段活跃分布 |
| 8.8 | 实现 ContentPreferenceChart | 柱状图：内容偏好分布 |
| 8.9 | 响应式布局 | 大屏2列，小屏1列排列图表 |

### 8.8 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 日期筛选后所有图表同步刷新 |
| 3 | 6个图表渲染正确，数据标签显示 |
| 4 | 响应式布局正常 |

---

## 阶段9：粉丝管理-粉丝列表

### 9.1 目标
实现粉丝列表页面：粉丝卡片网格展示、发消息、拉黑/取消拉黑、加载更多。

### 9.2 Figma 链接
> ⚠️ **待补充**: 请在开发前提供粉丝列表页 Figma 链接。

### 9.3 页面与路由

| 路由 | 页面 | 权限 |
|------|------|:---:|
| `/fan/list` | 粉丝列表页 | 需登录 |

### 9.4 组件清单

| 组件 | 文件路径 | 说明 |
|------|---------|------|
| FanCard | `src/components/FanCard.vue` | 粉丝卡片（头像、用户名、发消息、拉黑） |
| SendMessageDialog | `src/components/SendMessageDialog.vue` | 发送私信弹窗 |

### 9.5 API 接口

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 粉丝列表 | GET | `/fans` | isBlocked/page/pageSize（默认18条/页） |
| 拉黑 | PATCH | `/fans/{id}/block` | 拉黑粉丝 |
| 取消拉黑 | PATCH | `/fans/{id}/unblock` | 取消拉黑 |
| 发送私信 | POST | `/fans/{id}/messages` | content，发送消息 |

### 9.6 类型定义

```typescript
interface Fan {
  id: number
  fanName: string
  fanAvatar: string | null
  isBlocked: number       // 0=正常 1=已拉黑
  followedAt: string
}

interface FanMessageRequest {
  content: string
}
```

### 9.7 实现任务

| # | 任务 | 说明 |
|---|------|------|
| 9.1 | 获取 Figma 设计稿 | 向用户索要粉丝列表页 Figma 链接 |
| 9.2 | 实现 FanCard | 头像、用户名、发消息按钮、拉黑/取消拉黑按钮 |
| 9.3 | 实现 SendMessageDialog | 输入消息内容，发送按钮 |
| 9.4 | 实现 FanListPage | 卡片网格布局（默认18条/页）、"点击查看更多"加载更多按钮 |
| 9.5 | 拉黑确认 | 拉黑前弹出确认框 |
| 9.6 | 加载更多 | 点击加载下一页，追加到当前列表 |

### 9.8 测试验证

| # | 验证项 |
|---|--------|
| 1 | 页面 UI 与 Figma 设计稿一致 |
| 2 | 粉丝卡片网格正常显示 |
| 3 | 发消息弹窗输入内容后发送成功 |
| 4 | 拉黑确认后粉丝状态更新 |
| 5 | 取消拉黑功能正常 |
| 6 | 加载更多追加数据，无更多时禁用按钮 |
| 7 | 空数据状态显示 |

---

## 附录

### A. 全局规范速查

#### API 请求规范
- BASE_URL: `http://localhost:8080`
- Token 在 `src/utils/request.ts` 请求拦截器中自动注入
- 响应拦截器统一处理 401 跳转登录

#### 状态管理
- `useUserStore`: 用户信息、Token、登录/登出方法
- `useAppStore`: 侧边栏折叠状态

#### 组件命名
- 页面组件：PascalCase，如 `LoginPage`、`ArticleCreatePage`
- 公共组件：PascalCase，放在 `src/components/`
- 页面私有组件：放在对应 views 子目录下

#### 样式规范
- 使用 SCSS 预处理
- 全局变量定义在 `src/styles/variables.scss`
- 组件内使用 `<style lang="scss" scoped>`
- Element Plus 主题变量覆盖在 variables.scss

### B. 项目启动命令

```bash
# 安装依赖
npm install

# 开发模式启动
npm run dev

# 构建生产版本
npm run build

# 类型检查
npm run type-check
```

### C. 待收集的 Figma 链接清单

| 阶段 | 页面 | Figma 链接 |
|------|------|-----------|
| 2 | 登录页 | ⏳ 待补充 |
| 3 | 素材管理页 | ⏳ 待补充 |
| 4 | 发布文章页 | ⏳ 待补充 |
| 5 | 内容列表页 | ⏳ 待补充 |
| 6 | 图文数据列表页 | ⏳ 待补充 |
| 6 | 文章数据详情页 | ⏳ 待补充 |
| 7 | 粉丝概况页 | ⏳ 待补充 |
| 8 | 粉丝画像页 | ⏳ 待补充 |
| 9 | 粉丝列表页 | ⏳ 待补充 |

### D. 参考资料

- 需求文档：`../docs/需求文档.md`
- API 接口文档：`../docs/api-documentation.md`
- 技术选型方案：`../docs/技术方案选型文档.md`
- 数据库表结构：`../database/TABLE_STRUCTURE.md`
- 产品原型图：`../docs/原型图/产品原型图.html`
- 全局规范：`../CLAUDE.md`
- 前端规范：`./CLAUDE.md`

---

> **下一步**: 等待用户确认本计划后，从阶段1开始执行。
>
> **更新日志**:
> - 2026-06-30 V1.0: 初始版本，规划9个阶段的任务分解
