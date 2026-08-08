-- ============================================================
-- 黑马头条自媒体人管理系统 — 数据库建表脚本
-- 版本: V1.1
-- 数据库: MySQL 8.0+
-- 字符集: utf8mb4
-- 生成日期: 2026-06-17
-- 更新日期: 2026-06-24 — 枚举字段统一改为TINYINT数值存储
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS heima_news
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE heima_news;

-- ============================================================
-- 1. 用户表 (自媒体创作者)
-- 说明: 存储自媒体创作者账号信息，用于登录认证和身份管理
-- ============================================================
CREATE TABLE users (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
  username      VARCHAR(64)      NOT NULL COMMENT '用户名(登录账号)',
  password_hash VARCHAR(255)     NOT NULL COMMENT '密码哈希(BCrypt)',
  avatar        VARCHAR(500)     NULL     COMMENT '头像URL',
  status        TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '账号状态: 1=正常 0=禁用',
  last_login_at DATETIME         NULL     COMMENT '最后登录时间',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE INDEX uk_username (username)
) ENGINE=InnoDB COMMENT='自媒体创作者用户表';


-- ============================================================
-- 2. 频道表 (文章分类)
-- 说明: 文章所属频道/栏目，如科技、娱乐、体育等
-- ============================================================
CREATE TABLE channels (
  id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '频道ID',
  name        VARCHAR(32)      NOT NULL COMMENT '频道名称',
  description VARCHAR(255)     NULL     COMMENT '频道描述',
  sort_order  INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '排序权重(越小越靠前)',
  is_enabled  TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '启用状态: 1=启用 0=禁用',
  created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE INDEX uk_name (name)
) ENGINE=InnoDB COMMENT='文章频道/分类';


-- ============================================================
-- 3. 文章表 (核心内容)
-- 说明: 图文内容主表，涵盖草稿→审核→发布→上下架全生命周期
--
-- 状态流转 (数值):
--   0(草稿) → 1(待审核) → 2(审核通过) → 4(已上架)
--                                        ↕
--                                 5(已下架)
--   1 → 3(审核失败) → 0(重新编辑)
-- ============================================================
CREATE TABLE articles (
  id              BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '文章ID',
  user_id         BIGINT UNSIGNED  NOT NULL COMMENT '作者ID(关联users)',
  channel_id      BIGINT UNSIGNED  NULL     COMMENT '所属频道ID(关联channels)',
  title           VARCHAR(255)     NOT NULL COMMENT '文章标题',
  content         LONGTEXT         NULL     COMMENT '文章正文(JSON字符串格式，包含富文本格式信息和图片链接等)',
  tag             VARCHAR(20)      NULL     COMMENT '自定义标签(最多20字符)',
  cover_type      TINYINT          NOT NULL DEFAULT 0 COMMENT '封面类型: 0单图 1三图 2无图',
  status          TINYINT          NOT NULL DEFAULT 0 COMMENT '文章状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  review_comment  VARCHAR(500)     NULL     COMMENT '审核意见(驳回时填写)',
  scheduled_at    DATETIME         NULL     COMMENT '定时发布时间',
  published_at    DATETIME         NULL     COMMENT '实际上架发布时间',
  deleted_at      DATETIME         NULL     COMMENT '软删除时间(NULL=未删除)',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  -- 索引设计
  INDEX idx_user_id (user_id),                    -- 按作者查询
  INDEX idx_channel_id (channel_id),              -- 按频道筛选
  INDEX idx_status (status),                      -- 按状态筛选(内容列表核心查询)
  INDEX idx_published_at (published_at),          -- 按发布时间排序
  INDEX idx_created_at (created_at),              -- 按创建时间排序/筛选
  INDEX idx_user_status (user_id, status),        -- 作者+状态组合查询
  INDEX idx_scheduled_at (scheduled_at),          -- 定时发布任务查询

  -- 外键约束
  CONSTRAINT fk_articles_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_articles_channel
    FOREIGN KEY (channel_id) REFERENCES channels(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章/图文内容主表';


-- ============================================================
-- 4. 素材管理表
-- 说明: 存储自媒体创作者上传的图片素材(用作文章封面或正文插图)
--       支持收藏/取消收藏, 软删除
--       上传限制: jpg/png, 单文件 ≤ 2MB
-- ============================================================
CREATE TABLE materials (
  id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '素材ID',
  user_id      BIGINT UNSIGNED  NOT NULL COMMENT '上传者ID',
  filename     VARCHAR(255)     NOT NULL COMMENT '原始文件名',
  file_path    VARCHAR(500)     NOT NULL COMMENT '存储路径/URL',
  file_size    INT UNSIGNED     NOT NULL COMMENT '文件大小(字节 上限2MB即2097152)',
  mime_type    VARCHAR(64)      NOT NULL DEFAULT 'image/jpeg' COMMENT 'MIME类型(image/jpeg 或 image/png)',
  is_favorite  TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '收藏标记: 1=已收藏 0=未收藏',
  deleted_at   DATETIME         NULL     COMMENT '软删除时间(NULL=未删除)',
  created_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  updated_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  INDEX idx_user_id (user_id),                        -- 按上传者查询
  INDEX idx_user_favorite (user_id, is_favorite),     -- 收藏列表筛选
  INDEX idx_created_at (created_at),                  -- 按时间排序

  CONSTRAINT fk_material_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='素材管理(图片资源, 支持收藏/删除)';


-- ============================================================
-- 5. 文章封面关联表
-- 说明: 关联文章与素材表中的封面图片
--       素材表(materials)是图片唯一数据源，本表只做关联
--       cover_type=0 时存1条, =1 时存3条
-- ============================================================
CREATE TABLE article_cover_images (
  id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '关联ID',
  article_id  BIGINT UNSIGNED  NOT NULL COMMENT '文章ID',
  material_id BIGINT UNSIGNED  NOT NULL COMMENT '素材ID(封面图片)',
  sort_order  TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序(单图=0, 三图依次=0/1/2)',
  created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  INDEX idx_article_id (article_id),
  INDEX idx_material_id (material_id),

  CONSTRAINT fk_cover_article
    FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cover_material
    FOREIGN KEY (material_id) REFERENCES materials(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章封面关联表(关联素材表,支持单图/三图)';


-- ============================================================
-- 6. 文章每日统计表
-- 说明: 存储每篇文章的每日数据指标
--       对应前端"图文数据列表页"表格 + "文章详情页"统计卡片
--       定时任务每日凌晨汇总前一天数据写入此表
-- ============================================================
CREATE TABLE article_stats_daily (
  id                BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '统计记录ID',
  article_id        BIGINT UNSIGNED  NOT NULL COMMENT '文章ID',
  stat_date         DATE             NOT NULL COMMENT '统计日期',
  read_count        INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '阅读量(总)',
  like_count        INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '点赞数量',
  comment_count     INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '评论量',
  favorite_count    INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '收藏数量',
  share_count       INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '转发数量',
  avg_read_progress DECIMAL(5,2)     NULL     COMMENT '平均阅读进度(%) 如61.00',
  bounce_rate       DECIMAL(5,2)     NULL     COMMENT '跳出率(%) 如13.20',
  avg_read_seconds  INT UNSIGNED     NULL     COMMENT '平均阅读停留时长(秒)',
  recommend_shares  INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '推荐渠道转发量',
  fan_read_count    INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '粉丝阅读量',
  created_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  UNIQUE INDEX uk_article_date (article_id, stat_date),  -- 防止同一天重复统计
  INDEX idx_stat_date (stat_date),                        -- 按日期范围查询

  CONSTRAINT fk_stats_article
    FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章每日统计数据(含阅读/点赞/收藏/转发/评论等指标)';


-- ============================================================
-- 7. 阅读来源分析表
-- 说明: 记录每篇文章各阅读来源的占比
--       对应前端"阅读来源分析"环形图
--       来源: 推荐 / 频道 / 相关阅读 / 应用外阅读 / 其他
-- ============================================================
CREATE TABLE article_read_sources (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '来源记录ID',
  article_id    BIGINT UNSIGNED  NOT NULL COMMENT '文章ID',
  stat_date     DATE             NOT NULL COMMENT '统计日期',
  source_type   TINYINT          NOT NULL DEFAULT 0 COMMENT '来源类型: 0推荐 1频道 2相关阅读 3应用外 4其他',
  read_count    INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '该来源阅读量',
  percentage    DECIMAL(5,2)     NOT NULL DEFAULT 0.00 COMMENT '该来源占比(%)',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  UNIQUE INDEX uk_article_date_source (article_id, stat_date, source_type),
  INDEX idx_stat_date (stat_date),

  CONSTRAINT fk_source_article
    FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章阅读来源分析(推荐/频道/相关阅读/应用外/其他)';


-- ============================================================
-- 8. 阅读完成度分析表
-- 说明: 记录各完成度区间的用户分布
--       对应前端"阅读完成度分析"环形图
--       区间: 20%以下 / 20%-80% / 80%以上
-- ============================================================
CREATE TABLE article_read_completion (
  id               BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '完成度记录ID',
  article_id       BIGINT UNSIGNED  NOT NULL COMMENT '文章ID',
  stat_date        DATE             NOT NULL COMMENT '统计日期',
  completion_range TINYINT          NOT NULL DEFAULT 0 COMMENT '完成度区间: 0低于20% 1介于20-80% 2高于80%',
  user_count       INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '该区间用户数',
  percentage       DECIMAL(5,2)     NOT NULL DEFAULT 0.00 COMMENT '该区间占比(%)',
  created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  UNIQUE INDEX uk_article_date_range (article_id, stat_date, completion_range),
  INDEX idx_stat_date (stat_date),

  CONSTRAINT fk_completion_article
    FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章阅读完成度分析(<20% / 20%-80% / >80%)';


-- ============================================================
-- 9. 粉丝表
-- 说明: 存储关注了某位自媒体作者的粉丝信息
--       支持拉黑功能, 加载更多分页
-- ============================================================
CREATE TABLE fans (
  id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '粉丝记录ID',
  user_id      BIGINT UNSIGNED  NOT NULL COMMENT '自媒体作者ID(被关注者)',
  fan_name     VARCHAR(64)      NOT NULL COMMENT '粉丝用户名/昵称',
  fan_avatar   VARCHAR(500)     NULL     COMMENT '粉丝头像URL',
  is_blocked   TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '拉黑标记: 1=已拉黑 0=正常',
  followed_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  created_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  INDEX idx_user_id (user_id),                      -- 按作者查询粉丝
  INDEX idx_user_blocked (user_id, is_blocked),     -- 按作者+拉黑状态筛选
  INDEX idx_followed_at (followed_at),              -- 按关注时间排序
  INDEX idx_user_followed (user_id, followed_at),   -- 作者+关注时间组合

  CONSTRAINT fk_fan_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='粉丝列表(支持拉黑/发消息)';


-- ============================================================
-- 10. 粉丝每日统计表
-- 说明: 存储粉丝维度的每日汇总数据
--       对应前端"粉丝概况"页面4个统计卡片 + 数据列表
-- ============================================================
CREATE TABLE fan_stats_daily (
  id               BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '统计记录ID',
  user_id          BIGINT UNSIGNED  NOT NULL COMMENT '自媒体作者ID',
  stat_date        DATE             NOT NULL COMMENT '统计日期',
  total_fan_count  INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '累计粉丝总数',
  fan_read_count   INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '粉丝累计阅读量',
  fan_revenue      DECIMAL(12,2)    NOT NULL DEFAULT 0.00 COMMENT '粉丝收益(元)',
  unfollow_count   INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '取消关注量',
  new_follow_count INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '新增关注量',
  created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  UNIQUE INDEX uk_user_date (user_id, stat_date),   -- 防止同一天重复统计
  INDEX idx_stat_date (stat_date),                   -- 按日期范围查询

  CONSTRAINT fk_fan_stats_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='粉丝每日统计数据(粉丝数/阅读量/收益/取关量)';


-- ============================================================
-- 11. 粉丝阅读量小时趋势表
-- 说明: 按小时粒度记录粉丝阅读量变化
--       对应前端"阅读量趋势图"(折线图, 横轴小时/纵轴阅读量)
-- ============================================================
CREATE TABLE fan_read_hourly (
  id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '趋势记录ID',
  user_id     BIGINT UNSIGNED  NOT NULL COMMENT '自媒体作者ID',
  stat_date   DATE             NOT NULL COMMENT '统计日期',
  hour        TINYINT UNSIGNED NOT NULL COMMENT '小时(0-23 对应00:00-23:00)',
  read_count  INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '该小时阅读量',
  created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  UNIQUE INDEX uk_user_date_hour (user_id, stat_date, hour),
  INDEX idx_stat_date (stat_date),

  CONSTRAINT fk_hourly_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='粉丝阅读量小时趋势数据(折线图)';


-- ============================================================
-- 12. 粉丝画像数据表
-- 说明: 采用 dimension+key 宽表设计，一条记录存储一个画像维度的一个值
--       对应前端"粉丝画像"页面:
--         - 性别分布(环形图): 0 → male / female
--         - 年龄分布(柱状图): 1 → 0-17 / 18-23 / 24-30 / 31-40 / 41-50 / 50+
--         - 地域分布(地图):   2 → 广东 / 北京 / ...
--         - 终端分布(环形图): 3 → iOS / Android / PC
--         - 活跃时间(柱状图): 4 → 0-2时 / 2-4时 / ...
--         - 内容偏好(柱状图): 5 → 大数据 / AI / ...
-- ============================================================
CREATE TABLE fan_portrait_data (
  id              BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '画像记录ID',
  user_id         BIGINT UNSIGNED  NOT NULL COMMENT '自媒体作者ID',
  stat_date       DATE             NOT NULL COMMENT '统计日期',
  dimension       TINYINT          NOT NULL COMMENT '画像维度: 0性别 1年龄 2地域 3终端 4活跃时间 5内容偏好',
  dimension_key   VARCHAR(64)      NOT NULL COMMENT '维度具体值 如: male / 18-23 / 广东 / iOS',
  dimension_value INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '数量',
  percentage      DECIMAL(5,2)     NULL     COMMENT '占比(%) 如 68.00',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  UNIQUE INDEX uk_user_date_dim_key (user_id, stat_date, dimension, dimension_key),
  INDEX idx_stat_date (stat_date),
  INDEX idx_dimension (dimension),

  CONSTRAINT fk_portrait_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='粉丝画像数据(性别/年龄/地域/终端/活跃时间/内容偏好)';


-- ============================================================
-- 13. 用户协议确认记录表
-- 说明: 记录用户同意协议和隐私政策的历史
--       对应登录页"我已阅读并同意用户协议和隐私政策条款"
-- ============================================================
CREATE TABLE user_agreement_logs (
  id             BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '记录ID',
  user_id        BIGINT UNSIGNED  NOT NULL COMMENT '用户ID',
  agreement_type TINYINT          NOT NULL DEFAULT 0 COMMENT '协议类型: 0用户协议 1隐私政策',
  agreed_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '同意时间',
  ip_address     VARCHAR(45)      NULL     COMMENT '客户端IP地址',

  INDEX idx_user_id (user_id),
  INDEX idx_agreed_at (agreed_at),

  CONSTRAINT fk_agreement_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='用户协议和隐私政策确认记录';


-- ============================================================
-- 14. 粉丝私信消息表
-- 说明: 存储自媒体作者向粉丝发送的私信消息
--       对应粉丝列表卡片上的"发消息"按钮
-- ============================================================
CREATE TABLE fan_messages (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '消息ID',
  user_id     BIGINT UNSIGNED NOT NULL COMMENT '发送者(自媒体作者)ID',
  fan_id      BIGINT UNSIGNED NOT NULL COMMENT '接收者(粉丝)ID',
  content     TEXT            NOT NULL COMMENT '消息内容',
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',

  INDEX idx_user_fan (user_id, fan_id),     -- 查询双方对话
  INDEX idx_created_at (created_at),        -- 按时间排序

  CONSTRAINT fk_msg_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_msg_fan
    FOREIGN KEY (fan_id) REFERENCES fans(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='粉丝私信消息记录';


-- ============================================================
-- 15. 审核记录表 (扩展)
-- 说明: 记录文章每次审核的完整历史
--       对应内容列表的审核流程追踪
-- ============================================================
CREATE TABLE article_review_logs (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '审核记录ID',
  article_id    BIGINT UNSIGNED  NOT NULL COMMENT '文章ID',
  reviewer_id   BIGINT UNSIGNED  NULL     COMMENT '审核人ID(系统自动审核为NULL)',
  from_status   TINYINT          NOT NULL COMMENT '审核前状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  to_status     TINYINT          NOT NULL COMMENT '审核后状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  comment       VARCHAR(500)     NULL     COMMENT '审核意见(驳回原因等)',
  reviewed_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '审核时间',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  INDEX idx_article_id (article_id),
  INDEX idx_reviewed_at (reviewed_at),

  CONSTRAINT fk_review_article
    FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='文章审核记录历史';


-- ============================================================
-- 初始化数据: 频道
-- ============================================================
INSERT INTO channels (name, description, sort_order) VALUES
('科技',   '科技领域资讯与深度分析',   1),
('娱乐',   '娱乐新闻与明星动态',       2),
('体育',   '体育赛事与运动资讯',       3),
('财经',   '财经新闻与投资理财',       4),
('军事',   '军事动态与国防科技',       5),
('汽车',   '汽车行业与新车评测',       6),
('健康',   '健康养生与医疗资讯',       7),
('教育',   '教育政策与学习方法',       8),
('美食',   '美食推荐与烹饪技巧',       9),
('旅游',   '旅游攻略与景点推荐',      10);
