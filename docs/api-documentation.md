# 黑马头条自媒体人管理系统 — API 接口文档

> 自动生成于 2026-07-10 | 基于 schema.sql + heima_news.sql + TABLE_STRUCTURE.md + 需求文档.md + 产品原型图.html
> 可导入 Apifox/Apipost/Postman 的 JSON 文件: [openapi.json](./openapi.json)

---

## 概述

| 项目 | 说明 |
|------|------|
| 基础 URL | `http://localhost:8080` |
| 认证方式 | JWT Bearer Token (`Authorization: Bearer <token>`) |
| 请求格式 | `application/json` |
| 响应格式 | `application/json` |
| 字符编码 | UTF-8 |

### 通用响应结构

```json
{
  "code": 200,
  "message": "success",
  "data": { }
}
```

### 业务错误码

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未认证 / Token 失效 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 409 | 资源冲突（如唯一键重复） |
| 413 | 上传文件过大 |
| 422 | 业务逻辑错误（如状态不允许） |
| 500 | 服务器内部错误 |

### 分页说明

分页接口统一使用 `page`（页码, 默认1）和 `pageSize`（每页条数, 默认10）参数。
响应中包含 `total`（总记录数）、`page`、`pageSize` 字段。

### 枚举值约定

本项目中所有枚举字段在数据库中均以 **TINYINT 数值** 存储。API 请求和响应中均使用数值，**不使用字符串**。

---

## 目录

1. [认证模块](#1-认证模块)
2. [频道管理](#2-频道管理)
3. [文章管理](#3-文章管理)
4. [素材管理](#4-素材管理)
5. [文章数据统计](#5-文章数据统计)
6. [粉丝管理](#6-粉丝管理)
7. [粉丝数据统计](#7-粉丝数据统计)
8. [审核日志](#8-审核日志)

---

## 1. 认证模块

### 1.1 用户登录

**接口描述**: 使用用户名和密码登录，返回 JWT Token。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/auth/login` |
| 认证 | 否 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| username | Body | string | ✓ | 登录用户名 |
| password | Body | string | ✓ | 登录密码（明文，服务端 BCrypt 校验） |
| agreeTerms | Body | boolean | ✓ | 是否同意用户协议和隐私政策 |

**请求示例**:

```json
{
  "username": "zhangsan",
  "password": "123456",
  "agreeTerms": true
}
```

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "expiresAt": "2026-07-11T10:30:00Z",
    "user": {
      "id": 1,
      "username": "zhangsan",
      "avatar": "https://cdn.example.com/avatars/1.jpg",
      "status": 1,
      "lastLoginAt": "2026-07-10T10:30:00Z"
    }
  }
}
```

---

### 1.2 用户注册

**接口描述**: 注册新的自媒体创作者账号。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/auth/register` |
| 认证 | 否 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| username | Body | string | ✓ | 用户名(唯一, 最长64字符) |
| password | Body | string | ✓ | 登录密码 |
| agreeTerms | Body | boolean | ✓ | 是否同意用户协议和隐私政策 |

**请求示例**:

```json
{
  "username": "zhangsan",
  "password": "123456",
  "agreeTerms": true
}
```

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "zhangsan",
    "avatar": null,
    "status": 1,
    "createdAt": "2026-07-10T10:30:00Z"
  }
}
```

**错误码**:

| 错误码 | 触发条件 |
|--------|---------|
| 409 | 用户名已存在 |

---

### 1.3 刷新 Token

**接口描述**: 使用当前有效的 Token 换取新 Token。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/auth/refresh` |
| 认证 | 是 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "expiresAt": "2026-07-11T10:30:00Z"
  }
}
```

---

### 1.4 获取当前用户信息

**接口描述**: 根据 JWT Token 获取当前登录用户的信息。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/auth/me` |
| 认证 | 是 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "zhangsan",
    "avatar": "https://cdn.example.com/avatars/1.jpg",
    "status": 1,
    "lastLoginAt": "2026-07-10T10:30:00Z",
    "createdAt": "2026-06-01T08:00:00Z"
  }
}
```

---

## 2. 频道管理

### 2.1 频道列表

**接口描述**: 获取所有启用频道的列表（按排序权重升序）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/channels` |
| 认证 | 否 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| isEnabled | Query | integer | 否 | 筛选条件: `1`=仅启用 `0`=仅禁用, 不传则返回全部 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "name": "科技",
        "description": "科技领域资讯与深度分析",
        "sortOrder": 1,
        "isEnabled": 1,
        "createdAt": "2026-06-17T00:00:00Z"
      },
      {
        "id": 2,
        "name": "娱乐",
        "description": "娱乐新闻与明星动态",
        "sortOrder": 2,
        "isEnabled": 1,
        "createdAt": "2026-06-17T00:00:00Z"
      }
    ]
  }
}
```

---

### 2.2 频道详情

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/channels/{id}` |
| 认证 | 否 |

---

### 2.3 创建频道

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/channels` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| name | Body | string | ✓ | 频道名称(唯一) |
| description | Body | string | 否 | 频道描述 |
| sortOrder | Body | integer | 否 | 排序权重(越小越靠前, 默认0) |

---

### 2.4 更新频道

| 项目 | 内容 |
|------|------|
| 方法 | `PUT` |
| 路径 | `/channels/{id}` |
| 认证 | 是 |

---

### 2.5 设置频道启用状态

**接口描述**: 启用或禁用一个频道。

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/channels/{id}/status` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| isEnabled | Body | integer | ✓ | `1`=启用 `0`=禁用 |

---

## 3. 文章管理

### 3.1 枚举值说明

#### 文章状态 (status)

| 值 | 说明 |
|----|------|
| 0 | 草稿 |
| 1 | 待审核 |
| 2 | 审核通过 |
| 3 | 审核失败 |
| 4 | 已上架 |
| 5 | 已下架 |

#### 封面类型 (coverType)

| 值 | 说明 |
|----|------|
| 0 | 单图 |
| 1 | 三图 |
| 2 | 无图 |

---

### 3.2 获取枚举值

**接口描述**: 获取文章状态/封面类型的枚举值列表。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/articles/enums/{field}` |
| 认证 | 是 |

**路径参数**: `field` 可选值: `status` / `coverType`

**响应示例** (`/articles/enums/status`):

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "field": "status",
    "values": [
      { "value": 0, "label": "草稿", "color": "#909399" },
      { "value": 1, "label": "待审核", "color": "#e6a23c" },
      { "value": 2, "label": "审核通过", "color": "#67c23a" },
      { "value": 3, "label": "审核失败", "color": "#f56c6c" },
      { "value": 4, "label": "已上架", "color": "#409eff" },
      { "value": 5, "label": "已下架", "color": "#909399" }
    ]
  }
}
```

---

### 3.3 文章列表（内容列表）

**接口描述**: 分页查询当前用户的文章列表，支持按状态、频道、关键字、日期范围筛选。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/articles` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认10 |
| status | Query | integer | 否 | 文章状态: 0~5 |
| channelId | Query | integer | 否 | 频道ID |
| keyword | Query | string | 否 | 标题模糊搜索 |
| startDate | Query | string | 否 | 创建时间起始 (YYYY-MM-DD) |
| endDate | Query | string | 否 | 创建时间截止 (YYYY-MM-DD) |
| sortBy | Query | string | 否 | 排序字段, 默认 `createdAt` |
| order | Query | string | 否 | 排序方向: `asc` / `desc`, 默认 `desc` |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 3,
        "title": "AI技术最新发展",
        "channelId": 1,
        "channelName": "科技",
        "tag": "AI",
        "coverType": 0,
        "status": 4,
        "reviewComment": null,
        "scheduledAt": null,
        "publishedAt": "2026-06-23T19:24:52Z",
        "createdAt": "2026-06-23T19:24:41Z",
        "updatedAt": "2026-06-23T19:24:52Z",
        "coverImages": [
          { "id": 1, "materialId": 2, "url": "https://cdn.example.com/materials/2.jpg", "sortOrder": 0 }
        ],
        "stats": {
          "readCount": 1250,
          "likeCount": 89,
          "commentCount": 32,
          "favoriteCount": 45,
          "shareCount": 18
        }
      }
    ],
    "total": 25,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### 3.4 文章详情

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/articles/{id}` |
| 认证 | 是 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 3,
    "userId": 1,
    "channelId": 1,
    "channelName": "科技",
    "title": "AI技术最新发展",
    "content": "<p>AI技术正在改变世界...</p>",
    "tag": "AI",
    "coverType": 0,
    "status": 4,
    "reviewComment": null,
    "scheduledAt": null,
    "publishedAt": "2026-06-23T19:24:52Z",
    "deletedAt": null,
    "createdAt": "2026-06-23T19:24:41Z",
    "updatedAt": "2026-06-23T19:24:52Z",
    "coverImages": [
      { "id": 1, "materialId": 2, "url": "https://cdn.example.com/materials/2.jpg", "sortOrder": 0 }
    ]
  }
}
```

---

### 3.5 创建文章（保存草稿 / 提交审核）

**接口描述**: 创建文章。`status` 传 `0` 为保存草稿，传 `1` 为直接提交审核。定时发布时间可选填。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/articles` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| channelId | Body | integer | 否 | 所属频道ID |
| title | Body | string | ✓ | 文章标题(最长255字符) |
| content | Body | string | 否 | 文章正文(富文本JSON字符串) |
| tag | Body | string | 否 | 自定义标签(最长20字符) |
| coverType | Body | integer | ✓ | 封面类型: `0`单图 `1`三图 `2`无图 |
| status | Body | integer | 否 | 文章状态: `0`草稿(默认) / `1`待审核 |
| scheduledAt | Body | string | 否 | 定时发布时间(ISO 8601) |
| coverMaterialIds | Body | array[integer] | 否 | 封面素材ID数组(单图1个, 三图3个) |

**请求示例**:

```json
{
  "channelId": 1,
  "title": "AI技术最新发展",
  "content": "<p>AI技术正在改变世界...</p>",
  "tag": "AI",
  "coverType": 0,
  "status": 0,
  "coverMaterialIds": [2]
}
```

---

### 3.6 更新文章

| 项目 | 内容 |
|------|------|
| 方法 | `PUT` |
| 路径 | `/articles/{id}` |
| 认证 | 是 |

**限制**: 仅草稿(0)和审核失败(3)状态可编辑。

---

### 3.7 变更文章状态

**接口描述**: 执行文章状态流转操作（提交审核/上架/下架等）。

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/articles/{id}/status` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| status | Body | integer | ✓ | 目标状态: `0`草稿 `1`待审核 `2`审核通过 `3`审核失败 `4`已上架 `5`已下架 |
| comment | Body | string | 否 | 审核意见(驳回时填写, 最长500字符) |

**状态流转规则**:

| 当前状态 | 允许目标状态 |
|---------|------------|
| 0 (草稿) | 1 (提交审核) |
| 1 (待审核) | 2 (审核通过), 3 (审核失败) |
| 2 (审核通过) | 4 (上架) |
| 3 (审核失败) | 0 (重新编辑) |
| 4 (已上架) | 5 (下架) |
| 5 (已下架) | 4 (重新上架) |

---

### 3.8 删除文章（软删除）

| 项目 | 内容 |
|------|------|
| 方法 | `DELETE` |
| 路径 | `/articles/{id}` |
| 认证 | 是 |

**说明**: 仅草稿(0)和审核失败(3)状态可删除。软删除后 `deletedAt` 记录时间，列表查询自动过滤。

---

### 3.9 恢复文章

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/articles/{id}/restore` |
| 认证 | 是 |

---

### 3.10 获取文章封面

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/articles/{id}/covers` |
| 认证 | 是 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "coverType": 0,
    "images": [
      { "id": 1, "materialId": 2, "url": "https://cdn.example.com/materials/2.jpg", "sortOrder": 0 }
    ]
  }
}
```

---

### 3.11 设置文章封面

**接口描述**: 设置或更新文章封面图片（替换全部）。

| 项目 | 内容 |
|------|------|
| 方法 | `PUT` |
| 路径 | `/articles/{id}/covers` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| coverType | Body | integer | ✓ | 封面类型: `0`单图 `1`三图 `2`无图 |
| materialIds | Body | array[integer] | 否 | 素材ID数组(coverType=0时1个, =1时3个, =2时空数组) |

---

## 4. 素材管理

### 4.1 素材列表

**接口描述**: 分页查询当前用户的素材列表，支持全部/收藏切换。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/materials` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认10 |
| isFavorite | Query | integer | 否 | `1`=仅收藏 `0`=全部(默认) |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "filename": "cover.jpg",
        "filePath": "https://cdn.example.com/materials/1.jpg",
        "fileSize": 102400,
        "mimeType": "image/jpeg",
        "isFavorite": 1,
        "createdAt": "2026-06-23T19:24:00Z"
      }
    ],
    "total": 15,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### 4.2 素材详情

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/materials/{id}` |
| 认证 | 是 |

---

### 4.3 上传素材

**接口描述**: 上传图片素材。限制 jpg/png，单文件 ≤ 2MB。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/materials/upload` |
| 认证 | 是 |
| 请求格式 | `multipart/form-data` |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| file | Body | file | ✓ | 图片文件(jpg/png, ≤2MB) |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "filename": "cover.jpg",
    "filePath": "https://cdn.example.com/materials/1.jpg",
    "fileSize": 102400,
    "mimeType": "image/jpeg",
    "isFavorite": 0,
    "createdAt": "2026-07-10T10:30:00Z"
  }
}
```

**错误码**:

| 错误码 | 触发条件 |
|--------|---------|
| 413 | 文件超过2MB |
| 422 | 文件类型不是 jpg/png |

---

### 4.4 删除素材（软删除）

| 项目 | 内容 |
|------|------|
| 方法 | `DELETE` |
| 路径 | `/materials/{id}` |
| 认证 | 是 |

**说明**: 已被设为文章封面的素材不允许删除（数据库 RESTRICT 约束），需先解除文章关联。

---

### 4.5 恢复素材

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/materials/{id}/restore` |
| 认证 | 是 |

---

### 4.6 切换收藏状态

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/materials/{id}/favorite` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| isFavorite | Body | integer | ✓ | `1`=收藏 `0`=取消收藏 |

---

## 5. 文章数据统计

### 5.1 统计概览卡片

**接口描述**: 获取当前用户的图文数据概览（4项统计卡片：图文发布量、点赞数量、收藏数量、转发数量）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/article-stats/overview` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| startDate | Query | string | 否 | 起始日期 (YYYY-MM-DD) |
| endDate | Query | string | 否 | 截止日期 (YYYY-MM-DD) |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "totalPublishCount": 125,
    "totalLikeCount": 1890,
    "totalFavoriteCount": 950,
    "totalShareCount": 620
  }
}
```

---

### 5.2 文章数据列表

**接口描述**: 分页查询当前用户所有文章的统计数据。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/article-stats` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认10 |
| startDate | Query | string | 否 | 起始日期 (YYYY-MM-DD) |
| endDate | Query | string | 否 | 截止日期 (YYYY-MM-DD) |
| sortBy | Query | string | 否 | 排序字段, 默认 `readCount` |
| order | Query | string | 否 | `asc` / `desc`, 默认 `desc` |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "articleId": 3,
        "articleTitle": "AI技术最新发展",
        "statDate": "2026-06-23",
        "readCount": 1250,
        "likeCount": 89,
        "commentCount": 32,
        "favoriteCount": 45,
        "shareCount": 18,
        "fanReadCount": 320
      }
    ],
    "total": 25,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### 5.3 文章详情统计

**接口描述**: 获取单篇文章的详细统计数据（含8项指标卡片：平均阅读进度、跳出率、平均阅读时间、推荐转发量、评论量、总阅读量、粉丝阅读量、点赞量）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/article-stats/{articleId}` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| startDate | Query | string | 否 | 起始日期 |
| endDate | Query | string | 否 | 截止日期 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "articleId": 3,
    "articleTitle": "AI技术最新发展",
    "summary": {
      "totalReadCount": 1250,
      "totalLikeCount": 89,
      "totalCommentCount": 32,
      "totalFavoriteCount": 45,
      "totalShareCount": 18,
      "avgReadProgress": 61.00,
      "bounceRate": 13.20,
      "avgReadSeconds": 85,
      "totalRecommendShares": 120,
      "totalFanReadCount": 320
    },
    "daily": [
      {
        "statDate": "2026-06-17",
        "readCount": 150,
        "likeCount": 10,
        "commentCount": 5,
        "favoriteCount": 6,
        "shareCount": 2
      }
    ]
  }
}
```

---

### 5.4 阅读来源分析

**接口描述**: 获取文章的阅读来源分布（环形图数据）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/article-stats/{articleId}/read-sources` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| statDate | Query | string | 否 | 统计日期, 默认最新一天 |

#### 来源类型枚举

| 值 | 说明 | 颜色 |
|----|------|------|
| 0 | 推荐 | #1890ff |
| 1 | 频道 | #52c41a |
| 2 | 相关阅读 | #722ed1 |
| 3 | 应用外 | #faad14 |
| 4 | 其他 | #ff4d4f |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "articleId": 3,
    "statDate": "2026-06-23",
    "sources": [
      { "sourceType": 0, "sourceLabel": "推荐", "readCount": 111, "percentage": 40.00, "color": "#1890ff" },
      { "sourceType": 1, "sourceLabel": "频道", "readCount": 63, "percentage": 23.00, "color": "#52c41a" },
      { "sourceType": 2, "sourceLabel": "相关阅读", "readCount": 30, "percentage": 11.00, "color": "#722ed1" },
      { "sourceType": 3, "sourceLabel": "应用外", "readCount": 22, "percentage": 8.00, "color": "#faad14" },
      { "sourceType": 4, "sourceLabel": "其他", "readCount": 22, "percentage": 8.00, "color": "#ff4d4f" }
    ]
  }
}
```

---

### 5.5 阅读完成度分析

**接口描述**: 获取文章的阅读完成度分布（环形图数据）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/article-stats/{articleId}/read-completion` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| statDate | Query | string | 否 | 统计日期, 默认最新一天 |

#### 完成度区间枚举

| 值 | 说明 | 颜色 |
|----|------|------|
| 0 | 低于20% | #1890ff |
| 1 | 20%-80% | #52c41a |
| 2 | 高于80% | #722ed1 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "articleId": 3,
    "statDate": "2026-06-23",
    "completions": [
      { "completionRange": 0, "rangeLabel": "低于20%", "userCount": 27, "percentage": 25.00, "color": "#1890ff" },
      { "completionRange": 1, "rangeLabel": "20%-80%", "userCount": 35, "percentage": 30.00, "color": "#52c41a" },
      { "completionRange": 2, "rangeLabel": "高于80%", "userCount": 56, "percentage": 45.00, "color": "#722ed1" }
    ]
  }
}
```

---

## 6. 粉丝管理

### 6.1 粉丝列表

**接口描述**: 分页查询当前作者的粉丝列表，支持拉黑过滤。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fans` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认10 |
| isBlocked | Query | integer | 否 | `1`=仅拉黑 `0`=仅正常(默认), 不传全部 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "fanName": "用户A",
        "fanAvatar": "https://cdn.example.com/avatars/fan1.jpg",
        "isBlocked": 0,
        "followedAt": "2026-06-15T10:30:00Z"
      }
    ],
    "total": 120,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### 6.2 拉黑粉丝

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/fans/{id}/block` |
| 认证 | 是 |

---

### 6.3 取消拉黑

| 项目 | 内容 |
|------|------|
| 方法 | `PATCH` |
| 路径 | `/fans/{id}/unblock` |
| 认证 | 是 |

---

### 6.4 发送私信

**接口描述**: 向粉丝发送私信消息。

| 项目 | 内容 |
|------|------|
| 方法 | `POST` |
| 路径 | `/fan-messages` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| fanId | Body | integer | ✓ | 接收者粉丝ID |
| content | Body | string | ✓ | 消息内容 |

**请求示例**:

```json
{
  "fanId": 1,
  "content": "感谢关注！"
}
```

---

### 6.5 私信记录

**接口描述**: 查询与某个粉丝的私信对话历史。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-messages` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| fanId | Query | integer | ✓ | 粉丝ID |
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认20 |

---

## 7. 粉丝数据统计

### 7.1 粉丝概况概览

**接口描述**: 获取粉丝概况页4项统计卡片数据。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-stats/overview` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| startDate | Query | string | 否 | 起始日期 |
| endDate | Query | string | 否 | 截止日期 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "totalFanCount": 12580,
    "totalFanReadCount": 95600,
    "totalFanRevenue": 12580.50,
    "totalUnfollowCount": 320
  }
}
```

---

### 7.2 粉丝数据列表

**接口描述**: 分页查询每日粉丝统计数据。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-stats` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认10 |
| startDate | Query | string | 否 | 起始日期 |
| endDate | Query | string | 否 | 截止日期 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "statDate": "2026-06-23",
        "fanCount": 520,
        "fanReadCount": 3200,
        "fanRevenue": 456.80,
        "unfollowCount": 12,
        "newFollowCount": 35
      }
    ],
    "total": 30,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### 7.3 阅读量小时趋势

**接口描述**: 获取某一天的粉丝阅读量24小时趋势数据（折线图）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-stats/trend` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| statDate | Query | string | 是 | 统计日期 (YYYY-MM-DD) |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "statDate": "2026-06-17",
    "hours": [
      { "hour": 0, "readCount": 110 },
      { "hour": 1, "readCount": 95 },
      { "hour": 2, "readCount": 100 }
    ]
  }
}
```

---

### 7.4 粉丝画像

**接口描述**: 获取粉丝画像数据，可按维度筛选。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-stats/portrait` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| dimension | Query | integer | 否 | 画像维度(0~5), 不传返回全部维度 |
| statDate | Query | string | 否 | 统计日期, 默认最新一天 |

#### 画像维度枚举

| 值 | 维度 | 图表类型 | 可选值示例 |
|----|------|:---:|------|
| 0 | 性别分布 | 环形图 | `male`(男) / `female`(女) |
| 1 | 年龄分布 | 柱状图 | `0-17` / `18-23` / `24-30` / `31-40` / `41-50` / `50+` |
| 2 | 地域分布 | 地图 | `广东` / `北京` / `上海` ... |
| 3 | 终端分布 | 环形图 | `iOS` / `Android` / `PC` |
| 4 | 活跃时间 | 柱状图 | `0-2时` / `2-4时` ... `22-24时` |
| 5 | 内容偏好 | 柱状图 | `大数据` / `人工智能` / `游戏` ... |

**响应示例** (按单个维度):

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "statDate": "2026-06-23",
    "dimension": 0,
    "dimensionLabel": "性别分布",
    "chartType": "doughnut",
    "items": [
      { "dimensionKey": "male", "dimensionKeyLabel": "男", "dimensionValue": 8500, "percentage": 68.00 },
      { "dimensionKey": "female", "dimensionKeyLabel": "女", "dimensionValue": 4080, "percentage": 32.00 }
    ]
  }
}
```

**响应示例** (全部维度):

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "statDate": "2026-06-23",
    "portraits": [
      {
        "dimension": 0,
        "dimensionLabel": "性别分布",
        "chartType": "doughnut",
        "items": [
          { "dimensionKey": "male", "dimensionKeyLabel": "男", "dimensionValue": 8500, "percentage": 68.00 },
          { "dimensionKey": "female", "dimensionKeyLabel": "女", "dimensionValue": 4080, "percentage": 32.00 }
        ]
      },
      {
        "dimension": 1,
        "dimensionLabel": "年龄分布",
        "chartType": "bar",
        "items": [
          { "dimensionKey": "0-17", "dimensionKeyLabel": "0-17岁", "dimensionValue": 500, "percentage": 4.00 },
          { "dimensionKey": "18-23", "dimensionKeyLabel": "18-23岁", "dimensionValue": 3200, "percentage": 25.00 }
        ]
      }
    ]
  }
}
```

---

### 7.5 画像维度列表

**接口描述**: 获取所有可用的粉丝画像维度列表。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/fan-stats/portrait/dimensions` |
| 认证 | 是 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "dimensions": [
      { "value": 0, "label": "性别分布", "chartType": "doughnut" },
      { "value": 1, "label": "年龄分布", "chartType": "bar" },
      { "value": 2, "label": "地域分布", "chartType": "map" },
      { "value": 3, "label": "终端分布", "chartType": "doughnut" },
      { "value": 4, "label": "活跃时间", "chartType": "bar" },
      { "value": 5, "label": "内容偏好", "chartType": "bar" }
    ]
  }
}
```

---

## 8. 审核日志

### 8.1 审核记录列表

**接口描述**: 查询文章的审核历史记录（只读）。

| 项目 | 内容 |
|------|------|
| 方法 | `GET` |
| 路径 | `/review-logs` |
| 认证 | 是 |

**请求参数**:

| 参数名 | 位置 | 类型 | 必填 | 说明 |
|--------|------|------|:---:|------|
| articleId | Query | integer | 否 | 按文章ID筛选 |
| page | Query | integer | 否 | 页码, 默认1 |
| pageSize | Query | integer | 否 | 每页条数, 默认20 |
| startDate | Query | string | 否 | 起始日期 |
| endDate | Query | string | 否 | 截止日期 |

**响应示例**:

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "articleId": 3,
        "reviewerId": null,
        "fromStatus": 1,
        "toStatus": 2,
        "comment": null,
        "reviewedAt": "2026-06-23T19:24:52Z"
      },
      {
        "id": 7,
        "articleId": 3,
        "reviewerId": null,
        "fromStatus": 2,
        "toStatus": 3,
        "comment": "测试审核通过",
        "reviewedAt": "2026-06-23T20:50:45Z"
      }
    ],
    "total": 2,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 附录 A: 枚举值速查表

| 表 | 字段 | 值 | 说明 |
|----|------|----|------|
| users | status | 0 | 禁用 |
| users | status | 1 | 正常 |
| channels | isEnabled | 0 | 禁用 |
| channels | isEnabled | 1 | 启用 |
| articles | status | 0 | 草稿 |
| articles | status | 1 | 待审核 |
| articles | status | 2 | 审核通过 |
| articles | status | 3 | 审核失败 |
| articles | status | 4 | 已上架 |
| articles | status | 5 | 已下架 |
| articles | coverType | 0 | 单图 |
| articles | coverType | 1 | 三图 |
| articles | coverType | 2 | 无图 |
| materials | isFavorite | 0 | 未收藏 |
| materials | isFavorite | 1 | 已收藏 |
| article_read_sources | sourceType | 0 | 推荐 |
| article_read_sources | sourceType | 1 | 频道 |
| article_read_sources | sourceType | 2 | 相关阅读 |
| article_read_sources | sourceType | 3 | 应用外 |
| article_read_sources | sourceType | 4 | 其他 |
| article_read_completion | completionRange | 0 | 低于20% |
| article_read_completion | completionRange | 1 | 20%-80% |
| article_read_completion | completionRange | 2 | 高于80% |
| fans | isBlocked | 0 | 正常 |
| fans | isBlocked | 1 | 已拉黑 |
| fan_portrait_data | dimension | 0 | 性别分布 |
| fan_portrait_data | dimension | 1 | 年龄分布 |
| fan_portrait_data | dimension | 2 | 地域分布 |
| fan_portrait_data | dimension | 3 | 终端分布 |
| fan_portrait_data | dimension | 4 | 活跃时间 |
| fan_portrait_data | dimension | 5 | 内容偏好 |
| user_agreement_logs | agreementType | 0 | 用户协议 |
| user_agreement_logs | agreementType | 1 | 隐私政策 |

---

## 附录 B: 接口清单

| # | 方法 | 路径 | 说明 | 认证 |
|---|------|------|------|:---:|
| 1 | POST | `/auth/login` | 用户登录 | ✗ |
| 2 | POST | `/auth/register` | 用户注册 | ✗ |
| 3 | POST | `/auth/refresh` | 刷新Token | ✓ |
| 4 | GET | `/auth/me` | 当前用户信息 | ✓ |
| 5 | GET | `/channels` | 频道列表 | ✗ |
| 6 | GET | `/channels/{id}` | 频道详情 | ✗ |
| 7 | POST | `/channels` | 创建频道 | ✓ |
| 8 | PUT | `/channels/{id}` | 更新频道 | ✓ |
| 9 | PATCH | `/channels/{id}/status` | 设置启用状态 | ✓ |
| 10 | GET | `/articles` | 文章列表 | ✓ |
| 11 | GET | `/articles/{id}` | 文章详情 | ✓ |
| 12 | POST | `/articles` | 创建文章 | ✓ |
| 13 | PUT | `/articles/{id}` | 更新文章 | ✓ |
| 14 | PATCH | `/articles/{id}/status` | 变更状态 | ✓ |
| 15 | DELETE | `/articles/{id}` | 删除文章(软删除) | ✓ |
| 16 | PATCH | `/articles/{id}/restore` | 恢复文章 | ✓ |
| 17 | GET | `/articles/enums/{field}` | 获取枚举值 | ✓ |
| 18 | GET | `/articles/{id}/covers` | 获取封面 | ✓ |
| 19 | PUT | `/articles/{id}/covers` | 设置封面 | ✓ |
| 20 | GET | `/materials` | 素材列表 | ✓ |
| 21 | GET | `/materials/{id}` | 素材详情 | ✓ |
| 22 | POST | `/materials/upload` | 上传素材 | ✓ |
| 23 | DELETE | `/materials/{id}` | 删除素材 | ✓ |
| 24 | PATCH | `/materials/{id}/restore` | 恢复素材 | ✓ |
| 25 | PATCH | `/materials/{id}/favorite` | 切换收藏 | ✓ |
| 26 | GET | `/article-stats/overview` | 统计概览卡片 | ✓ |
| 27 | GET | `/article-stats` | 文章统计列表 | ✓ |
| 28 | GET | `/article-stats/{articleId}` | 文章详情统计 | ✓ |
| 29 | GET | `/article-stats/{articleId}/read-sources` | 阅读来源 | ✓ |
| 30 | GET | `/article-stats/{articleId}/read-completion` | 阅读完成度 | ✓ |
| 31 | GET | `/fans` | 粉丝列表 | ✓ |
| 32 | PATCH | `/fans/{id}/block` | 拉黑粉丝 | ✓ |
| 33 | PATCH | `/fans/{id}/unblock` | 取消拉黑 | ✓ |
| 34 | POST | `/fan-messages` | 发送私信 | ✓ |
| 35 | GET | `/fan-messages` | 私信记录 | ✓ |
| 36 | GET | `/fan-stats/overview` | 粉丝概况概览 | ✓ |
| 37 | GET | `/fan-stats` | 粉丝统计列表 | ✓ |
| 38 | GET | `/fan-stats/trend` | 阅读量趋势 | ✓ |
| 39 | GET | `/fan-stats/portrait` | 粉丝画像 | ✓ |
| 40 | GET | `/fan-stats/portrait/dimensions` | 画像维度列表 | ✓ |
| 41 | GET | `/review-logs` | 审核记录列表 | ✓ |

---

> 生成工具: api-doc-generator | 生成日期: 2026-07-10
