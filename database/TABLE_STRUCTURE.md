# 黑马头条 — 数据库表结构文档

> 基于 `schema.sql` 梳理 | 共 15 张表 | MySQL 8.0+ | 字符集 utf8mb4

---

## 目录

- [表 1: users 用户表](#1-users)
- [表 2: channels 频道表](#2-channels)
- [表 3: articles 文章表](#3-articles)
- [表 4: materials 素材表](#4-materials)
- [表 5: article_cover_images 封面关联表](#5-article_cover_images)
- [表 6: article_stats_daily 文章每日统计表](#6-article_stats_daily)
- [表 7: article_read_sources 阅读来源表](#7-article_read_sources)
- [表 8: article_read_completion 阅读完成度表](#8-article_read_completion)
- [表 9: fans 粉丝表](#9-fans)
- [表 10: fan_stats_daily 粉丝每日统计表](#10-fan_stats_daily)
- [表 11: fan_read_hourly 粉丝阅读趋势表](#11-fan_read_hourly)
- [表 12: fan_portrait_data 粉丝画像表](#12-fan_portrait_data)
- [表 13: user_agreement_logs 协议确认表](#13-user_agreement_logs)
- [表 14: fan_messages 粉丝私信表](#14-fan_messages)
- [表 15: article_review_logs 审核记录表](#15-article_review_logs)
- [初始化数据](#初始化数据)
- [ER 关系速查](#er-关系速查)

---

---

# 表 1: users (用户表)

**用途**: 存储自媒体创作者账号信息，用于登录认证和身份管理。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 用户ID, 主键 |
| 2 | username | VARCHAR(64) | ✗ | — | 用户名(登录账号) |
| 3 | password_hash | VARCHAR(255) | ✗ | — | 密码哈希(BCrypt 加密) |
| 4 | avatar | VARCHAR(500) | ✓ | NULL | 头像 URL |
| 5 | status | TINYINT UNSIGNED | ✗ | 1 | 账号状态: `1`=正常 `0`=禁用 |
| 6 | last_login_at | DATETIME | ✓ | NULL | 最后登录时间 |
| 7 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 8 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间(自动) |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_username | UNIQUE | username | 登录时按用户名查找 |

**外键**: 无 (被其他表引用)

**被引用**:
- `articles.user_id` → `users.id` (CASCADE)
- `materials.user_id` → `users.id` (CASCADE)
- `fans.user_id` → `users.id` (CASCADE)
- `fan_stats_daily.user_id` → `users.id` (CASCADE)
- `fan_read_hourly.user_id` → `users.id` (CASCADE)
- `fan_portrait_data.user_id` → `users.id` (CASCADE)
- `user_agreement_logs.user_id` → `users.id` (CASCADE)
- `fan_messages.user_id` → `users.id` (CASCADE)

---

# 表 2: channels (频道表)

**用途**: 文章分类/频道，如科技、娱乐、体育等。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 频道ID, 主键 |
| 2 | name | VARCHAR(32) | ✗ | — | 频道名称(唯一) |
| 3 | description | VARCHAR(255) | ✓ | NULL | 频道描述 |
| 4 | sort_order | INT UNSIGNED | ✗ | 0 | 排序权重(越小越靠前) |
| 5 | is_enabled | TINYINT UNSIGNED | ✗ | 1 | `1`=启用 `0`=禁用 |
| 6 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 7 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间(自动) |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_name | UNIQUE | name | 频道名称唯一约束 |

**外键**: 无 (被 `articles` 引用)

**被引用**:
- `articles.channel_id` → `channels.id` (SET NULL)

**初始化数据** (10条):
`科技` `娱乐` `体育` `财经` `军事` `汽车` `健康` `教育` `美食` `旅游`

---

# 表 3: articles (文章表)

**用途**: 图文内容主表，涵盖草稿→审核→发布→上下架全生命周期。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 文章ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 作者ID → `users.id` |
| 3 | channel_id | BIGINT UNSIGNED | ✓ | NULL | 所属频道ID → `channels.id` |
| 4 | title | VARCHAR(255) | ✗ | — | 文章标题 |
| 5 | content | LONGTEXT | ✓ | NULL | 文章正文(富文本 HTML) |
| 6 | tag | VARCHAR(20) | ✓ | NULL | 自定义标签(≤20字符, 前端显示 0/20) |
| 7 | cover_type | TINYINT | ✗ | 0 | 封面类型: `0`=单图 `1`=三图 `2`=无图 |
| 8 | status | TINYINT | ✗ | 0 | 文章状态: `0`=草稿 `1`=待审核 `2`=审核通过 `3`=审核失败 `4`=已上架 `5`=已下架 |
| 9 | review_comment | VARCHAR(500) | ✓ | NULL | 审核意见(驳回时填写) |
| 10 | scheduled_at | DATETIME | ✓ | NULL | 定时发布时间(发布文章-定时功能) |
| 11 | published_at | DATETIME | ✓ | NULL | 实际上架时间 |
| 12 | deleted_at | DATETIME | ✓ | NULL | 软删除时间(NULL=未删除) |
| 13 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 14 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间(自动) |

**status 枚举值 (TINYINT)**:

| 值 | 前端标签 | 标签颜色 | 说明 |
|----|---------|---------|------|
| 0 | 草稿 | 灰色 | 未提交审核 |
| 1 | 待审核 | 橙色 | 已提交等待审核 |
| 2 | 审核通过 | 绿色 | 审核通过可上架 |
| 3 | 审核失败 | 红色 | 审核未通过 |
| 4 | 已上架 | 蓝色 | 已发布且在线 |
| 5 | 已下架 | 灰色 | 已发布但已下线 |

**cover_type 枚举值 (TINYINT)**:

| 值 | 前端选项 | 说明 |
|----|---------|------|
| 0 | 单图(默认) | 显示单图上传区域 |
| 1 | 三图 | 显示三图上传区域 |
| 2 | 无图 | 隐藏上传区域 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_user_id | INDEX | user_id | 按作者筛选 |
| idx_channel_id | INDEX | channel_id | 按频道筛选 |
| idx_status | INDEX | status | 内容列表状态筛选(核心) |
| idx_published_at | INDEX | published_at | 按发布时间排序 |
| idx_created_at | INDEX | created_at | 按创建时间排序/筛选 |
| idx_user_status | INDEX | user_id, status | 作者+状态组合筛选 |
| idx_scheduled_at | INDEX | scheduled_at | 定时发布任务扫描 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_articles_user | users(id) | CASCADE | CASCADE |
| fk_articles_channel | channels(id) | SET NULL | CASCADE |

**被引用**:
- `article_cover_images.article_id` (CASCADE)
- `article_stats_daily.article_id` (CASCADE)
- `article_read_sources.article_id` (CASCADE)
- `article_read_completion.article_id` (CASCADE)
- `article_review_logs.article_id` (CASCADE)

---

# 表 4: materials (素材表)

**用途**: 存储自媒体创作者上传的图片素材(用作文章封面或正文插图)，支持收藏/取消收藏、软删除。上传限制: jpg/png, 单文件 ≤ 2MB。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 素材ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 上传者ID → `users.id` |
| 3 | filename | VARCHAR(255) | ✗ | — | 原始文件名 |
| 4 | file_path | VARCHAR(500) | ✗ | — | 存储路径/URL |
| 5 | file_size | INT UNSIGNED | ✗ | — | 文件大小(字节, ≤2097152) |
| 6 | mime_type | VARCHAR(64) | ✗ | 'image/jpeg' | MIME 类型(image/jpeg 或 image/png) |
| 7 | is_favorite | TINYINT UNSIGNED | ✗ | 0 | `1`=已收藏(★) `0`=未收藏(☆) |
| 8 | deleted_at | DATETIME | ✓ | NULL | 软删除时间(NULL=未删除) |
| 9 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 上传时间 |
| 10 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_user_id | INDEX | user_id | 按上传者查所有素材 |
| idx_user_favorite | INDEX | user_id, is_favorite | 收藏列表筛选(全部/收藏切换) |
| idx_created_at | INDEX | created_at | 按时间排序 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_material_user | users(id) | CASCADE | CASCADE |

**被引用**:
- `article_cover_images.material_id` → `materials.id` (RESTRICT)

---

# 表 5: article_cover_images (封面关联表)

**用途**: 关联文章与素材表，将已上传的素材图片设为文章封面。素材表是图片唯一数据源，本表只做关联。cover_type=0(单图) 时存1条, 1(三图) 时存3条。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 关联ID, 主键 |
| 2 | article_id | BIGINT UNSIGNED | ✗ | — | 文章ID → `articles.id` |
| 3 | material_id | BIGINT UNSIGNED | ✗ | — | 素材ID → `materials.id` (封面图片) |
| 4 | sort_order | TINYINT UNSIGNED | ✗ | 0 | 排序: 单图=0, 三图依次=0/1/2 |
| 5 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_article_id | INDEX | article_id | 按文章查封面 |
| idx_material_id | INDEX | material_id | 按素材反查被哪些文章引用 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_cover_article | articles(id) | CASCADE | CASCADE |
| fk_cover_material | materials(id) | RESTRICT | CASCADE |

> **RESTRICT 含义**: 已被设为封面的素材不允许直接删除，需先解除文章关联。防止封面图被误删导致文章展示异常。

---

# 表 6: article_stats_daily (文章每日统计表)

**用途**: 存储每篇文章的每日数据指标，由定时任务每日凌晨汇总。对应对前端"图文数据列表页"表格和"文章详情页"统计卡片。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | article_id | BIGINT UNSIGNED | ✗ | — | 文章ID → `articles.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | read_count | INT UNSIGNED | ✗ | 0 | 阅读量(总) |
| 5 | like_count | INT UNSIGNED | ✗ | 0 | 点赞数量 |
| 6 | comment_count | INT UNSIGNED | ✗ | 0 | 评论量 |
| 7 | favorite_count | INT UNSIGNED | ✗ | 0 | 收藏数量 |
| 8 | share_count | INT UNSIGNED | ✗ | 0 | 转发数量 |
| 9 | avg_read_progress | DECIMAL(5,2) | ✓ | NULL | 平均阅读进度(%) 例:61.00 |
| 10 | bounce_rate | DECIMAL(5,2) | ✓ | NULL | 跳出率(%) 例:13.20 |
| 11 | avg_read_seconds | INT UNSIGNED | ✓ | NULL | 平均阅读停留时长(秒) |
| 12 | recommend_shares | INT UNSIGNED | ✗ | 0 | 推荐渠道转发量 |
| 13 | fan_read_count | INT UNSIGNED | ✗ | 0 | 粉丝阅读量 |
| 14 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 15 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**前端映射**:

| 字段 | 图文数据列表页 | 文章详情页 |
|------|:---:|:---:|
| read_count | ✓ 阅读列 | ✓ 总阅读量 |
| like_count | ✓ 点赞数量卡片 | — |
| comment_count | ✓ 评论量列 | ✓ 评论量 |
| favorite_count | ✓ 收藏数量卡片 + 收藏量列 | — |
| share_count | ✓ 转发数量卡片 + 转发量列 | — |
| avg_read_progress | — | ✓ 平均阅读进度 |
| bounce_rate | — | ✓ 跳出率 |
| avg_read_seconds | — | ✓ 平均阅读时间 |
| recommend_shares | — | ✓ 推荐转发量 |
| fan_read_count | — | ✓ 粉丝阅读量 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_article_date | UNIQUE | article_id, stat_date | 防同一日重复统计 |
| idx_stat_date | INDEX | stat_date | 日期范围筛选 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_stats_article | articles(id) | CASCADE | CASCADE |

---

# 表 7: article_read_sources (阅读来源表)

**用途**: 记录文章各阅读来源的占比，对应"阅读来源分析"环形图。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | article_id | BIGINT UNSIGNED | ✗ | — | 文章ID → `articles.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | source_type | TINYINT | ✗ | 0 | 来源类型: `0`=推荐 `1`=频道 `2`=相关阅读 `3`=应用外 `4`=其他 |
| 5 | read_count | INT UNSIGNED | ✗ | 0 | 该来源阅读量 |
| 6 | percentage | DECIMAL(5,2) | ✗ | 0.00 | 该来源占比(%) |
| 7 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**source_type 枚举值 (TINYINT)**:

| 值 | 前端标签 | 环形图颜色 |
|----|---------|-----------|
| 0 | 推荐 | 蓝色 #1890ff |
| 1 | 频道 | 绿色 #52c41a |
| 2 | 相关阅读 | 紫色 #722ed1 |
| 3 | 应用外阅读 | 黄色 #faad14 |
| 4 | 其他(搜索、推送等) | 红色 #ff4d4f |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_article_date_source | UNIQUE | article_id, stat_date, source_type | 防同一日重复 |
| idx_stat_date | INDEX | stat_date | 日期范围筛选 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_source_article | articles(id) | CASCADE | CASCADE |

---

# 表 8: article_read_completion (阅读完成度表)

**用途**: 记录各完成度区间的用户分布，对应"阅读完成度分析"环形图。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | article_id | BIGINT UNSIGNED | ✗ | — | 文章ID → `articles.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | completion_range | TINYINT | ✗ | 0 | 完成度区间: `0`=低于20% `1`=20%-80% `2`=高于80% |
| 5 | user_count | INT UNSIGNED | ✗ | 0 | 该区间用户数 |
| 6 | percentage | DECIMAL(5,2) | ✗ | 0.00 | 该区间占比(%) |
| 7 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**completion_range 枚举值 (TINYINT)**:

| 值 | 前端标签 | 环形图颜色 |
|----|---------|-----------|
| 0 | 20%以下 | 蓝色 #1890ff |
| 1 | 20%-80% | 绿色 #52c41a |
| 2 | 80%以上 | 紫色 #722ed1 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_article_date_range | UNIQUE | article_id, stat_date, completion_range | 防重复 |
| idx_stat_date | INDEX | stat_date | 日期范围筛选 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_completion_article | articles(id) | CASCADE | CASCADE |

---

# 表 9: fans (粉丝表)

**用途**: 存储关注了某位自媒体作者的粉丝，支持拉黑和发消息功能。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 粉丝记录ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 被关注的自媒体作者ID → `users.id` |
| 3 | fan_name | VARCHAR(64) | ✗ | — | 粉丝用户名/昵称(前端显示"用户A"等) |
| 4 | fan_avatar | VARCHAR(500) | ✓ | NULL | 粉丝头像 URL |
| 5 | is_blocked | TINYINT UNSIGNED | ✗ | 0 | `1`=已拉黑 `0`=正常 |
| 6 | followed_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 关注时间 |
| 7 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 8 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_user_id | INDEX | user_id | 按作者查粉丝 |
| idx_user_blocked | INDEX | user_id, is_blocked | 排除已拉黑粉丝 |
| idx_followed_at | INDEX | followed_at | 按关注时间排序 |
| idx_user_followed | INDEX | user_id, followed_at | 作者+时间组合查询 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_fan_user | users(id) | CASCADE | CASCADE |

**被引用**:
- `fan_messages.fan_id` → `fans.id` (CASCADE)

---

# 表 10: fan_stats_daily (粉丝每日统计表)

**用途**: 存储粉丝维度的每日汇总数据，对应"粉丝概况"页面4个统计卡片和数据列表。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 自媒体作者ID → `users.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | fan_count | INT UNSIGNED | ✗ | 0 | 新增粉丝数 |
| 5 | fan_read_count | INT UNSIGNED | ✗ | 0 | 粉丝阅读量 |
| 6 | fan_revenue | DECIMAL(12,2) | ✗ | 0.00 | 粉丝收益(元) |
| 7 | unfollow_count | INT UNSIGNED | ✗ | 0 | 取消关注量 |
| 8 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |
| 9 | updated_at | DATETIME | ✗ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**前端映射**:

| 字段 | 统计卡片 | 数据列表 |
|------|:---:|:---:|
| fan_count | ✓ 粉丝数量(绿色) | ✓ 粉丝数量 |
| fan_read_count | ✓ 粉丝累计阅读量(橙色) | ✓ 粉丝阅读量 |
| fan_revenue | ✓ 粉丝收益/元(紫色) | ✓ 粉丝收益 |
| unfollow_count | ✓ 取消关注量(蓝色) | ✓ 取消关注量 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_user_date | UNIQUE | user_id, stat_date | 防同一日重复统计 |
| idx_stat_date | INDEX | stat_date | 日期范围筛选 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_fan_stats_user | users(id) | CASCADE | CASCADE |

---

# 表 11: fan_read_hourly (粉丝阅读趋势表)

**用途**: 按小时粒度记录粉丝阅读量，对应"阅读量趋势图"折线图 (横轴: 00:00-23:00, 纵轴: 阅读量)。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 自媒体作者ID → `users.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | hour | TINYINT UNSIGNED | ✗ | — | 小时 (0-23) |
| 5 | read_count | INT UNSIGNED | ✗ | 0 | 该小时阅读量 |
| 6 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**数据示例**:

```
stat_date=2026-06-17, hour=0,  read_count=110
stat_date=2026-06-17, hour=1,  read_count=95
stat_date=2026-06-17, hour=2,  read_count=100
...
stat_date=2026-06-17, hour=23, read_count=50
```

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_user_date_hour | UNIQUE | user_id, stat_date, hour | 防同一小时重复 |
| idx_stat_date | INDEX | stat_date | 日期范围筛选 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_hourly_user | users(id) | CASCADE | CASCADE |

---

# 表 12: fan_portrait_data (粉丝画像表)

**用途**: 宽表设计存储粉丝多维度画像数据，对应"粉丝画像"页面的6个分析图表。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 自媒体作者ID → `users.id` |
| 3 | stat_date | DATE | ✗ | — | 统计日期 |
| 4 | dimension | TINYINT | ✗ | — | 画像维度: `0`=性别 `1`=年龄 `2`=地域 `3`=终端 `4`=活跃时间 `5`=内容偏好 |
| 5 | dimension_key | VARCHAR(64) | ✗ | — | 维度具体值 |
| 6 | dimension_value | INT UNSIGNED | ✗ | 0 | 数量 |
| 7 | percentage | DECIMAL(5,2) | ✓ | NULL | 占比(%) |
| 8 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**dimension 枚举值 (TINYINT) 及其 dimension_key**:

| dimension | 前端图表 | 图表类型 | dimension_key 示例 |
|-----------|---------|:---:|------|
| 0 (gender) | 粉丝性别分布 | 水平条形图 | `male`(男68%) `female`(女32%) |
| 1 (age) | 粉丝年龄分布 | 柱状图 | `0-17` `18-23` `24-30` `31-40` `41-50` `50+` |
| 2 (region) | 粉丝地域分布 | 地图/列表 | `广东` `北京` `上海` ... |
| 3 (device) | 粉丝终端分布 | 水平条形图 | `iOS`(65%) `Android`(35%) `PC` |
| 4 (active_time) | 粉丝活跃时间 | 柱状图 | `0-2时` `2-4时` ... `22-24时` |
| 5 (content_preference) | 内容偏好 | 柱状图 | `大数据` `人工智能` `游戏` `物联网` ... |

**查询示例**:

```sql
-- 按维度取所有值
SELECT dimension_key, dimension_value, percentage
FROM fan_portrait_data
WHERE user_id = ? AND stat_date = ? AND dimension = 0;  -- 0=性别

-- 取所有维度
SELECT dimension, dimension_key, dimension_value, percentage
FROM fan_portrait_data
WHERE user_id = ? AND stat_date = ?
ORDER BY dimension, dimension_value DESC;
```

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| uk_user_date_dim_key | UNIQUE | user_id, stat_date, dimension, dimension_key | 防重复 |
| idx_stat_date | INDEX | stat_date | 日期筛选 |
| idx_dimension | INDEX | dimension | 按维度查询 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_portrait_user | users(id) | CASCADE | CASCADE |

---

# 表 13: user_agreement_logs (协议确认表)

**用途**: 记录用户同意用户协议和隐私政策的历史，对应登录页"我已阅读并同意用户协议和隐私政策条款"复选框。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 用户ID → `users.id` |
| 3 | agreement_type | TINYINT | ✗ | 0 | 协议类型: `0`=用户协议 `1`=隐私政策 |
| 4 | agreed_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 同意时间 |
| 5 | ip_address | VARCHAR(45) | ✓ | NULL | 客户端 IP 地址(支持 IPv6) |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_user_id | INDEX | user_id | 按用户查询协议同意记录 |
| idx_agreed_at | INDEX | agreed_at | 按时间排序 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_agreement_user | users(id) | CASCADE | CASCADE |

---

# 表 14: fan_messages (粉丝私信表)

**用途**: 存储自媒体作者向粉丝发送的私信消息，对应粉丝列表卡片上的"发消息"按钮。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 消息ID, 主键 |
| 2 | user_id | BIGINT UNSIGNED | ✗ | — | 发送者(自媒体作者)ID → `users.id` |
| 3 | fan_id | BIGINT UNSIGNED | ✗ | — | 接收者(粉丝)ID → `fans.id` |
| 4 | content | TEXT | ✗ | — | 消息正文 |
| 5 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 发送时间 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_user_fan | INDEX | user_id, fan_id | 查询双方对话记录 |
| idx_created_at | INDEX | created_at | 按时间排序 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_msg_user | users(id) | CASCADE | CASCADE |
| fk_msg_fan | fans(id) | CASCADE | CASCADE |

---

# 表 15: article_review_logs (审核记录表)

**用途**: 记录文章每次审核的完整历史，审计追踪，对应内容列表的审核流程。

**主键**: `id` (BIGINT UNSIGNED, AUTO_INCREMENT)

**引擎**: InnoDB

| # | 字段 | 类型 | 空 | 默认值 | 说明 |
|---|------|------|:---:|--------|------|
| 1 | id | BIGINT UNSIGNED | ✗ | AUTO_INCREMENT | 记录ID, 主键 |
| 2 | article_id | BIGINT UNSIGNED | ✗ | — | 文章ID → `articles.id` |
| 3 | reviewer_id | BIGINT UNSIGNED | ✓ | NULL | 审核人ID(系统自动为NULL) |
| 4 | from_status | TINYINT | ✗ | — | 审核前状态: `0`草稿 `1`待审核 `2`审核通过 `3`审核失败 `4`已上架 `5`已下架 |
| 5 | to_status | TINYINT | ✗ | — | 审核后状态: 同 from_status |
| 6 | comment | VARCHAR(500) | ✓ | NULL | 审核意见(驳回原因等) |
| 7 | reviewed_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 审核时间 |
| 8 | created_at | DATETIME | ✗ | CURRENT_TIMESTAMP | 创建时间 |

**典型记录示例**:

| from_status | to_status | comment | 说明 |
|-------------|-----------|---------|------|
| 0 | 1 | — | 用户提交审核 |
| 1 | 2 | "内容符合规范" | 审核通过 |
| 1 | 3 | "标题含敏感词" | 审核驳回 |
| 2 | 4 | — | 用户上架 |
| 4 | 5 | — | 用户下架 |

**索引**:

| 索引名 | 类型 | 字段 | 用途 |
|--------|------|------|------|
| PRIMARY | 主键 | id | — |
| idx_article_id | INDEX | article_id | 按文章查审核历史 |
| idx_reviewed_at | INDEX | reviewed_at | 按审核时间排序 |

**外键**:

| 约束名 | 引用 | ON DELETE | ON UPDATE |
|--------|------|-----------|-----------|
| fk_review_article | articles(id) | CASCADE | CASCADE |

---

# 初始化数据

脚本末尾包含 10 条频道数据:

```sql
INSERT INTO channels (name, description, sort_order) VALUES
('科技', '科技领域资讯与深度分析', 1),
('娱乐', '娱乐新闻与明星动态',     2),
('体育', '体育赛事与运动资讯',     3),
('财经', '财经新闻与投资理财',     4),
('军事', '军事动态与国防科技',     5),
('汽车', '汽车行业与新车评测',     6),
('健康', '健康养生与医疗资讯',     7),
('教育', '教育政策与学习方法',     8),
('美食', '美食推荐与烹饪技巧',     9),
('旅游', '旅游攻略与景点推荐',    10);
```

---

# ER 关系速查

```
users (1) ──┬── (N) articles ──┬── (N) article_cover_images
            │                  ├── (N) article_stats_daily
            │                  ├── (N) article_read_sources
            │                  ├── (N) article_read_completion
            │                  └── (N) article_review_logs
            │
            ├── (N) materials
            │
            ├── (N) fans ────── (N) fan_messages
            │   └── (N) fan_messages (via user_id)
            │
            ├── (N) fan_stats_daily
            ├── (N) fan_read_hourly
            ├── (N) fan_portrait_data
            └── (N) user_agreement_logs

channels (1) ── (N) articles
```

**外键删除策略汇总**:

| 级联类型 | 涉及外键 | 含义 |
|---------|---------|------|
| CASCADE (级联删除) | 13个 | 删除用户→自动删除其所有文章/素材/粉丝/统计数据 |
| SET NULL (置空) | 1个 | 删除频道→文章的 channel_id 变 NULL |

---

> 📄 关联文件:
> - 建表脚本: [`schema.sql`](./schema.sql)
> - 设计总览: [`README.md`](./README.md)
