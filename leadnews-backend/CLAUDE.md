# 黑马头条 - 后端约束规则

> **本文件定位**：后端开发的约束规则（"宪法"），开发过程中 **不修改** 本文件。
> **执行计划**：存放在 `plan/backend-plan.md`，进度更新只操作该文件。

---

## 技术栈

- Java 17 + Spring Boot 3.2
- MyBatis-Plus 3.5（ORM + 分页 + 动态SQL）
- MySQL 8.0（15张表，详见 `../database/TABLE_STRUCTURE.md`）
- JWT 无状态认证（HMAC-SHA256，24h过期）
- 阿里云 OSS（图片存储）
- Springdoc OpenAPI 2.5（Swagger文档）

## 项目包结构（必须遵守）

```
com.heima.leadnews
├── config/          # 配置类（MyBatis-Plus、OSS、JWT、CORS等）
├── common/          # 通用组件
│   ├── result/      # 统一响应 Result<T>、PageResult<T>
│   ├── exception/   # 全局异常处理 GlobalExceptionHandler
│   ├── context/     # UserContext（ThreadLocal存userId）
│   └── utils/       # JwtUtil、OssUtil 等工具类
├── security/        # JWT过滤器、认证相关
├── controller/      # 控制器层（按模块分包）
├── service/         # 业务逻辑层
│   └── impl/
├── mapper/          # MyBatis Mapper接口
└── entity/          # 实体类（对应数据库表）
    └── dto/         # 请求/响应DTO
```

## 关键架构决策（必须遵守）

### 认证流程
```
请求 → JwtAuthFilter → 解析Token → 设置UserContext(userId) → Controller → Service
                                                                    ↓
                                                          所有查询必须带 userId
```

### 文章状态机
```
草稿(0) → 待审核(1) → 审核通过(2) → 已上架(3) → 已下架(4)
                ↓
          审核失败(5) → 可重新提交 → 待审核(1)
```
状态流转在Service层做白名单校验，非法流转抛422。

### API设计规范
- 统一响应：`Result.success(data)` / `Result.error(code, message)`
- 分页参数：`page`（默认1）、`pageSize`（默认10）
- 分页响应：`PageResult { list, total, page, pageSize }`
- 参数校验：`@Valid` + Jakarta Validation，不手写 if-else

## 参考文档

- 执行计划：`plan/backend-plan.md`（进度更新操作此文件）
- API接口文档：`../docs/api-documentation.md`
- 数据库表结构：`../database/TABLE_STRUCTURE.md`
- SQL脚本：`../database/heima_news.sql`
- 需求文档：`../docs/需求文档.md`
- 技术方案：`../docs/技术方案选型文档.md`

## 开发流程（必须遵守）

```
1. 读取 plan/backend-plan.md 获取当前执行计划和进度
2. 确认当前阶段任务
3. 执行开发（编码 + 自测）
4. 测试通过后，向用户展示成果
5. 等待用户确认（必须等待，不能自行继续）
6. 用户确认后，更新 plan/backend-plan.md 中的进度状态
7. 进入下一阶段
```

## 会话恢复流程

当会话丢失后：
```
1. 读取本文件（leadnews-backend/CLAUDE.md）→ 了解后端约束规则
2. 读取根目录 CLAUDE.md → 了解全局规范
3. 读取 plan/backend-plan.md → 恢复当前开发进度
4. 从上次未完成的阶段继续执行
```
