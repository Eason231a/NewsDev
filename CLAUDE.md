# 黑马头条自媒体人管理系统 - 全局规范

> **本文件定位**：全局约束规则（"宪法"），不可变的项目级规范。
> **执行计划**：存放在各端 `plan/` 目录下，是可变的工作文档，随开发进度更新。
> **严禁修改本文件来跟踪进度**，进度更新只操作 `plan/` 目录下的计划文件。

---

## 项目概述

黑马头条是一款面向自媒体创作者的内容管理与数据分析平台。

**核心功能模块**：
- 登录认证系统
- 图文数据（数据概览 + 文章详情）
- 发布文章（富文本编辑 + 封面管理）
- 内容列表（文章管理 + 状态流转）
- 素材管理（图片上传 + 收藏）
- 粉丝管理（粉丝列表 + 画像 + 私信）

## 项目结构

```
E:\AI\leadnews\
├── CLAUDE.md              # 全局约束规则（本文件，不要修改）
├── database/              # 数据库脚本与文档
│   ├── heima_news.sql    # 建表脚本（15张表）
│   └── TABLE_STRUCTURE.md # 表结构文档
├── docs/                  # 项目文档
│   ├── 需求文档.md        # 产品需求文档
│   ├── api-documentation.md # API接口文档
│   ├── 技术方案选型文档.md  # 技术选型方案
│   └── 原型图/           # 产品原型
├── leadnews-backend/      # 后端项目（Spring Boot 3.2）
│   ├── CLAUDE.md          # 后端约束规则（不要修改）
│   └── plan/              # 后端执行计划（可修改，跟踪进度）
│       └── backend-plan.md
└── leadnews-frontend/     # 前端项目（Vue 3 + Element Plus）
    ├── CLAUDE.md          # 前端约束规则（不要修改）
    └── plan/              # 前端执行计划（可修改，跟踪进度）
        └── frontend-plan.md
```

## 技术栈

### 后端
- Java 17 + Spring Boot 3.2
- MyBatis-Plus 3.5（ORM + 分页）
- MySQL 8.0
- JWT（无状态认证）
- 阿里云 OSS（图片存储）

### 前端
- Vue 3 + TypeScript + Vite
- Element Plus 2.x
- Pinia 3（状态管理）
- Vue Router 4
- Axios（HTTP客户端）
- Quill 2.0（富文本编辑器）
- ECharts（图表）

---

## 核心开发原则（必须遵守）

### 1. 计划与约束分离
- **CLAUDE.md（本文件 + 各端子目录的 CLAUDE.md）**：只放约束规则，开发过程中 **不修改**
- **plan/ 目录下的计划文件**：执行计划与进度跟踪，开发过程中 **必须更新**
- 会话恢复时，先读 CLAUDE.md 了解规则，再读 `plan/` 下的计划文件恢复进度

### 2. 阶段确认机制
- 严格按 `plan/` 下的执行计划顺序执行，不随意跳步
- 每完成一个阶段，必须自行测试通过
- 测试通过后，**必须等待用户确认**，用户明确允许后才能继续下一阶段
- 用户确认后，更新 `plan/` 目录下的计划文件（标记完成、记录日志）

### 3. 文档引用优先级
开发时必须参考以下文档（按优先级）：
1. `docs/需求文档.md` - 功能需求
2. `docs/api-documentation.md` - API接口规范
3. `docs/技术方案选型文档.md` - 技术选型决策
4. `database/TABLE_STRUCTURE.md` - 数据库表结构
5. `docs/原型图/产品原型图.html` - 产品原型

### 4. Figma 设计稿获取流程（前端开发必须遵守）
- 前端开发每个页面之前，**必须先向用户索要该页面对应的 Figma 链接**
- 用户提供链接后，使用 MCP 工具 `get_figma_data` 获取设计数据
- 使用 MCP 工具 `download_figma_images` 下载需要的图片资源
- **没有 Figma 链接不要凭想象写 UI 代码**
- 建议按阶段提前收集链接，在计划文件中标注每个阶段对应的 Figma 链接

### 5. 不要假设
- 不确定的需求必须查阅文档或询问用户
- 不确定的接口参数必须查阅 API 文档
- 不确定的表结构必须查阅 TABLE_STRUCTURE.md

---

## API 规范

- 基础URL：`http://localhost:8080`
- 认证方式：JWT Bearer Token（`Authorization: Bearer <token>`）
- 统一响应格式：`{ code, message, data }`
- 分页格式：`{ list, total, page, pageSize }`
- 错误码：遵循HTTP语义（400/401/403/404/413/422/500）

## 数据库规范

- 表名/字段名：小写 + 下划线命名
- 枚举值：使用TINYINT（如状态：0-5）
- 软删除：articles和materials使用deleted_at字段
- 时间字段：统一使用DATETIME类型
- 外键：逻辑外键，不使用物理外键约束

## 安全规范

- 密码：BCrypt加密存储
- Token：HMAC-SHA256签名，24小时过期
- 越权防护：所有查询必须带userId条件
- SQL注入：使用MyBatis `#{}` 参数化
- 文件上传：扩展名白名单 + 2MB大小限制

---

## 会话恢复流程

当 token 满了、新开终端、或执行了 /clear 后：

```
1. 读取当前工作目录的 CLAUDE.md → 了解约束规则
2. 读取根目录 CLAUDE.md → 了解全局规范
3. 读取 plan/ 下的计划文件 → 恢复当前进度
4. 从上次未完成的阶段继续执行
```
