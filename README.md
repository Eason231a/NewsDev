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






