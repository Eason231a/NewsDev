# 黑马头条自媒体人管理系统 — 数据库设计文档

> 版本 V1.0 | 2026-06-17 | MySQL 8.0+

---

## 目录

1. [产品概述](#1-产品概述)
2. [数据库架构总览](#2-数据库架构总览)
3. [ER 实体关系图](#3-er-实体关系图)
4. [表结构详细说明](#4-表结构详细说明)
5. [文章状态机](#5-文章状态机)
6. [前端页面 → 数据库映射](#6-前端页面--数据库映射)
7. [索引策略](#7-索引策略)
8. [性能优化建议](#8-性能优化建议)
9. [安全性设计](#9-安全性设计)
10. [扩展规划](#10-扩展规划)

---

## 1. 产品概述

黑马头条是一款面向自媒体创作者的内容管理与数据分析平台。核心功能包括：

| 模块 | 功能 |
|------|------|
| 登录系统 | 用户名+密码认证，用户协议确认 |
| 图文数据 | 数据概览统计卡片 + 文章数据分页列表 + 文章详情分析 |
| 发布文章 | 富文本编辑 + 标签/频道/定时发布/封面设置 |
| 内容列表 | 按状态/关键字/频道/日期筛选 + 上下架操作 |
| 素材管理 | 图片上传/收藏/删除 + 全部/收藏标签切换 |
| 粉丝管理 | 粉丝概况统计 + 粉丝画像分析 + 粉丝列表管理 |

---

## 2. 数据库架构总览

| # | 表名 | 中文名 | 行数预估 | 读写比 |
|---|------|--------|---------|--------|
| 1 | `users` | 用户表 | 万级 | 1:10 |
| 2 | `channels` | 频道表 | 十级 | 100:1 |
| 3 | `articles` | 文章表 | 百万级 | 1:3 |
| 4 | `materials` | 素材表 | 十万级 | 1:5 |
| 5 | `article_cover_images` | 封面关联表 | 百万级 | 1:1 |
| 6 | `article_stats_daily` | 文章统计表 | 千万级 | 1:20 |
| 7 | `article_read_sources` | 阅读来源表 | 千万级 | 1:20 |
| 8 | `article_read_completion` | 阅读完成度表 | 千万级 | 1:20 |
| 9 | `fans` | 粉丝表 | 百万级 | 1:8 |
| 10 | `fan_stats_daily` | 粉丝统计表 | 十万级 | 1:15 |
| 11 | `fan_read_hourly` | 粉丝阅读趋势表 | 百万级 | 1:20 |
| 12 | `fan_portrait_data` | 粉丝画像表 | 十万级 | 1:15 |
| 13 | `user_agreement_logs` | 协议确认表 | 万级 | 1:1 |
| 14 | `fan_messages` | 粉丝私信表 | 十万级 | 1:5 |
| 15 | `article_review_logs` | 审核记录表 | 百万级 | 1:10 |

---

## 3. ER 实体关系图

```
┌──────────────┐       ┌──────────────────┐
│    users     │       │    channels      │
│  自媒体作者   │       │     频道分类      │
└──────┬───────┘       └────────┬─────────┘
       │ 1                      │ 1
       │                        │
       │ N                      │ N
       ▼                        ▼
┌──────────────────────────────────────────────┐
│                  articles                     │
│                  文章主表                      │
│  status: draft→pending→approved→published     │
└──┬────────┬────────┬────────┬───────────────┘
   │ 1      │ 1      │ 1      │ 1
   │ N      │ N      │ N      │ N
   ▼        ▼        ▼        ▼
┌──────┐ ┌──────┐ ┌──────┐ ┌──────────────────┐
│cover │ │stats │ │read  │ │read_completion   │
│关联表│ │daily │ │sources│ │                  │
│(→素材)│ │每日统│ │阅读来│ │阅读完成度         │
└──┬───┘ └──────┘ └──────┘ └──────────────────┘
   │ N
   │ 1
   ▼
┌──────────────┐
│   materials  │
│   素材表     │
│  (图片唯一   │
│   数据源)    │
└──────────────┘

┌──────────────┐       ┌──────────────────┐
│   materials  │       │      fans        │
│   素材管理   │       │     粉丝列表      │
└──────────────┘       └────────┬─────────┘
                                │ 1
       ┌────────────────────────┼────────────┐
       │ N                      │ N          │ N
       ▼                        ▼            ▼
┌──────────────┐       ┌──────────────┐ ┌──────────────┐
│fan_stats_daily│      │fan_read_hourly│ │fan_portrait  │
│粉丝每日统计   │      │粉丝阅读趋势    │ │粉丝画像       │
└──────────────┘       └──────────────┘ └──────────────┘
```

---

## 4. 表结构详细说明

### 4.1 users — 用户表

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | BIGINT UNSIGNED | ✓ | 主键, 自增 |
| username | VARCHAR(64) | ✓ | 登录用户名, UNIQUE |
| password_hash | VARCHAR(255) | ✓ | BCrypt 哈希密码 |
| avatar | VARCHAR(500) | | 头像 URL |
| status | TINYINT | ✓ | 1=正常 0=禁用 |
| last_login_at | DATETIME | | 最后登录时间 |

### 4.2 articles — 文章主表

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | BIGINT UNSIGNED | ✓ | 主键 |
| user_id | BIGINT UNSIGNED | ✓ | FK → users.id |
| channel_id | BIGINT UNSIGNED | | FK → channels.id |
| title | VARCHAR(255) | ✓ | 文章标题 |
| content | LONGTEXT | | 富文本正文 |
| tag | VARCHAR(20) | | 自定义标签(≤20字符) |
| cover_type | ENUM | ✓ | 0=单图/1=三图/2=无图 |
| status | ENUM | ✓ | 0草稿/1待审核/2通过/3失败/4已上架/5已下架 |
| review_comment | VARCHAR(500) | | 驳回原因 |
| scheduled_at | DATETIME | | 定时发布时间 |
| published_at | DATETIME | | 实际上架时间 |
| deleted_at | DATETIME | | 软删除标记 |

### 4.3 article_stats_daily — 文章每日统计

| 字段 | 类型 | 说明 |
|------|------|------|
| read_count | INT UNSIGNED | 阅读量 |
| like_count | INT UNSIGNED | 点赞数 |
| comment_count | INT UNSIGNED | 评论数 |
| favorite_count | INT UNSIGNED | 收藏数 |
| share_count | INT UNSIGNED | 转发数 |
| avg_read_progress | DECIMAL(5,2) | 平均阅读进度(%) |
| bounce_rate | DECIMAL(5,2) | 跳出率(%) |
| avg_read_seconds | INT UNSIGNED | 平均阅读时长(秒) |
| recommend_shares | INT UNSIGNED | 推荐转发量 |
| fan_read_count | INT UNSIGNED | 粉丝阅读量 |

### 4.4 fan_portrait_data — 粉丝画像 (宽表设计)

**dimension 维度枚举:**

| dimension | 说明 | dimension_key 示例 |
|-----------|------|-------------------|
| gender | 性别分布 | male / female |
| age | 年龄分布 | 0-17 / 18-23 / 24-30 / 31-40 / 41-50 / 50+ |
| region | 地域分布 | 广东 / 北京 / 上海 / ... |
| device | 终端分布 | iOS / Android / PC |
| active_time | 活跃时间分布 | 0-2时 / 2-4时 / ... / 22-24时 |
| content_preference | 内容偏好 | 大数据 / 人工智能 / 游戏 / ... |

采用 `(dimension, dimension_key)` 宽表设计的优势：
- 新增画像维度无需 ALTER TABLE
- 查询灵活：`WHERE dimension = 'gender'` 即可取性别数据
- 前端图表可直接按 dimension 分组渲染

---

## 5. 文章状态机

```
                    ┌─────────┐
                    │    0    │  草稿(初始状态)
                    │  草稿   │
                    └────┬────┘
                         │ 提交审核
                         ▼
                    ┌─────────┐
                    │    1    │  待审核
                    │ 待审核  │
                    └────┬────┘
                    ┌────┴────┐
                    ▼         ▼
              ┌─────────┐  ┌──────────┐
              │    2    │  │    3     │  审核通过 / 审核失败
              │审核通过  │  │ 审核失败  │
              └────┬────┘  └────┬─────┘
                   │ 上架        │ 重新编辑
                   ▼            ▼
              ┌─────────┐  ┌─────────┐
              │    4    │  │    0    │
              │ 已上架  │  └─────────┘
              └────┬────┘
                   │ 下架
                   ▼
              ┌───────────┐
              │    5      │  已下架
              │  已下架   │
              └─────┬─────┘
                    │ 重新上架
                    ▼
              ┌─────────┐
              │    4    │
              └─────────┘
```

**状态操作矩阵:**

| 当前状态 | 可用操作 | 目标状态 |
|---------|---------|---------|
| 0 (草稿) | 编辑 | 0 |
| 0 (草稿) | 提交审核 | 1 |
| 0 (草稿) | 删除 | (软删除) |
| 1 (待审核) | — | (等待审核) |
| 2 (审核通过) | 上架 | 4 |
| 3 (审核失败) | 编辑 | 0 |
| 3 (审核失败) | 删除 | (软删除) |
| 4 (已上架) | 下架 | 5 |
| 5 (已下架) | 上架 | 4 |

---

## 6. 前端页面 → 数据库映射

### 6.1 登录页

| 功能 | 涉及表 | 操作 |
|------|--------|------|
| 用户认证 | `users` | SELECT by username |
| 协议确认 | `user_agreement_logs` | INSERT |

### 6.2 图文数据列表页

| 功能 | 涉及表 | SQL 示例 |
|------|--------|---------|
| 4项统计卡片 | `article_stats_daily` | `SELECT SUM(read_count), SUM(like_count), SUM(favorite_count), SUM(share_count) WHERE stat_date BETWEEN ? AND ? AND user_id = ?` |
| 文章数据表格 | `articles` + `article_stats_daily` | JOIN 查询, 按 stat_date 范围过滤, 分页 |
| 日期快捷筛选 | — | 前端计算日期范围传入 SQL |

### 6.3 文章数据详情页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 8项统计卡片 | `article_stats_daily` | WHERE article_id = ? AND stat_date BETWEEN ? |
| 阅读来源环形图 | `article_read_sources` | WHERE article_id = ? GROUP BY source_type |
| 阅读完成度环形图 | `article_read_completion` | WHERE article_id = ? GROUP BY completion_range |

### 6.4 发布文章页

| 功能 | 涉及表 | 操作 |
|------|--------|------|
| 保存草稿 | `articles` | INSERT status=0 |
| 提交审核 | `articles` + `article_review_logs` | UPDATE status=1 + INSERT 审核日志 |
| 频道下拉 | `channels` | SELECT id, name WHERE is_enabled=1 ORDER BY sort_order |
| 上传封面 | `article_cover_images` | INSERT (article 保存后关联) |

### 6.5 内容列表页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 状态筛选 | `articles` | WHERE status = ? |
| 关键字搜索 | `articles` | WHERE title LIKE '%keyword%' |
| 频道筛选 | `articles` | WHERE channel_id = ? |
| 日期范围 | `articles` | WHERE created_at BETWEEN ? |
| 上下架操作 | `articles` | UPDATE status=4/5 |
| 编辑 | `articles` | UPDATE title/content/channel_id... |
| 删除 | `articles` | UPDATE deleted_at = NOW() (软删除) |

### 6.6 素材管理页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 全部/收藏切换 | `materials` | WHERE is_favorite = 0/1 |
| 上传图片 | `materials` | INSERT (校验 jpg/png, ≤2MB) |
| 收藏切换 | `materials` | UPDATE is_favorite = 1/0 |
| 删除 | `materials` | UPDATE deleted_at = NOW() |

### 6.7 粉丝概况页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 4项统计卡片 | `fan_stats_daily` | SELECT SUM(total_fan_count), SUM(fan_read_count), SUM(fan_revenue), SUM(unfollow_count) |
| 阅读量趋势图 | `fan_read_hourly` | WHERE stat_date = ? ORDER BY hour |
| 数据列表 | `fan_stats_daily` | WHERE stat_date BETWEEN ? ORDER BY stat_date DESC |

### 6.8 粉丝画像页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 性别分布 | `fan_portrait_data` | WHERE dimension='gender' |
| 年龄分布 | `fan_portrait_data` | WHERE dimension='age' |
| 地域分布 | `fan_portrait_data` | WHERE dimension='region' |
| 终端分布 | `fan_portrait_data` | WHERE dimension='device' |
| 活跃时间 | `fan_portrait_data` | WHERE dimension='active_time' |
| 内容偏好 | `fan_portrait_data` | WHERE dimension='content_preference' |

### 6.9 粉丝列表页

| 功能 | 涉及表 | 说明 |
|------|--------|------|
| 粉丝卡片列表 | `fans` | SELECT * WHERE user_id = ? LIMIT 18 OFFSET ? |
| 加载更多 | `fans` | 游标分页 |
| 发消息 | `fan_messages` | INSERT |
| 拉黑 | `fans` | UPDATE is_blocked = 1 |

---

## 7. 索引策略

### 7.1 索引清单

| 表 | 索引名 | 类型 | 字段 | 用途 |
|----|--------|------|------|------|
| users | uk_username | UNIQUE | username | 登录查询 |
| articles | idx_user_id | INDEX | user_id | 按作者筛选 |
| articles | idx_channel_id | INDEX | channel_id | 按频道筛选 |
| articles | idx_status | INDEX | status | 内容列表状态筛选 |
| articles | idx_user_status | INDEX | user_id, status | 组合筛选 |
| articles | idx_scheduled_at | INDEX | scheduled_at | 定时发布任务 |
| article_stats_daily | uk_article_date | UNIQUE | article_id, stat_date | 去重 + JOIN |
| article_stats_daily | idx_stat_date | INDEX | stat_date | 日期范围查询 |
| materials | idx_user_favorite | INDEX | user_id, is_favorite | 收藏列表筛选 |
| fans | idx_user_blocked | INDEX | user_id, is_blocked | 黑名单过滤 |
| fans | idx_user_followed | INDEX | user_id, followed_at | 粉丝排序 |
| fan_portrait_data | uk_user_date_dim_key | UNIQUE | user_id, stat_date, dimension, dimension_key | 唯一约束 |
| fan_portrait_data | idx_dimension | INDEX | dimension | 按维度查询 |

### 7.2 索引原则

1. **所有外键都建索引** — 保证 JOIN 性能
2. **WHERE 高频字段建索引** — 内容列表的 status / user_id / channel_id
3. **日期字段建索引** — 统计查询几乎都带日期范围
4. **联合唯一索引防重** — stat_date + 实体ID 的组合防止重复写入
5. **避免过度索引** — 写多读少的表(如 fan_messages)只建必要索引

---

## 8. 性能优化建议

### 8.1 分区策略

当数据量达到千万级时，对以下表按日期分区：

```sql
-- 示例: article_stats_daily 按月分区
ALTER TABLE article_stats_daily
PARTITION BY RANGE (TO_DAYS(stat_date)) (
  PARTITION p202601 VALUES LESS THAN (TO_DAYS('2026-02-01')),
  PARTITION p202602 VALUES LESS THAN (TO_DAYS('2026-03-01')),
  ...
);
```

**建议分区表:** `article_stats_daily`, `article_read_sources`, `fan_read_hourly`

### 8.2 缓存策略

| 数据 | 缓存方案 | TTL |
|------|---------|-----|
| 统计卡片(图文发布量等) | Redis 缓存聚合值 | 5分钟 |
| 频道列表 | 应用内存缓存 | 1小时 |
| 粉丝画像数据 | Redis 缓存 JSON | 1小时 |
| 热门文章列表 | Redis Sorted Set | 10分钟 |

### 8.3 慢查询优化

```sql
-- 统计汇总查询建议写法(利用索引)
SELECT
  SUM(read_count)  AS total_reads,
  SUM(like_count)  AS total_likes,
  SUM(share_count) AS total_shares
FROM article_stats_daily
WHERE user_id = ?
  AND stat_date BETWEEN '2026-06-10' AND '2026-06-17';

-- 注意: 需要在 article_stats_daily 表加 user_id 冗余字段
-- 或通过 JOIN articles 获取 user_id:
SELECT SUM(ast.read_count), SUM(ast.like_count)
FROM article_stats_daily ast
JOIN articles a ON a.id = ast.article_id
WHERE a.user_id = ? AND ast.stat_date BETWEEN ?;
```

### 8.4 定时任务

| 任务 | 频率 | 说明 |
|------|------|------|
| 文章统计汇总 | 每日凌晨2点 | 将昨日埋点数据汇总写入 `article_stats_daily` |
| 粉丝统计汇总 | 每日凌晨3点 | 汇总写入 `fan_stats_daily` |
| 阅读趋势聚合 | 每小时 | 聚合写入 `fan_read_hourly` |
| 画像数据更新 | 每日凌晨4点 | 更新 `fan_portrait_data` |
| 定时发布扫描 | 每分钟 | 扫描 `scheduled_at <= NOW()` 且 status=2 的文章 |

---

## 9. 安全性设计

| 措施 | 实现 |
|------|------|
| 密码加密 | BCrypt 哈希存储，不可逆 |
| SQL 注入防护 | 全部使用参数化查询(Prepared Statement) |
| 软删除 | articles + materials 不真删，deleted_at 标记 |
| 操作审计 | article_review_logs 记录每次状态变更 |
| 敏感操作确认 | 删除/拉黑 需前端二次确认 |
| 协议留痕 | user_agreement_logs 带 IP 和时间戳 |

---

## 10. 扩展规划

### 10.1 近期可扩展

- **文章标签表** `article_tags`: 如果标签需要标准化（多篇文章共用标签），可将 tag 字段抽取为独立表
- **操作日志表** `operation_logs`: 记录所有用户操作（上下架/编辑/删除）用于安全审计
- **定时任务表** `scheduled_tasks`: 管理定时发布等异步任务

### 10.2 中远期扩展

- **多作者协作**: 增加 `article_collaborators` 表
- **评论系统**: 增加 `comments` / `comment_replies` 表
- **消息通知**: 增加 `notifications` 表(审核结果/新粉丝等)
- **数据大盘**: 引入 OLAP 引擎(ClickHouse) 做实时数据分析
- **全文搜索**: 接入 Elasticsearch 做文章全文检索

---

## 附录: 快速部署

```bash
# 1. 连接 MySQL
mysql -u root -p

# 2. 执行建表脚本
source database/schema.sql;

# 3. 验证
USE heima_news;
SHOW TABLES;
```

---

> 📄 关联文件: [`schema.sql`](./schema.sql)
