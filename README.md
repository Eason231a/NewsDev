# 黑马头条 (HeiMa Toutiao) - AI 原生全栈开发项目

本项目借鉴黑马头条的页面原型和需求文档开发完成，全程采用 **AI 驱动的高效全栈开发模式 (AI-Driven Development Workflow)**。通过集成 MCP (Model Context Protocol)、Custom Skills、Claude Code 等 AI 自动化工具，实现了从需求分析、数据库设计、接口定义到前后端分阶段编码与联调的全流程 AI 赋能。

---

## 🛠️ AI 驱动开发工作流 (AI-Driven Development Workflow)

```
[1. 技术选型 & UI设计] ➔ [2. 数据库 & API设计] ➔ [3. 后端架构 & 编码] ➔ [4. 前端架构 & 编码] ➔ [5. 联调 & 测试]
```

### 1. 技术选型与 UI 设计
* **架构设计与选型**：借助 AI 深度分析业务需求与系统吞吐量，评估前后端技术方案，生成标准化 `技术选型.md`。
* **UI/UX 视觉设计**：基于黑马头条产品原型与需求文档，使用 **Figma** 完成全套高保真 UI 设计稿。

### 2. 数据层与 API 契约设计 (`database-schema-designer`)
* **自动化 SQL 提取**：通过 Custom Skill 工具解析需求文档与 UI 交互逻辑，自动推导数据库结构并生成高质量 SQL 脚本及 `库表说明文档.md`。
* **MCP 自动化部署**：调用 MySQL **MCP (Model Context Protocol)** 服务直接执行 SQL 脚本，完成本地及远程数据库的一键建表与初始化。
* **接口规范契约**：基于数据库 Schema 生成标准化 Open API / 接口文档，同步导出 Postman 测试集（`.json`），明确前后端数据交互协议。

### 3. AI 辅助后端开发 (`superpower`)
* **执行计划拟定**：结合接口文档、需求文档与 UI 稿，利用 AI 生成后端开发规划文档（`backend_plan.md`），明确工程目录结构、核心业务流程与分阶段 Milestone。
* **分步落地与编码**：计划确认无误后，遵循“先计划、后编码、边测边改”的原则，分阶段实现核心业务逻辑编码与单元自测。

### 4. AI 辅助前端开发 (`frontend-design`)
* **设计稿集成**：在 **Claude Code** 中集成 **Figma MCP**，实现 AI 对 Figma 设计稿设计标注与组件结构的直接读取与解析。
* **前端计划生成**：结合设计稿、需求文档与接口文档，AI 自动生成前端开发规划（`frontend-plan.md`）。
* **组件化开发**：按照规划分步搭建页面框架与 UI 组件，确保像素级还原设计稿与状态管理。

### 5. 联调测试与交付
* **自动化联调**：使用 `webapp-testing` 工具对前后端进行自动化端到端 (E2E) 联调测试，快速定位接口适配与数据流问题。
* **人工验收**：完成自动化测试后，进行人工边界条件与用户体验测试，确保项目高质量交付。

---

## 🐛 踩坑记录与解决方案 (Troubleshooting & Solutions)

在 **AI Native 全栈开发** 的实践过程中，虽然 AI 工具大幅提升了研发效率，但在数据契约与接口推导上也遇到了一些典型问题，以下是具体的踩坑与应对策略：

### 1. AI 推导数据表字段类型不匹配 (Data Type Mismatch)
* **问题描述**：在使用 Custom Skill 解析需求文档与原型自动推导数据库 Schema 时，AI 对状态码（如文章审核状态）、枚举值、时间戳格式以及高精度数字（如阅读量统计、金额）的类型推导不够精准，导致前后端联调时发生类型转换报错。
* **解决方案**：在 Custom Skill 的 Prompt 中注入严格的**类型映射字典规范**（例如：强行约束所有状态码映射为 `TINYINT`，时间统一为 `DATETIME`/`TIMESTAMP`）；同时在生成 Postman Collection 时增加针对数据类型的断言测试，在联调前先进行自动化 Schema 动态校验。

### 2. JSON 接口契约与 Postman Mock 数据结构差异 (API Contract Discrepancy)
* **问题描述**：`database-schema-designer` 基于库表生成接口规范（JSON）时，在处理分页数据、嵌套对象以及统一响应体（如 `Result<T>`）时结构不够统一，导致 Postman 生成的 Mock 数据与前端期望的接收格式产生偏差。
* **解决方案**：建立项目级通用的 `ResponseResult` 泛型响应结构文档，约束 AI 工具在生成 JSON 契约时必须严格遵循统一的顶层数据结构（`code`, `msg`, `data`）；并在 Postman 中加入 Pre-request Script 拦截器进行契约结构校验，确保 Mock 数据的准确性。

### 3. 全局规范约束失效与代码幻觉 (Global Constraints via `CLAUDE.md`)
* **问题描述**：在使用 Claude Code 进行跨模块、多文件的代码生成时，随着上下文（Context）逐渐膨胀，AI 容易忽略初始设定（如目录规范、组件命名规范、异常处理机制），甚至出现伪代码占位（如 `// ...其余代码保持不变`）的情况。
* **解决方案**：在项目根目录下引入 **`CLAUDE.md`** 作为 AI 的全局运行法则。在其中明确规定：代码规范、禁止使用伪代码占位、错误处理标准以及项目的目录结构。借助 Claude Code 会优先读取 `CLAUDE.md` 的特性，强制约束每一次上下文调用的输出质量，有效杜绝了代码幻觉与规范偏离。

---

## 🚧 未解决问题与后续规划 (Known Issues & Roadmap)

* **AI 生成代码的重构与性能优化 (Code Refactoring & Performance)**
  * **现状**：当前由 AI 辅助生成的后端 SQL 查询与业务逻辑代码主要以**快速实现功能与满足业务逻辑**为主，在海量数据或高并发场景下的性能表现尚缺乏测试验证。
  * **后续规划**：后续计划引入慢查询日志分析，对数据库索引（如建立复合索引）进行专项优化；同时对核心热点接口引入 Redis 缓存层，并重构部分冗余的业务逻辑代码，提升系统高并发下的响应性能。

* **更精细化的权限管理架构 (Refined RBAC & Data Authority)**
  * **现状**：目前项目的权限控制满足基础角色区分（如普通用户、创作者、管理员），但在动态按钮级权限控制与细粒度的数据隔离（如创作者仅可编辑/删除自己所属的文章与草稿）方面仍有提升空间。
  * **后续规划**：计划引入基于 **RBAC (Role-Based Access Control)** 模型的动态权限框架，重构前端菜单路由鉴权与后端 Data-level 权限拦截器，实现灵活的按钮级别与数据级别的访问控制。

---

## 📂 项目关键文档 (Artifacts)

| 文档名称 | 说明 | 对应工具 / 阶段 |
| :--- | :--- | :--- |
| `技术选型.md` | 规定前后端具体技术栈与架构规范 | AI 架构分析 |
| `backend_plan.md` | 后端分阶段开发执行规划文档 | superpower |
| `frontend-plan.md` | 前端分阶段开发执行规划文档 | frontend-design |
| `Postman Collection (.json)` | 接口测试集与 API 规范 | database-schema-designer |

---

## 🔧 AI 工具链与生态 (AI Tools & MCP Integration)

- **Claude Code**: AI 终端辅助开发环境
- **Figma MCP**: 读取 Figma 视觉设计规范与 UI 组件布局
- **MySQL MCP**: 自动化数据库 Schema 执行与数据验证
- **Custom Skills**: 需求/原型解析工具 & 自动化测试集成


<img width="1280" height="594" alt="1" src="https://github.com/user-attachments/assets/58dd3f40-d64b-45e9-bc04-94f0cb5f291d" />
<img width="1280" height="591" alt="2" src="https://github.com/user-attachments/assets/d383078c-9783-4c47-be7d-ce32399cba9a" />
<img width="1280" height="595" alt="3" src="https://github.com/user-attachments/assets/e882e642-1127-48d2-ba3e-ea86bc9de887" />
<img width="1280" height="594" alt="4" src="https://github.com/user-attachments/assets/e939f271-a65a-4af6-badb-fec6ca036698" />
<img width="1280" height="593" alt="5" src="https://github.com/user-attachments/assets/71c66a82-fe5a-438b-9fab-e3fecd2a517c" />
<img width="1277" height="593" alt="6" src="https://github.com/user-attachments/assets/eb39c8c1-6599-4a2a-8c1d-4a4abb7daa34" />
<img width="1280" height="592" alt="7" src="https://github.com/user-attachments/assets/293506a0-6531-4443-be30-d3c660bc443c" />
<img width="740" height="641" alt="8" src="https://github.com/user-attachments/assets/f9681ecb-46cb-44f7-b3c4-553bab3c5060" />






