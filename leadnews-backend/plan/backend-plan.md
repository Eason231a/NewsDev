# 黑马头条后端 — 开发执行计划

> **版本**: V1.0 | **创建日期**: 2026-07-28 | **状态**: 待执行
>
> 本文件为可变的工作文档，随开发进度持续更新。

---

## 项目配置速查

| 配置项 | 值 |
|--------|-----|
| 基础包路径 | `com.heima.leadnews` |
| Maven GroupId | `com.heima` |
| Maven ArtifactId | `leadnews-backend` |
| Java 版本 | 17 |
| Spring Boot 版本 | 3.2 |
| ORM | MyBatis-Plus 3.5 |
| 数据库 | MySQL 8.0 (localhost:3306, heima_news, root/123456) |
| 服务端口 | 8080 |
| 图片存储 | 本地文件存储（预留 OSS 接口） |
| 认证方式 | JWT (HMAC-SHA256, 24h) |

### 文章状态枚举（以 API 文档 + 数据库为准）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 草稿 | 未提交审核 |
| 1 | 待审核 | 已提交等待审核 |
| 2 | 审核通过 | 审核通过可上架 |
| 3 | 审核失败 | 审核未通过 |
| 4 | 已上架 | 已发布且在线 |
| 5 | 已下架 | 已发布但已下线 |

> **注意**: 后端 CLAUDE.md 中状态机示意图有误（3/4/5 映射错误），以本表格和 API 文档、TABLE_STRUCTURE.md 为准。

---

## 阶段一：搭建基础环境工程

**目标**: 可启动的 Spring Boot 空项目，基础设施就绪。

### 1.1 初始化项目
- [ ] 使用 Spring Initializr 或手动创建 Maven 项目
- [ ] 配置 `pom.xml`，引入依赖：
  - `spring-boot-starter-web`
  - `spring-boot-starter-security`（仅用 BCrypt，不用过滤器链）
  - `spring-boot-starter-validation`
  - `mybatis-plus-spring-boot3-starter`
  - `mysql-connector-j`
  - `jjwt` (0.12.x)
  - `hutool` (5.8.x)
  - `springdoc-openapi` (2.5.x)
  - `aliyun-sdk-oss` (3.17.x，预留)
  - `lombok`
- [ ] 创建主启动类 `LeadnewsBackendApplication`

### 1.2 配置 application.yml
- [ ] 数据源：`spring.datasource`（MySQL heima_news, root/123456）
- [ ] 服务端口：8080
- [ ] JWT 配置：`jwt.secret`、`jwt.expiration`（24h）
- [ ] 文件上传配置：本地存储路径、允许扩展名、最大 2MB
- [ ] OSS 配置（预留给后续切换）

### 1.3 创建基础包结构
```
com.heima.leadnews
├── config/          # MyBatis-Plus分页插件、CORS、文件上传
├── common/
│   ├── result/      # Result<T>, PageResult<T>
│   ├── exception/   # GlobalExceptionHandler, BusinessException
│   └── context/     # UserContext (ThreadLocal)
├── security/        # JwtUtil, JwtAuthFilter
├── controller/
├── service/impl/
├── mapper/
└── entity/dto/
```

### 1.4 通用组件实现
- [ ] `Result<T>` — 统一响应包装 `{ code, message, data }`
- [ ] `PageResult<T>` — 分页响应 `{ list, total, page, pageSize }`
- [ ] `GlobalExceptionHandler` — 全局异常处理，映射到 400/401/403/404/413/422/500
- [ ] `BusinessException` — 业务异常（携带错误码）
- [ ] `UserContext` — ThreadLocal 存储当前用户 ID

### 1.5 MyBatis-Plus 配置
- [ ] 分页插件 `MybatisPlusInterceptor`
- [ ] 逻辑删除配置（articles/materials 的 deleted_at）
- [ ] 自动填充（created_at/updated_at）

### 1.6 验证
- [ ] 启动项目，确认无报错
- [ ] 访问 `http://localhost:8080` 确认服务可用
- [ ] Swagger UI：`http://localhost:8080/swagger-ui.html` 可访问

**完成标志**: 程序可启动，基础框架就绪。

---

## 阶段二：认证模块

**目标**: 实现 JWT 登录/注册/Token 刷新/获取用户信息。

### 2.1 实体 & Mapper
- [ ] `entity/User.java` — 对应 `users` 表
- [ ] `entity/UserAgreementLog.java` — 对应 `user_agreement_logs`
- [ ] `mapper/UserMapper.java`
- [ ] `mapper/UserAgreementLogMapper.java`

### 2.2 安全组件
- [ ] `security/JwtUtil.java`
  - `generateToken(userId, username)` → JWT String
  - `parseToken(token)` → Claims
  - `validateToken(token)` → boolean
  - 签名算法 HMAC-SHA256，密钥从配置文件 `${jwt.secret}` 读取
- [ ] `security/JwtAuthFilter.java` — OncePerRequestFilter
  - 从 Header 提取 `Authorization: Bearer <token>`
  - 校验 Token → 解析 userId → 设置 `UserContext`
  - 排除 `/auth/login`、`/auth/register`、Swagger 路径
- [ ] `common/context/UserContext.java`
  - ThreadLocal 存取 userId

### 2.3 DTO
- [ ] `dto/LoginRequest.java` (username, password, agreeTerms)
- [ ] `dto/RegisterRequest.java` (username, password, agreeTerms)
- [ ] `dto/LoginResponse.java` (token, expiresAt, user)
- [ ] `dto/UserResponse.java` (id, username, avatar, status)

### 2.4 Service
- [ ] `service/AuthService.java`
  - `login(LoginRequest)` — 查用户 → BCrypt 校验 → 生成 Token → 记录登录时间 → 记录协议同意日志 → 返回 LoginResponse
  - `register(RegisterRequest)` — 校验用户名唯一 → BCrypt 加密 → 插入用户 → 记录协议同意日志 → 返回 UserResponse
  - `refresh(String token)` — 校验旧 Token → 生成新 Token
  - `getCurrentUser()` — 从 UserContext 取 userId → 查库返回

### 2.5 Controller
- [ ] `controller/AuthController.java`
  - `POST /auth/login`
  - `POST /auth/register`
  - `POST /auth/refresh`
  - `GET /auth/me`

### 2.6 验证
- [ ] 注册新用户 → 返回用户信息
- [ ] 重复注册 → 返回 409
- [ ] 登录 → 返回 Token + 用户信息
- [ ] 未勾选协议 → 返回 400
- [ ] 携带 Token 访问 `/auth/me` → 返回当前用户
- [ ] 无 Token 访问需认证接口 → 返回 401
- [ ] Token 过期 → 返回 401

**完成标志**: 注册/登录/Token 刷新全流程通畅。

---

## 阶段三：素材管理

**目标**: 图片上传（本地存储）+ 列表/收藏/删除/恢复。

### 3.1 实体 & Mapper
- [ ] `entity/Material.java` — 对应 `materials` 表（含逻辑删除字段）
- [ ] `mapper/MaterialMapper.java`

### 3.2 文件上传配置
- [ ] `config/FileUploadConfig.java` — 本地存储路径、文件大小限制 2MB、扩展名白名单(jpg/png)
- [ ] `common/utils/FileUtil.java` — 文件扩展名校验、UUID 文件命名
- [ ] 上传路径: `{localStoragePath}/materials/{userId}/{yyyyMMdd}/{UUID}.{ext}`
- [ ] 预留 OSS 接口（`FileStorageService` 接口 + 本地实现 + OSS 实现）

### 3.3 DTO
- [ ] `dto/MaterialResponse.java` (id, filename, filePath, fileSize, mimeType, isFavorite, createdAt)
- [ ] `dto/FavoriteRequest.java` (isFavorite)

### 3.4 Service
- [ ] `service/MaterialService.java`
  - `list(page, pageSize, isFavorite)` — 分页查当前用户素材，按 `isFavorite` 筛选
  - `getById(id)` — 素材详情（含越权校验）
  - `upload(file)` — 校验扩展名 + 大小 → 存本地 → 写数据库 → 返回 MaterialResponse
  - `delete(id)` — 软删除（设 deleted_at），已被封面引用的返回 422
  - `restore(id)` — 恢复（设 deleted_at = null）
  - `toggleFavorite(id, isFavorite)` — 切换收藏状态

### 3.5 Controller
- [ ] `controller/MaterialController.java`
  - `GET /materials` — 素材列表（分页）
  - `GET /materials/{id}` — 素材详情
  - `POST /materials/upload` — 上传素材（multipart/form-data）
  - `DELETE /materials/{id}` — 删除素材
  - `PATCH /materials/{id}/restore` — 恢复素材
  - `PATCH /materials/{id}/favorite` — 切换收藏

### 3.6 验证
- [ ] 上传 jpg/png（≤2MB）→ 成功，返回素材信息
- [ ] 上传超过 2MB → 返回 413
- [ ] 上传非图片文件 → 返回 422
- [ ] 素材列表分页正常
- [ ] 收藏/取消收藏切换正常
- [ ] "全部"和"收藏"筛选正常
- [ ] 删除 → 不再出现在列表中
- [ ] 恢复 → 重新出现在列表中

**完成标志**: 素材上传/列表/收藏/删除流程通畅。

---

## 阶段四：频道管理

**目标**: 频道 CRUD + 启用/禁用。

### 4.1 实体 & Mapper
- [ ] `entity/Channel.java` — 对应 `channels` 表
- [ ] `mapper/ChannelMapper.java`

### 4.2 DTO
- [ ] `dto/ChannelRequest.java` (name, description, sortOrder)
- [ ] `dto/ChannelResponse.java` (id, name, description, sortOrder, isEnabled, createdAt)
- [ ] `dto/ChannelStatusRequest.java` (isEnabled)

### 4.3 Service
- [ ] `service/ChannelService.java`
  - `list(isEnabled)` — 查所有（可按启用状态筛选），按 `sortOrder` 升序
  - `getById(id)` — 频道详情
  - `create(request)` — 新建频道（校验 name 唯一）
  - `update(id, request)` — 更新频道
  - `setStatus(id, isEnabled)` — 启用/禁用

### 4.4 Controller
- [ ] `controller/ChannelController.java`
  - `GET /channels` — 频道列表
  - `GET /channels/{id}` — 频道详情
  - `POST /channels` — 创建频道
  - `PUT /channels/{id}` — 更新频道
  - `PATCH /channels/{id}/status` — 设置启用状态

### 4.5 验证
- [ ] 获取频道列表 → 返回 10 条示例数据，按 sortOrder 排序
- [ ] 按 isEnabled 筛选正常
- [ ] 创建频道 → 成功，name 重复返回 409
- [ ] 更新频道 → 成功
- [ ] 禁用频道 → isEnabled 变为 0

**完成标志**: 频道 CRUD 全流程通畅。

---

## 阶段五：发布文章

**目标**: 创建文章（草稿/提交审核）+ 封面管理 + 定时发布 + 审核日志。

### 5.1 实体 & Mapper
- [ ] `entity/Article.java` — 对应 `articles` 表
- [ ] `entity/ArticleCoverImage.java` — 对应 `article_cover_images`
- [ ] `entity/ArticleReviewLog.java` — 对应 `article_review_logs`
- [ ] `mapper/ArticleMapper.java`
- [ ] `mapper/ArticleCoverImageMapper.java`
- [ ] `mapper/ArticleReviewLogMapper.java`

### 5.2 枚举定义
- [ ] `enums/ArticleStatus.java` — 0草稿/1待审核/2审核通过/3审核失败/4已上架/5已下架
- [ ] `enums/CoverType.java` — 0单图/1三图/2无图

### 5.3 DTO
- [ ] `dto/ArticleCreateRequest.java`
  - channelId, title, content, tag, coverType, status(0或1), scheduledAt, coverMaterialIds
- [ ] `dto/ArticleResponse.java`
  - 全部字段 + channelName + coverImages + stats
- [ ] `dto/ArticleStatsVO.java` — 统计数据内嵌对象（readCount/likeCount/commentCount/favoriteCount/shareCount）
- [ ] `dto/CoverImageVO.java` — 封面内嵌对象

### 5.4 状态机校验
在 Service 层实现状态流转白名单：
```
0(草稿) → 1(待审核)
1(待审核) → 2(审核通过) / 3(审核失败)
2(审核通过) → 4(已上架)
3(审核失败) → 0(重新编辑)
4(已上架) → 5(已下架)
5(已下架) → 4(重新上架)
```
非法流转抛 BusinessException(422)。

### 5.5 Service
- [ ] `service/ArticleService.java`
  - `create(request)` — 创建文章 + 封面关联 + 审核日志
    - status=0: 存入草稿（不写审核日志）
    - status=1: 提交审核（写审核日志 from=0, to=1）
  - `update(id, request)` — 更新文章（仅草稿/审核失败可编辑） + 更新封面关联
  - `getById(id)` — 文章详情（含 coverImages、channelName）
  - `list(pageRequest)` — 分页列表（按状态/频道/关键字/日期筛选），LEFT JOIN article_stats_daily 汇总 stats
  - `changeStatus(id, status, comment)` — 状态变更 + 审核日志
  - `delete(id)` — 软删除（仅草稿/审核失败可删）
  - `restore(id)` — 恢复
  - `getEnums(field)` — 返回枚举值列表
  - `getCovers(id)` — 获取封面图片
  - `setCovers(id, coverType, materialIds)` — 设置封面（先删后增）

### 5.6 Controller
- [ ] `controller/ArticleController.java`
  - `POST /articles` — 创建文章
  - `PUT /articles/{id}` — 更新文章
  - 其他端点见阶段六（内容列表）

### 5.7 验证
- [ ] 创建草稿 → 状态=0，无审核日志
- [ ] 提交审核 → 状态=1，审核日志 from=0 to=1
- [ ] 单图封面 → article_cover_images 插入 1 条
- [ ] 三图封面 → article_cover_images 插入 3 条
- [ ] 无图封面 → article_cover_images 不插入
- [ ] 定时发布 → scheduled_at 字段正确存储
- [ ] 标签超 20 字符 → 返回 400

**完成标志**: 创建文章（草稿/提交审核）+ 封面设置通畅。

---

## 阶段六：内容列表

**目标**: 文章列表（多条件筛选）+ 状态流转 + 删除/恢复 + 枚举查询。

### 6.1 在已有 ArticleService 上扩展

阶段五已创建 ArticleService 和 ArticleController 骨架，本阶段实现完整的列表和状态操作。

### 6.2 DTO
- [ ] `dto/ArticleListRequest.java` — page, pageSize, status, channelId, keyword, startDate, endDate, sortBy, order
- [ ] `dto/ArticleStatusRequest.java` — status, comment

### 6.3 Service（扩展）
- [ ] `list(request)` — 完善：
  - 动态查询：MyBatis-Plus LambdaQueryWrapper 按条件组装
  - 加入 `deleted_at IS NULL` 过滤
  - LEFT JOIN channels 取 channelName
  - LEFT JOIN article_stats_daily SUM 汇总 stats（readCount, likeCount, commentCount, favoriteCount, shareCount）
  - LEFT JOIN article_cover_images + materials 取封面 URL
  - 分页返回
- [ ] `changeStatus(id, newStatus, comment)` — 完善：
  - 状态机白名单校验
  - 上架(publish)时设置 `published_at = now()`
  - 下架(unpublish)时不改变 published_at
  - 每次流转写 article_review_logs 记录
  - 如果目标状态=审核失败(3)，comment 必填

### 6.4 Controller（扩展）
- [ ] `GET /articles` — 文章列表（分页+筛选）
- [ ] `GET /articles/{id}` — 文章详情
- [ ] `PATCH /articles/{id}/status` — 变更状态
- [ ] `DELETE /articles/{id}` — 软删除
- [ ] `PATCH /articles/{id}/restore` — 恢复
- [ ] `GET /articles/enums/{field}` — 枚举查询 (status/coverType)
- [ ] `GET /articles/{id}/covers` — 获取封面
- [ ] `PUT /articles/{id}/covers` — 设置封面

### 6.5 审核日志
- [ ] `controller/ReviewLogController.java`
  - `GET /review-logs` — 审核记录列表（可按 articleId 筛选，分页）

### 6.6 验证
- [ ] 全部/草稿/待审核/审核通过/审核失败 筛选正确
- [ ] 关键字搜索正确（模糊匹配标题）
- [ ] 频道筛选正确
- [ ] 日期范围筛选正确
- [ ] 草稿 → 提交审核 → 待审核 ✓
- [ ] 待审核 → 审核通过 → 审核通过 ✓
- [ ] 审核通过 → 上架 → 已上架 ✓
- [ ] 已上架 → 下架 → 已下架 ✓
- [ ] 非草稿/审核失败状态删除 → 返回 422
- [ ] 审核失败 → 编辑 → 成功（状态不变，由前端再次提交审核）
- [ ] 非草稿/审核失败编辑 → 返回 422

**完成标志**: 内容列表全流程（CRUD + 状态流转 + 筛选）通畅。

---

## 阶段七：图文数据

**目标**: 文章数据概览卡片 + 文章统计列表 + 文章详情统计 + 阅读来源/完成度图表数据。

### 7.1 实体 & Mapper
- [ ] `entity/ArticleStatsDaily.java` — 对应 `article_stats_daily`
- [ ] `entity/ArticleReadSource.java` — 对应 `article_read_sources`
- [ ] `entity/ArticleReadCompletion.java` — 对应 `article_read_completion`
- [ ] `mapper/ArticleStatsDailyMapper.java`
- [ ] `mapper/ArticleReadSourceMapper.java`
- [ ] `mapper/ArticleReadCompletionMapper.java`

### 7.2 DTO
- [ ] `dto/StatsOverviewResponse.java`
  - totalPublishCount, totalLikeCount, totalFavoriteCount, totalShareCount
- [ ] `dto/ArticleStatsResponse.java`
  - articleId, articleTitle, statDate, readCount, likeCount, commentCount, favoriteCount, shareCount, fanReadCount
- [ ] `dto/ArticleDetailStatsResponse.java`
  - articleId, articleTitle
  - summary: 8 项指标（totalReadCount, totalLikeCount, totalCommentCount, totalFavoriteCount, totalShareCount, avgReadProgress, bounceRate, avgReadSeconds, totalRecommendShares, totalFanReadCount）
  - daily: 每日明细数组
- [ ] `dto/ReadSourceResponse.java` — articleId, statDate, sources 数组
- [ ] `dto/ReadCompletionResponse.java` — articleId, statDate, completions 数组
- [ ] `dto/SourceItem.java` — sourceType, sourceLabel, readCount, percentage, color
- [ ] `dto/CompletionItem.java` — completionRange, rangeLabel, userCount, percentage, color

### 7.3 Service
- [ ] `service/ArticleStatsService.java`
  - `getOverview(userId, startDate, endDate)` — 聚合查询 4 项指标：
    - totalPublishCount: articles 表中 user_id=userId 且 published_at 在日期范围内的记录数
    - totalLikeCount / totalFavoriteCount / totalShareCount: article_stats_daily 按日期 SUM
  - `list(page, pageSize, startDate, endDate, sortBy, order)` — 分页查询：
    - JOIN articles 取 title
    - JOIN article_stats_daily 按日期筛选 + SUM 聚合
    - 按指定字段排序
  - `getArticleDetail(articleId, startDate, endDate)` — 单篇文章：
    - 聚合 summary（8 项指标）
    - 日均值计算：avgReadProgress(SQL AVG), bounceRate(SQL AVG), avgReadSeconds(SQL AVG)
    - 查询 daily 明细列表
  - `getReadSources(articleId, statDate)` — 查 article_read_sources 表，含颜色映射
  - `getReadCompletion(articleId, statDate)` — 查 article_read_completion 表，含颜色映射

### 7.4 Controller
- [ ] `controller/ArticleStatsController.java`
  - `GET /article-stats/overview` — 统计概览卡片
  - `GET /article-stats` — 文章统计列表（分页）
  - `GET /article-stats/{articleId}` — 文章详情统计
  - `GET /article-stats/{articleId}/read-sources` — 阅读来源分析
  - `GET /article-stats/{articleId}/read-completion` — 阅读完成度分析

### 7.5 验证
- [ ] 概览卡片：4 项数据正确（日期范围筛选有效）
- [ ] 文章列表：分页 + 字段正确 + 排序有效
- [ ] 文章详情：8 项 summary + daily 明细正确
- [ ] 阅读来源：5 种来源占比总和 = 100%
- [ ] 阅读完成度：3 个区间占比总和 = 100%

**完成标志**: 图文数据模块全部 5 个接口数据正确。

---

## 阶段八：粉丝管理 — 粉丝概况

**目标**: 粉丝概况概览卡片 + 每日统计数据列表 + 阅读量小时趋势。

### 8.1 实体 & Mapper
- [ ] `entity/FanStatsDaily.java` — 对应 `fan_stats_daily`
- [ ] `entity/FanReadHourly.java` — 对应 `fan_read_hourly`
- [ ] `mapper/FanStatsDailyMapper.java`
- [ ] `mapper/FanReadHourlyMapper.java`

### 8.2 DTO
- [ ] `dto/FanOverviewResponse.java`
  - totalFanCount, totalFanReadCount, totalFanRevenue, totalUnfollowCount
- [ ] `dto/FanStatsResponse.java`
  - id, statDate, fanCount, fanReadCount, fanRevenue, unfollowCount, newFollowCount
- [ ] `dto/FanTrendResponse.java`
  - statDate, hours 数组（hour, readCount）

### 8.3 Service
- [ ] `service/FanStatsService.java`
  - `getOverview(userId, startDate, endDate)` — 4 项卡片：
    - totalFanCount: 当前粉丝总数（COUNT from fans WHERE user_id=userId AND is_blocked=0）
    - totalFanReadCount: SUM(fan_read_count) FROM fan_stats_daily 日期范围
    - totalFanRevenue: SUM(fan_revenue) FROM fan_stats_daily 日期范围
    - totalUnfollowCount: SUM(unfollow_count) FROM fan_stats_daily 日期范围
  - `list(userId, page, pageSize, startDate, endDate)` — 每日粉丝统计分页
  - `getTrend(userId, statDate)` — 查 fan_read_hourly WHERE stat_date=?, 返回 0-23 小时数据

### 8.4 Controller
- [ ] `controller/FanStatsController.java`
  - `GET /fan-stats/overview` — 粉丝概况概览
  - `GET /fan-stats` — 粉丝统计数据列表
  - `GET /fan-stats/trend` — 阅读量小时趋势

### 8.5 验证
- [ ] 概况卡片：4 项数据正确
- [ ] 数据列表：分页 + 日期筛选有效
- [ ] 趋势图：返回 24 个数据点（hour 0-23）

**完成标志**: 粉丝概况模块全部通畅。

---

## 阶段九：粉丝管理 — 粉丝画像

**目标**: 粉丝画像多维度数据查询（性别/年龄/地域/终端/活跃时间/内容偏好）。

### 9.1 实体 & Mapper
- [ ] `entity/FanPortraitData.java` — 对应 `fan_portrait_data`
- [ ] `mapper/FanPortraitDataMapper.java`

### 9.2 DTO
- [ ] `dto/PortraitDimensionResponse.java` — 单个维度（dimension, dimensionLabel, chartType, items 数组）
- [ ] `dto/PortraitItemResponse.java` — dimensionKey, dimensionKeyLabel, dimensionValue, percentage
- [ ] `dto/PortraitResponse.java` — statDate + portraits 数组（全部维度时）或单个 dimension
- [ ] `dto/DimensionMetaResponse.java` — 维度元数据列表

### 9.3 Service（在 FanStatsService 中扩展）
- [ ] `getPortrait(userId, statDate, dimension)`
  - dimension 指定时：返回该维度数据（chartType 按 TABLE_STRUCTURE 映射）
  - dimension 不传时：返回全部 6 个维度
  - 默认取最新一天数据
- [ ] `getPortraitDimensions()` — 返回 6 个维度的元数据列表（value, label, chartType）

### 9.4 Controller（在 FanStatsController 中扩展）
- [ ] `GET /fan-stats/portrait` — 粉丝画像（支持 dimension 参数筛选）
- [ ] `GET /fan-stats/portrait/dimensions` — 画像维度列表

### 9.5 验证
- [ ] 不传 dimension → 返回 6 个维度完整数据
- [ ] dimension=0 → 仅返回性别分布（男/女 + 占比）
- [ ] dimension=1 → 返回年龄分布（6 个区间 + 占比）
- [ ] 维度元数据接口 → 返回 6 项含 chartType

**完成标志**: 粉丝画像全部维度查询正确。

---

## 阶段十：粉丝管理 — 粉丝列表

**目标**: 粉丝列表 + 拉黑/取消拉黑 + 发送私信 + 私信记录。

### 10.1 实体 & Mapper
- [ ] `entity/Fan.java` — 对应 `fans` 表
- [ ] `entity/FanMessage.java` — 对应 `fan_messages`
- [ ] `mapper/FanMapper.java`
- [ ] `mapper/FanMessageMapper.java`

### 10.2 DTO
- [ ] `dto/FanResponse.java` — id, fanName, fanAvatar, isBlocked, followedAt
- [ ] `dto/FanMessageRequest.java` — fanId, content
- [ ] `dto/FanMessageResponse.java` — id, user(fanId/fanName), content, createdAt

### 10.3 Service
- [ ] `service/FanService.java`
  - `list(userId, page, pageSize, isBlocked)` — 粉丝列表分页，可按拉黑状态筛选
  - `block(userId, fanId)` — 拉黑（设为 isBlocked=1）
  - `unblock(userId, fanId)` — 取消拉黑（设为 isBlocked=0）

- [ ] `service/FanMessageService.java`
  - `send(userId, request)` — 发送私信（插入 fan_messages）
  - `list(userId, fanId, page, pageSize)` — 查询与某粉丝的对话历史，按时间倒序

### 10.4 Controller
- [ ] `controller/FanController.java`
  - `GET /fans` — 粉丝列表
  - `PATCH /fans/{id}/block` — 拉黑粉丝
  - `PATCH /fans/{id}/unblock` — 取消拉黑
- [ ] `controller/FanMessageController.java`
  - `POST /fan-messages` — 发送私信
  - `GET /fan-messages` — 私信记录

### 10.5 验证
- [ ] 粉丝列表分页正常
- [ ] 拉黑 → isBlocked=1，列表中可筛选
- [ ] 取消拉黑 → isBlocked=0
- [ ] 发送私信 → fan_messages 表有记录
- [ ] 私信记录 → 按 fanId 查询正确

**完成标志**: 粉丝列表 + 私信全流程通畅。

---

## 接口清单汇总

共 41 个接口，按模块分布：

| 模块 | 接口数 | 涉及阶段 |
|------|:---:|:---:|
| 认证 | 4 | 阶段二 |
| 素材管理 | 6 | 阶段三 |
| 频道管理 | 5 | 阶段四 |
| 文章管理 | 9 | 阶段五 + 阶段六 |
| 审核日志 | 1 | 阶段六 |
| 文章数据统计 | 5 | 阶段七 |
| 粉丝管理 | 5 | 阶段十 |
| 粉丝数据统计 | 5 | 阶段八 + 阶段九 |
| 私信 | 2 | 阶段十 |
| **合计** | **41** | |

---

## 进度记录

| 阶段 | 状态 | 开始时间 | 完成时间 | 备注 |
|------|:---:|---------|---------|------|
| 一：基础环境 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 基础框架搭建完成，应用可正常启动 |
| 二：认证模块 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 注册/登录/Token刷新/用户信息 4 接口均正常 |
| 三：素材管理 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 上传/列表/详情/收藏/删除/恢复 6 接口均正常 |
| 四：频道管理 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 列表/详情/创建/更新/状态 5 接口均正常，GET公开/POST+PUT+PATCH需认证 |
| 五：发布文章 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 创建(草稿/提交审核)/更新/详情 3 接口，含封面管理+审核日志+状态机校验 |
| 六：内容列表 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 列表(多条件筛选+排序)/状态流转(状态机)/删除/恢复/枚举/封面/审核日志 9 接口均正常 |
| 七：图文数据 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 概览/列表/详情/阅读来源/完成度 5 接口均正常 |
| 八：粉丝概况 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 概览/列表/趋势 3 接口均正常，含 NPE 修复（LocalDate.parse 安全守卫） |
| 九：粉丝画像 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | PORTRAIT 维度查询 + 维度列表 2 接口均正常，含 dimensionKey→label 映射 |
| 十：粉丝列表 | ✅ 已完成 | 2026-07-28 | 2026-07-28 | 列表/拉黑/取消拉黑/发送私信/私信记录 5 接口均正常 |

**状态图例**: ⏳ 待执行 | 🔄 进行中 | ✅ 已完成 | ❌ 已跳过

---

> **关联文档**:
> - 全局约束: `../../CLAUDE.md`
> - 后端约束: `../CLAUDE.md`
> - API 文档: `../../docs/api-documentation.md`
> - 数据库表结构: `../../database/TABLE_STRUCTURE.md`
> - 需求文档: `../../docs/需求文档.md`
> - 技术方案: `../../docs/技术方案选型文档.md`
