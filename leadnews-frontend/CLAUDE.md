# 黑马头条 - 前端约束规则

> **本文件定位**：前端开发的约束规则（"宪法"），开发过程中 **不修改** 本文件。
> **执行计划**：存放在 `plan/frontend-plan.md`，进度更新只操作该文件。

---

## 技术栈

- Vue 3 + TypeScript + Vite
- Element Plus 2.x（UI组件库）
- Pinia 3（状态管理）
- Vue Router 4（路由）
- Axios（HTTP客户端 + 拦截器）
- Quill 2.0（@vueup/vue-quill，富文本编辑器）
- ECharts（图表库）
- dayjs（日期处理）
- Sass（CSS预处理）

## 项目目录结构（必须遵守）

```
src/
├── api/              # 接口请求（按模块分文件）
│   ├── auth.ts
│   ├── article.ts
│   ├── channel.ts
│   ├── material.ts
│   ├── stats.ts
│   └── fan.ts
├── assets/           # 静态资源（图片、字体等）
├── components/       # 全局公共组件
├── composables/      # 组合式函数（useXxx）
├── layouts/          # 布局组件（侧边栏 + 顶栏 + 内容区）
├── router/           # 路由配置
│   └── index.ts
├── stores/           # Pinia Store
│   ├── user.ts       # 用户状态（Token、用户信息）
│   └── app.ts        # 应用状态（侧边栏折叠等）
├── styles/           # 全局样式
│   ├── variables.scss
│   └── global.scss
├── types/            # TypeScript 类型定义
├── utils/            # 工具函数
│   ├── request.ts    # Axios 实例 + 拦截器
│   ├── auth.ts       # Token 存取（localStorage）
│   └── date.ts       # 日期格式化
├── views/            # 页面组件（按模块分目录）
│   ├── login/
│   ├── dashboard/
│   ├── article/
│   ├── material/
│   ├── fan/
│   └── stats/
├── App.vue
└── main.ts
```

## 关键架构决策（必须遵守）

### 请求流程
```
组件调用 api/xxx.ts → Axios实例（request.ts）→ 请求拦截器（注入JWT Token）→ 后端
                                                                    ↓
                                              响应拦截器（统一错误处理、401跳转登录）
```

### 路由守卫
```
未登录 → 访问任意页面 → 重定向到 /login
已登录 → 访问 /login → 重定向到 /dashboard
Token过期 → 401响应 → 清除本地Token → 跳转 /login
```

### 状态管理
- `useUserStore`：Token、用户信息、登录/登出方法
- `useAppStore`：侧边栏折叠状态、主题等

### API基础配置
- 基础URL：`http://localhost:8080`
- Token注入：`Authorization: Bearer <token>`
- 统一错误处理：ElMessage 提示

## UI设计规范（必须遵守）

### 布局
- 整体布局：左侧固定侧边栏（可折叠）+ 顶部导航栏 + 右侧内容区
- 侧边栏宽度：展开 210px / 折叠 64px
- 主色调：Element Plus 默认主题

### 页面规范
- 登录页：左侧品牌展示区 + 右侧登录表单
- 列表页：顶部筛选区 + 数据表格 + 分页
- 详情页：返回按钮 + 统计卡片 + 图表区域
- 表单页：居中卡片布局

## Figma 设计稿获取流程（必须遵守）

**每个页面开发前必须执行以下流程**：

1. **向用户索要 Figma 链接**：告诉用户当前要开发哪个页面，请用户提供对应的 Figma 链接
2. **获取设计数据**：用户提供链接后，使用 MCP 工具 `get_figma_data` 获取设计稿数据
3. **下载图片资源**：使用 MCP 工具 `download_figma_images` 下载需要的图片
4. **按设计稿开发**：根据获取到的设计数据编写 UI 代码

**严禁**：没有 Figma 链接就凭想象写 UI 代码。

**建议**：在 `plan/frontend-plan.md` 中提前标注每个阶段对应的 Figma 链接。

## 参考文档

- 执行计划：`plan/frontend-plan.md`（进度更新操作此文件）
- API接口文档：`../docs/api-documentation.md`
- 需求文档：`../docs/需求文档.md`
- 产品原型：`../docs/原型图/产品原型图.html`
- 技术方案：`../docs/技术方案选型文档.md`

## 开发流程（必须遵守）

```
1. 读取 plan/frontend-plan.md 获取当前执行计划和进度
2. 确认当前阶段任务
3. 向用户索要当前阶段对应页面的 Figma 链接
4. 获取 Figma 设计数据，按设计稿开发
5. 测试通过后，向用户展示成果
6. 等待用户确认（必须等待，不能自行继续）
7. 用户确认后，更新 plan/frontend-plan.md 中的进度状态
8. 进入下一阶段
```

## 会话恢复流程

当会话丢失后：
```
1. 读取本文件（leadnews-frontend/CLAUDE.md）→ 了解前端约束规则
2. 读取根目录 CLAUDE.md → 了解全局规范
3. 读取 plan/frontend-plan.md → 恢复当前开发进度
4. 从上次未完成的阶段继续执行
```
