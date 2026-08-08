/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80031 (8.0.31)
 Source Host           : localhost:3306
 Source Schema         : heima_news

 Target Server Type    : MySQL
 Target Server Version : 80031 (8.0.31)
 File Encoding         : 65001

 Date: 25/06/2026 18:25:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article_cover_images
-- ----------------------------
DROP TABLE IF EXISTS `article_cover_images`;
CREATE TABLE `article_cover_images`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章ID',
  `material_id` bigint UNSIGNED NOT NULL COMMENT '素材ID(封面图片)',
  `sort_order` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序(单图=0, 三图依次=0/1/2)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE,
  INDEX `idx_material_id`(`material_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章封面关联表(关联素材表,支持单图/三图)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_cover_images
-- ----------------------------
INSERT INTO `article_cover_images` VALUES (1, 3, 2, 0, '2026-06-23 19:24:41');
INSERT INTO `article_cover_images` VALUES (2, 4, 5, 0, '2026-06-23 19:27:37');
INSERT INTO `article_cover_images` VALUES (3, 4, 4, 1, '2026-06-23 19:27:37');
INSERT INTO `article_cover_images` VALUES (4, 4, 1, 2, '2026-06-23 19:27:37');
INSERT INTO `article_cover_images` VALUES (5, 5, 3, 0, '2026-06-23 19:28:09');
INSERT INTO `article_cover_images` VALUES (6, 7, 4, 0, '2026-06-23 19:29:41');
INSERT INTO `article_cover_images` VALUES (7, 8, 5, 0, '2026-06-23 19:30:12');
INSERT INTO `article_cover_images` VALUES (8, 11, 5, 0, '2026-06-24 18:38:02');

-- ----------------------------
-- Table structure for article_read_completion
-- ----------------------------
DROP TABLE IF EXISTS `article_read_completion`;
CREATE TABLE `article_read_completion`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '完成度记录ID',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `completion_range` tinyint NOT NULL DEFAULT 0 COMMENT '完成度: 0低于20% 1介于20-80% 2高于80%',
  `user_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '该区间用户数',
  `percentage` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '该区间占比(%)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_date_range`(`article_id` ASC, `stat_date` ASC, `completion_range` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章阅读完成度分析(<20% / 20%-80% / >80%)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_read_completion
-- ----------------------------
INSERT INTO `article_read_completion` VALUES (1, 3, '2026-06-15', 1, 31, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (2, 3, '2026-06-15', 2, 58, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (3, 3, '2026-06-15', 0, 26, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (4, 3, '2026-06-16', 1, 27, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (5, 3, '2026-06-16', 2, 43, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (6, 3, '2026-06-16', 0, 25, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (7, 3, '2026-06-17', 1, 48, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (8, 3, '2026-06-17', 2, 69, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (9, 3, '2026-06-17', 0, 37, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (10, 3, '2026-06-18', 1, 53, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (11, 3, '2026-06-18', 2, 83, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (12, 3, '2026-06-18', 0, 45, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (13, 3, '2026-06-19', 1, 40, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (14, 3, '2026-06-19', 2, 71, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (15, 3, '2026-06-19', 0, 32, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (16, 3, '2026-06-20', 1, 55, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (17, 3, '2026-06-20', 2, 79, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (18, 3, '2026-06-20', 0, 46, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (19, 3, '2026-06-21', 1, 60, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (20, 3, '2026-06-21', 2, 90, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (21, 3, '2026-06-21', 0, 43, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (22, 3, '2026-06-22', 1, 33, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (23, 3, '2026-06-22', 2, 43, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (24, 3, '2026-06-22', 0, 29, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (25, 3, '2026-06-23', 1, 35, 0.30, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (26, 3, '2026-06-23', 2, 56, 0.45, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (27, 3, '2026-06-23', 0, 27, 0.25, '2026-06-23 21:33:53');
INSERT INTO `article_read_completion` VALUES (40, 4, '2026-06-15', 1, 62, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (41, 4, '2026-06-15', 2, 82, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (42, 4, '2026-06-15', 0, 49, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (43, 4, '2026-06-16', 1, 59, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (44, 4, '2026-06-16', 2, 85, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (45, 4, '2026-06-16', 0, 46, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (46, 4, '2026-06-17', 1, 54, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (47, 4, '2026-06-17', 2, 86, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (48, 4, '2026-06-17', 0, 50, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (49, 4, '2026-06-18', 1, 62, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (50, 4, '2026-06-18', 2, 84, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (51, 4, '2026-06-18', 0, 51, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (52, 4, '2026-06-19', 1, 34, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (53, 4, '2026-06-19', 2, 58, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (54, 4, '2026-06-19', 0, 31, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (55, 4, '2026-06-20', 1, 56, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (56, 4, '2026-06-20', 2, 90, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (57, 4, '2026-06-20', 0, 42, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (58, 4, '2026-06-21', 1, 40, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (59, 4, '2026-06-21', 2, 64, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (60, 4, '2026-06-21', 0, 33, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (61, 4, '2026-06-22', 1, 27, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (62, 4, '2026-06-22', 2, 41, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (63, 4, '2026-06-22', 0, 28, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (64, 4, '2026-06-23', 1, 62, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (65, 4, '2026-06-23', 2, 86, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (66, 4, '2026-06-23', 0, 46, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_completion` VALUES (67, 5, '2026-06-15', 1, 39, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (68, 5, '2026-06-15', 2, 63, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (69, 5, '2026-06-15', 0, 31, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (70, 5, '2026-06-16', 1, 50, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (71, 5, '2026-06-16', 2, 83, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (72, 5, '2026-06-16', 0, 41, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (73, 5, '2026-06-17', 1, 60, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (74, 5, '2026-06-17', 2, 93, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (75, 5, '2026-06-17', 0, 48, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (76, 5, '2026-06-18', 1, 53, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (77, 5, '2026-06-18', 2, 72, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (78, 5, '2026-06-18', 0, 43, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (79, 5, '2026-06-19', 1, 46, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (80, 5, '2026-06-19', 2, 62, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (81, 5, '2026-06-19', 0, 41, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (82, 5, '2026-06-20', 1, 30, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (83, 5, '2026-06-20', 2, 48, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (84, 5, '2026-06-20', 0, 30, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (85, 5, '2026-06-21', 1, 49, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (86, 5, '2026-06-21', 2, 72, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (87, 5, '2026-06-21', 0, 38, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (88, 5, '2026-06-22', 1, 40, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (89, 5, '2026-06-22', 2, 58, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (90, 5, '2026-06-22', 0, 30, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (91, 5, '2026-06-23', 1, 52, 0.30, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (92, 5, '2026-06-23', 2, 84, 0.45, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (93, 5, '2026-06-23', 0, 49, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_completion` VALUES (94, 6, '2026-06-15', 1, 43, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (95, 6, '2026-06-15', 2, 61, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (96, 6, '2026-06-15', 0, 27, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (97, 6, '2026-06-16', 1, 42, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (98, 6, '2026-06-16', 2, 51, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (99, 6, '2026-06-16', 0, 26, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (100, 6, '2026-06-17', 1, 42, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (101, 6, '2026-06-17', 2, 61, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (102, 6, '2026-06-17', 0, 32, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (103, 6, '2026-06-18', 1, 57, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (104, 6, '2026-06-18', 2, 87, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (105, 6, '2026-06-18', 0, 49, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (106, 6, '2026-06-19', 1, 33, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (107, 6, '2026-06-19', 2, 57, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (108, 6, '2026-06-19', 0, 30, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (109, 6, '2026-06-20', 1, 51, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (110, 6, '2026-06-20', 2, 65, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (111, 6, '2026-06-20', 0, 42, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (112, 6, '2026-06-21', 1, 31, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (113, 6, '2026-06-21', 2, 55, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (114, 6, '2026-06-21', 0, 32, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (115, 6, '2026-06-22', 1, 29, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (116, 6, '2026-06-22', 2, 51, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (117, 6, '2026-06-22', 0, 33, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (118, 6, '2026-06-23', 1, 44, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (119, 6, '2026-06-23', 2, 61, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_completion` VALUES (120, 6, '2026-06-23', 0, 35, 0.25, '2026-06-23 21:47:04');

-- ----------------------------
-- Table structure for article_read_sources
-- ----------------------------
DROP TABLE IF EXISTS `article_read_sources`;
CREATE TABLE `article_read_sources`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '来源记录ID',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `source_type` tinyint NOT NULL DEFAULT 0 COMMENT '来源类型: 0推荐 1频道 2相关阅读 3应用外 4其他',
  `read_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '该来源阅读量',
  `percentage` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '该来源占比(%)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_date_source`(`article_id` ASC, `stat_date` ASC, `source_type` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章阅读来源分析(推荐/频道/相关阅读/应用外/其他)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_read_sources
-- ----------------------------
INSERT INTO `article_read_sources` VALUES (1, 3, '2026-06-15', 1, 32, 0.41, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (2, 3, '2026-06-15', 2, 19, 0.24, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (3, 3, '2026-06-15', 3, 10, 0.13, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (4, 3, '2026-06-15', 4, 7, 0.09, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (5, 3, '2026-06-15', 0, 10, 0.13, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (6, 3, '2026-06-16', 1, 74, 0.38, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (7, 3, '2026-06-16', 2, 41, 0.21, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (8, 3, '2026-06-16', 3, 23, 0.12, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (9, 3, '2026-06-16', 4, 11, 0.06, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (10, 3, '2026-06-16', 0, 29, 0.15, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (11, 3, '2026-06-17', 1, 34, 0.42, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (12, 3, '2026-06-17', 2, 22, 0.27, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (13, 3, '2026-06-17', 3, 12, 0.15, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (14, 3, '2026-06-17', 4, 9, 0.12, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (15, 3, '2026-06-17', 0, 8, 0.10, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (16, 3, '2026-06-18', 1, 105, 0.43, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (17, 3, '2026-06-18', 2, 63, 0.26, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (18, 3, '2026-06-18', 3, 49, 0.20, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (19, 3, '2026-06-18', 4, 12, 0.05, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (20, 3, '2026-06-18', 0, 29, 0.12, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (21, 3, '2026-06-19', 1, 18, 0.35, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (22, 3, '2026-06-19', 2, 15, 0.28, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (23, 3, '2026-06-19', 3, 5, 0.11, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (24, 3, '2026-06-19', 4, 6, 0.12, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (25, 3, '2026-06-19', 0, 8, 0.15, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (26, 3, '2026-06-20', 1, 118, 0.41, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (27, 3, '2026-06-20', 2, 81, 0.28, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (28, 3, '2026-06-20', 3, 37, 0.13, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (29, 3, '2026-06-20', 4, 40, 0.14, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (30, 3, '2026-06-20', 0, 37, 0.13, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (31, 3, '2026-06-21', 1, 69, 0.36, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (32, 3, '2026-06-21', 2, 46, 0.24, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (33, 3, '2026-06-21', 3, 34, 0.18, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (34, 3, '2026-06-21', 4, 13, 0.07, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (35, 3, '2026-06-21', 0, 17, 0.09, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (36, 3, '2026-06-22', 1, 57, 0.40, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (37, 3, '2026-06-22', 2, 31, 0.22, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (38, 3, '2026-06-22', 3, 18, 0.13, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (39, 3, '2026-06-22', 4, 17, 0.12, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (40, 3, '2026-06-22', 0, 7, 0.05, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (41, 3, '2026-06-23', 1, 111, 0.40, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (42, 3, '2026-06-23', 2, 63, 0.23, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (43, 3, '2026-06-23', 3, 30, 0.11, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (44, 3, '2026-06-23', 4, 22, 0.08, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (45, 3, '2026-06-23', 0, 22, 0.08, '2026-06-23 21:33:53');
INSERT INTO `article_read_sources` VALUES (66, 4, '2026-06-15', 1, 22, 0.45, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (67, 4, '2026-06-15', 2, 10, 0.21, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (68, 4, '2026-06-15', 3, 9, 0.19, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (69, 4, '2026-06-15', 4, 4, 0.08, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (70, 4, '2026-06-15', 0, 5, 0.11, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (71, 4, '2026-06-16', 1, 98, 0.41, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (72, 4, '2026-06-16', 2, 60, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (73, 4, '2026-06-16', 3, 26, 0.11, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (74, 4, '2026-06-16', 4, 12, 0.05, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (75, 4, '2026-06-16', 0, 31, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (76, 4, '2026-06-17', 1, 30, 0.40, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (77, 4, '2026-06-17', 2, 15, 0.20, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (78, 4, '2026-06-17', 3, 10, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (79, 4, '2026-06-17', 4, 3, 0.05, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (80, 4, '2026-06-17', 0, 10, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (81, 4, '2026-06-18', 1, 69, 0.37, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (82, 4, '2026-06-18', 2, 47, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (83, 4, '2026-06-18', 3, 24, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (84, 4, '2026-06-18', 4, 15, 0.08, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (85, 4, '2026-06-18', 0, 15, 0.08, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (86, 4, '2026-06-19', 1, 78, 0.43, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (87, 4, '2026-06-19', 2, 43, 0.24, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (88, 4, '2026-06-19', 3, 18, 0.10, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (89, 4, '2026-06-19', 4, 25, 0.14, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (90, 4, '2026-06-19', 0, 27, 0.15, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (91, 4, '2026-06-20', 1, 64, 0.36, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (92, 4, '2026-06-20', 2, 45, 0.25, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (93, 4, '2026-06-20', 3, 25, 0.14, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (94, 4, '2026-06-20', 4, 18, 0.10, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (95, 4, '2026-06-20', 0, 25, 0.14, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (96, 4, '2026-06-21', 1, 52, 0.43, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (97, 4, '2026-06-21', 2, 35, 0.29, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (98, 4, '2026-06-21', 3, 13, 0.11, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (99, 4, '2026-06-21', 4, 17, 0.14, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (100, 4, '2026-06-21', 0, 9, 0.08, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (101, 4, '2026-06-22', 1, 89, 0.37, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (102, 4, '2026-06-22', 2, 72, 0.30, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (103, 4, '2026-06-22', 3, 31, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (104, 4, '2026-06-22', 4, 21, 0.09, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (105, 4, '2026-06-22', 0, 36, 0.15, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (106, 4, '2026-06-23', 1, 61, 0.41, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (107, 4, '2026-06-23', 2, 42, 0.28, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (108, 4, '2026-06-23', 3, 19, 0.13, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (109, 4, '2026-06-23', 4, 10, 0.07, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (110, 4, '2026-06-23', 0, 7, 0.05, '2026-06-23 21:46:53');
INSERT INTO `article_read_sources` VALUES (111, 5, '2026-06-15', 1, 114, 0.39, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (112, 5, '2026-06-15', 2, 84, 0.29, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (113, 5, '2026-06-15', 3, 35, 0.12, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (114, 5, '2026-06-15', 4, 14, 0.05, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (115, 5, '2026-06-15', 0, 14, 0.05, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (116, 5, '2026-06-16', 1, 89, 0.37, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (117, 5, '2026-06-16', 2, 65, 0.27, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (118, 5, '2026-06-16', 3, 48, 0.20, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (119, 5, '2026-06-16', 4, 31, 0.13, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (120, 5, '2026-06-16', 0, 29, 0.12, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (121, 5, '2026-06-17', 1, 37, 0.38, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (122, 5, '2026-06-17', 2, 24, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (123, 5, '2026-06-17', 3, 16, 0.17, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (124, 5, '2026-06-17', 4, 13, 0.14, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (125, 5, '2026-06-17', 0, 8, 0.09, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (126, 5, '2026-06-18', 1, 60, 0.37, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (127, 5, '2026-06-18', 2, 32, 0.20, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (128, 5, '2026-06-18', 3, 29, 0.18, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (129, 5, '2026-06-18', 4, 21, 0.13, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (130, 5, '2026-06-18', 0, 11, 0.07, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (131, 5, '2026-06-19', 1, 126, 0.44, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (132, 5, '2026-06-19', 2, 72, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (133, 5, '2026-06-19', 3, 48, 0.17, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (134, 5, '2026-06-19', 4, 17, 0.06, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (135, 5, '2026-06-19', 0, 34, 0.12, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (136, 5, '2026-06-20', 1, 21, 0.40, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (137, 5, '2026-06-20', 2, 11, 0.21, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (138, 5, '2026-06-20', 3, 8, 0.15, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (139, 5, '2026-06-20', 4, 8, 0.15, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (140, 5, '2026-06-20', 0, 4, 0.09, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (141, 5, '2026-06-21', 1, 54, 0.35, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (142, 5, '2026-06-21', 2, 39, 0.25, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (143, 5, '2026-06-21', 3, 17, 0.11, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (144, 5, '2026-06-21', 4, 7, 0.05, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (145, 5, '2026-06-21', 0, 20, 0.13, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (146, 5, '2026-06-22', 1, 68, 0.35, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (147, 5, '2026-06-22', 2, 47, 0.24, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (148, 5, '2026-06-22', 3, 29, 0.15, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (149, 5, '2026-06-22', 4, 27, 0.14, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (150, 5, '2026-06-22', 0, 21, 0.11, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (151, 5, '2026-06-23', 1, 22, 0.38, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (152, 5, '2026-06-23', 2, 11, 0.20, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (153, 5, '2026-06-23', 3, 10, 0.18, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (154, 5, '2026-06-23', 4, 4, 0.07, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (155, 5, '2026-06-23', 0, 4, 0.08, '2026-06-23 21:46:59');
INSERT INTO `article_read_sources` VALUES (156, 6, '2026-06-15', 1, 119, 0.41, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (157, 6, '2026-06-15', 2, 64, 0.22, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (158, 6, '2026-06-15', 3, 29, 0.10, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (159, 6, '2026-06-15', 4, 40, 0.14, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (160, 6, '2026-06-15', 0, 37, 0.13, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (161, 6, '2026-06-16', 1, 101, 0.39, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (162, 6, '2026-06-16', 2, 78, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (163, 6, '2026-06-16', 3, 52, 0.20, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (164, 6, '2026-06-16', 4, 36, 0.14, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (165, 6, '2026-06-16', 0, 28, 0.11, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (166, 6, '2026-06-17', 1, 44, 0.36, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (167, 6, '2026-06-17', 2, 33, 0.27, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (168, 6, '2026-06-17', 3, 19, 0.16, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (169, 6, '2026-06-17', 4, 8, 0.07, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (170, 6, '2026-06-17', 0, 16, 0.13, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (171, 6, '2026-06-18', 1, 52, 0.38, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (172, 6, '2026-06-18', 2, 31, 0.23, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (173, 6, '2026-06-18', 3, 25, 0.18, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (174, 6, '2026-06-18', 4, 6, 0.05, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (175, 6, '2026-06-18', 0, 18, 0.13, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (176, 6, '2026-06-19', 1, 57, 0.40, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (177, 6, '2026-06-19', 2, 28, 0.20, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (178, 6, '2026-06-19', 3, 17, 0.12, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (179, 6, '2026-06-19', 4, 8, 0.06, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (180, 6, '2026-06-19', 0, 17, 0.12, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (181, 6, '2026-06-20', 1, 49, 0.45, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (182, 6, '2026-06-20', 2, 28, 0.26, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (183, 6, '2026-06-20', 3, 19, 0.18, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (184, 6, '2026-06-20', 4, 16, 0.15, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (185, 6, '2026-06-20', 0, 10, 0.10, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (186, 6, '2026-06-21', 1, 43, 0.37, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (187, 6, '2026-06-21', 2, 29, 0.25, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (188, 6, '2026-06-21', 3, 20, 0.17, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (189, 6, '2026-06-21', 4, 12, 0.11, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (190, 6, '2026-06-21', 0, 9, 0.08, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (191, 6, '2026-06-22', 1, 33, 0.44, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (192, 6, '2026-06-22', 2, 22, 0.30, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (193, 6, '2026-06-22', 3, 7, 0.10, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (194, 6, '2026-06-22', 4, 9, 0.12, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (195, 6, '2026-06-22', 0, 9, 0.13, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (196, 6, '2026-06-23', 1, 52, 0.38, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (197, 6, '2026-06-23', 2, 35, 0.26, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (198, 6, '2026-06-23', 3, 20, 0.15, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (199, 6, '2026-06-23', 4, 6, 0.05, '2026-06-23 21:47:04');
INSERT INTO `article_read_sources` VALUES (200, 6, '2026-06-23', 0, 9, 0.07, '2026-06-23 21:47:04');

-- ----------------------------
-- Table structure for article_review_logs
-- ----------------------------
DROP TABLE IF EXISTS `article_review_logs`;
CREATE TABLE `article_review_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '审核记录ID',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章ID',
  `reviewer_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '审核人ID(系统自动审核为NULL)',
  `from_status` tinyint NOT NULL COMMENT '变更前状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  `to_status` tinyint NOT NULL COMMENT '变更后状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见(驳回原因等)',
  `reviewed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '审核时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE,
  INDEX `idx_reviewed_at`(`reviewed_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章审核记录历史' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_review_logs
-- ----------------------------
INSERT INTO `article_review_logs` VALUES (1, 3, NULL, 1, 2, NULL, '2026-06-23 19:24:52', '2026-06-23 19:24:51');
INSERT INTO `article_review_logs` VALUES (2, 4, NULL, 1, 2, NULL, '2026-06-23 19:27:38', '2026-06-23 19:27:37');
INSERT INTO `article_review_logs` VALUES (3, 5, NULL, 1, 2, NULL, '2026-06-23 19:28:09', '2026-06-23 19:28:09');
INSERT INTO `article_review_logs` VALUES (4, 6, NULL, 1, 2, NULL, '2026-06-23 19:28:47', '2026-06-23 19:28:46');
INSERT INTO `article_review_logs` VALUES (5, 7, NULL, 1, 2, NULL, '2026-06-23 19:29:41', '2026-06-23 19:29:41');
INSERT INTO `article_review_logs` VALUES (6, 10, NULL, 1, 2, NULL, '2026-06-23 19:59:25', '2026-06-23 19:59:25');
INSERT INTO `article_review_logs` VALUES (7, 3, NULL, 2, 3, '测试审核通过', '2026-06-23 20:50:45', '2026-06-23 20:50:45');
INSERT INTO `article_review_logs` VALUES (8, 3, NULL, 3, 5, NULL, '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (9, 4, NULL, 2, 3, '测试审核通过', '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (10, 4, NULL, 3, 5, NULL, '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (11, 5, NULL, 2, 3, '测试审核通过', '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (12, 5, NULL, 3, 5, NULL, '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (13, 6, NULL, 2, 3, '测试审核通过', '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (14, 6, NULL, 3, 5, NULL, '2026-06-23 20:50:49', '2026-06-23 20:50:48');
INSERT INTO `article_review_logs` VALUES (15, 11, NULL, 0, 1, NULL, '2026-06-24 18:38:18', '2026-06-24 18:38:17');
INSERT INTO `article_review_logs` VALUES (16, 11, NULL, 1, 2, '测试审核通过', '2026-06-24 18:39:49', '2026-06-24 18:39:48');
INSERT INTO `article_review_logs` VALUES (17, 11, NULL, 2, 4, NULL, '2026-06-24 18:39:49', '2026-06-24 18:39:48');
INSERT INTO `article_review_logs` VALUES (18, 6, NULL, 5, 4, NULL, '2026-06-24 18:40:30', '2026-06-24 18:40:29');
INSERT INTO `article_review_logs` VALUES (19, 4, NULL, 5, 4, NULL, '2026-06-24 18:40:33', '2026-06-24 18:40:32');
INSERT INTO `article_review_logs` VALUES (20, 3, NULL, 5, 4, NULL, '2026-06-24 18:40:35', '2026-06-24 18:40:35');
INSERT INTO `article_review_logs` VALUES (21, 5, NULL, 5, 4, NULL, '2026-06-24 18:40:37', '2026-06-24 18:40:37');

-- ----------------------------
-- Table structure for article_stats_daily
-- ----------------------------
DROP TABLE IF EXISTS `article_stats_daily`;
CREATE TABLE `article_stats_daily`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计记录ID',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `read_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '阅读量(总)',
  `like_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数量',
  `comment_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论量',
  `favorite_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '收藏数量',
  `share_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '转发数量',
  `avg_read_progress` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均阅读进度(%) 如61.00',
  `bounce_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '跳出率(%) 如13.20',
  `avg_read_seconds` int UNSIGNED NULL DEFAULT NULL COMMENT '平均阅读停留时长(秒)',
  `recommend_shares` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '推荐渠道转发量',
  `fan_read_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '粉丝阅读量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_article_date`(`article_id` ASC, `stat_date` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章每日统计数据(含阅读/点赞/收藏/转发/评论等指标)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_stats_daily
-- ----------------------------
INSERT INTO `article_stats_daily` VALUES (1, 3, '2026-06-15', 80, 14, 4, 4, 4, 0.43, 0.42, 98, 3, 86, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (2, 3, '2026-06-16', 196, 8, 8, 4, 1, 0.84, 0.12, 103, 1, 71, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (3, 3, '2026-06-17', 83, 25, 4, 3, 6, 0.51, 0.16, 99, 4, 71, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (4, 3, '2026-06-18', 246, 28, 9, 10, 4, 0.41, 0.39, 106, 1, 83, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (5, 3, '2026-06-19', 54, 6, 6, 10, 3, 0.73, 0.17, 32, 5, 25, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (6, 3, '2026-06-20', 290, 11, 10, 8, 6, 0.78, 0.34, 135, 5, 35, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (7, 3, '2026-06-21', 194, 29, 12, 2, 8, 0.53, 0.48, 39, 1, 33, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (8, 3, '2026-06-22', 143, 14, 2, 5, 4, 0.49, 0.13, 121, 2, 66, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (9, 3, '2026-06-23', 278, 11, 6, 3, 3, 0.60, 0.13, 100, 4, 41, '2026-06-23 21:33:53', '2026-06-23 21:33:53');
INSERT INTO `article_stats_daily` VALUES (14, 4, '2026-06-15', 51, 12, 15, 1, 4, 0.46, 0.30, 68, 5, 96, '2026-06-23 21:46:52', '2026-06-23 21:46:52');
INSERT INTO `article_stats_daily` VALUES (15, 4, '2026-06-16', 240, 11, 13, 3, 8, 0.38, 0.19, 85, 5, 83, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (16, 4, '2026-06-17', 77, 5, 13, 8, 7, 0.83, 0.33, 98, 1, 80, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (17, 4, '2026-06-18', 188, 25, 5, 6, 5, 0.77, 0.13, 96, 4, 32, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (18, 4, '2026-06-19', 183, 6, 15, 3, 8, 0.32, 0.16, 34, 3, 65, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (19, 4, '2026-06-20', 180, 16, 3, 7, 7, 0.81, 0.19, 57, 4, 89, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (20, 4, '2026-06-21', 123, 11, 11, 2, 7, 0.52, 0.33, 86, 1, 57, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (21, 4, '2026-06-22', 243, 16, 7, 9, 2, 0.63, 0.18, 112, 3, 85, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (22, 4, '2026-06-23', 151, 21, 14, 10, 5, 0.84, 0.42, 45, 2, 11, '2026-06-23 21:46:53', '2026-06-23 21:46:53');
INSERT INTO `article_stats_daily` VALUES (23, 5, '2026-06-15', 293, 8, 4, 7, 1, 0.76, 0.23, 151, 3, 26, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (24, 5, '2026-06-16', 242, 17, 2, 1, 6, 0.42, 0.15, 90, 5, 97, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (25, 5, '2026-06-17', 98, 8, 5, 10, 8, 0.51, 0.41, 47, 5, 57, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (26, 5, '2026-06-18', 163, 14, 4, 7, 3, 0.78, 0.35, 100, 5, 60, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (27, 5, '2026-06-19', 288, 27, 15, 5, 7, 0.68, 0.35, 125, 4, 42, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (28, 5, '2026-06-20', 54, 22, 5, 2, 2, 0.82, 0.12, 164, 2, 87, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (29, 5, '2026-06-21', 156, 29, 15, 9, 6, 0.74, 0.44, 77, 3, 13, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (30, 5, '2026-06-22', 197, 22, 5, 9, 5, 0.81, 0.48, 143, 3, 53, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (31, 5, '2026-06-23', 59, 28, 10, 2, 6, 0.68, 0.41, 161, 4, 77, '2026-06-23 21:46:59', '2026-06-23 21:46:59');
INSERT INTO `article_stats_daily` VALUES (32, 6, '2026-06-15', 291, 26, 13, 1, 8, 0.82, 0.32, 46, 1, 90, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (33, 6, '2026-06-16', 260, 16, 13, 7, 3, 0.42, 0.36, 48, 1, 53, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (34, 6, '2026-06-17', 124, 8, 2, 5, 3, 0.56, 0.25, 108, 3, 41, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (35, 6, '2026-06-18', 139, 28, 9, 8, 1, 0.46, 0.17, 54, 4, 69, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (36, 6, '2026-06-19', 143, 7, 5, 2, 1, 0.52, 0.34, 105, 1, 24, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (37, 6, '2026-06-20', 109, 6, 5, 4, 8, 0.60, 0.16, 94, 2, 69, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (38, 6, '2026-06-21', 118, 11, 8, 7, 7, 0.79, 0.48, 180, 1, 63, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (39, 6, '2026-06-22', 76, 10, 4, 7, 6, 0.75, 0.32, 129, 2, 75, '2026-06-23 21:47:04', '2026-06-23 21:47:04');
INSERT INTO `article_stats_daily` VALUES (40, 6, '2026-06-23', 137, 24, 15, 2, 1, 0.80, 0.14, 156, 4, 65, '2026-06-23 21:47:04', '2026-06-23 21:47:04');

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '作者ID(关联users)',
  `channel_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属频道ID(关联channels)',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文章正文(富文本HTML)',
  `tag` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自定义标签(最多20字符)',
  `cover_type` tinyint NOT NULL DEFAULT 0 COMMENT '封面类型: 0单图 1三图 2无图',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '文章状态: 0草稿 1待审核 2审核通过 3审核失败 4已上架 5已下架',
  `review_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见(驳回时填写)',
  `scheduled_at` datetime NULL DEFAULT NULL COMMENT '定时发布时间',
  `published_at` datetime NULL DEFAULT NULL COMMENT '实际上架发布时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '软删除时间(NULL=未删除)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_channel_id`(`channel_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_published_at`(`published_at` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_scheduled_at`(`scheduled_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章/图文内容主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES (3, 1, 4, '2026 Claude 完整入门手册：注册、提示词、高级功能全拆解', '{\"ops\":[{\"insert\":{\"image\":\"https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/a319a521af94481787db571317214b17.jpeg\"}},{\"insert\":\"\\n测试一下\\n\"}]}', '开发工具', 1, 4, NULL, '2026-06-15 00:00:00', '2026-06-15 18:40:35', NULL, '2026-06-23 19:24:41', '2026-06-24 21:03:11');
INSERT INTO `articles` VALUES (4, 1, 1, 'AI 时代：人机共生，重塑文明新序', '{\"ops\":[{\"insert\":{\"image\":\"https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/b49495fb6d1f4d7fbcd4ca44dfe13a45.jpeg\"}},{\"insert\":\"\\n测试一下\\n\"}]}', 'AI', 2, 4, NULL, '2026-06-25 00:00:00', '2026-06-15 18:40:33', NULL, '2026-06-23 19:27:37', '2026-06-24 21:03:08');
INSERT INTO `articles` VALUES (5, 1, 4, 'Java 浮点数灾难：为什么财务系统必须放弃 double 只用 BigDecimal', '{\"ops\":[{\"insert\":{\"image\":\"https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/45957eebc6524949a4d87e7efe7e3fc0.jpeg\"}},{\"insert\":\"\\njava语言\\n\"}]}', 'java', 1, 4, NULL, '2026-06-23 00:00:00', '2026-06-15 18:40:37', NULL, '2026-06-23 19:28:09', '2026-06-24 21:03:15');
INSERT INTO `articles` VALUES (6, 1, 3, 'AI 时代前端革命：从切图仔到智能交互架构师', '{\"ops\":[{\"insert\":{\"image\":\"https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/1c2a3a08ec76459a92b07cded858575b.jpeg\"}},{\"insert\":\"\\n测试一下\\n\"}]}', '前端', 3, 4, NULL, '2026-06-23 00:00:00', '2026-06-15 18:40:30', NULL, '2026-06-23 19:28:46', '2026-06-24 21:03:24');
INSERT INTO `articles` VALUES (7, 1, 1, 'AI时代，即将来临', '{\"ops\":[{\"insert\":\"测试\\n\"}]}', '测试', 1, 1, NULL, '2026-06-23 00:00:00', NULL, NULL, '2026-06-23 19:29:41', '2026-06-24 19:54:13');
INSERT INTO `articles` VALUES (8, 1, 5, '测试一下', '{\"ops\":[{\"insert\":{\"image\":\"https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/b49495fb6d1f4d7fbcd4ca44dfe13a45.jpeg\"}},{\"insert\":\"\\n\"}]}', '测试', 1, 1, NULL, '2026-06-24 00:00:00', NULL, NULL, '2026-06-23 19:30:12', '2026-06-23 19:30:12');
INSERT INTO `articles` VALUES (9, 1, 9, '测试学科', '{\"ops\":[{\"insert\":\"111\\n\"}]}', '测试', 3, 1, NULL, '2026-06-23 00:00:00', NULL, NULL, '2026-06-23 19:54:34', '2026-06-23 19:54:34');
INSERT INTO `articles` VALUES (10, 1, 9, '测试学科', '{\"ops\":[{\"insert\":\"111\\n\"}]}', '测试', 3, 1, NULL, '2026-06-23 00:00:00', NULL, NULL, '2026-06-23 19:56:45', '2026-06-24 19:54:26');
INSERT INTO `articles` VALUES (11, 1, 2, '测试', '{\"ops\":[{\"insert\":\"111\\n\"}]}', '测试', 0, 4, NULL, '2026-06-24 00:00:00', '2026-06-24 18:39:49', NULL, '2026-06-24 18:38:02', '2026-06-24 18:38:02');

-- ----------------------------
-- Table structure for channels
-- ----------------------------
DROP TABLE IF EXISTS `channels`;
CREATE TABLE `channels`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '频道ID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '频道名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '频道描述',
  `sort_order` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序权重(越小越靠前)',
  `is_enabled` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '启用状态: 1=启用 0=禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章频道/分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of channels
-- ----------------------------
INSERT INTO `channels` VALUES (1, '人工智能', 'AI、机器学习、深度学习相关', 1, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (2, '大数据', '大数据技术、数据仓库、数据分析', 2, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (3, '前端开发', 'HTML、CSS、JavaScript、Vue、React等', 3, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (4, '后端开发', 'Java、Spring、微服务、分布式架构', 4, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (5, '云计算', 'AWS、Azure、阿里云、容器化技术', 5, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (6, '网络安全', '渗透测试、安全防护、加密技术', 6, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (7, '物联网', 'IoT、边缘计算、嵌入式开发', 7, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (8, '区块链', 'Web3、智能合约、数字货币', 8, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (9, '运维开发', 'DevOps、CI/CD、K8s、自动化运维', 9, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');
INSERT INTO `channels` VALUES (10, '数据库', 'MySQL、Redis、MongoDB、Elasticsearch', 10, 1, '2026-06-23 18:17:47', '2026-06-23 18:17:47');

-- ----------------------------
-- Table structure for fan_messages
-- ----------------------------
DROP TABLE IF EXISTS `fan_messages`;
CREATE TABLE `fan_messages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '发送者(自媒体作者)ID',
  `fan_id` bigint UNSIGNED NOT NULL COMMENT '接收者(粉丝)ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_fan`(`user_id` ASC, `fan_id` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '粉丝私信消息记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fan_messages
-- ----------------------------

-- ----------------------------
-- Table structure for fan_portrait_data
-- ----------------------------
DROP TABLE IF EXISTS `fan_portrait_data`;
CREATE TABLE `fan_portrait_data`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '画像记录ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '自媒体作者ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `dimension` tinyint NOT NULL COMMENT '画像维度: 0性别 1年龄 2地域 3终端 4活跃时间 5内容偏好',
  `dimension_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维度具体值 如: male / 18-23 / 广东 / iOS',
  `dimension_value` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '数量',
  `percentage` decimal(5, 2) NULL DEFAULT NULL COMMENT '占比(%) 如 68.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date_dim_key`(`user_id` ASC, `stat_date` ASC, `dimension` ASC, `dimension_key` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE,
  INDEX `idx_dimension`(`dimension` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '粉丝画像数据(性别/年龄/地域/终端/活跃时间/内容偏好)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fan_portrait_data
-- ----------------------------
INSERT INTO `fan_portrait_data` VALUES (1, 1, '2026-06-24', 0, 'male', 232, 58.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (2, 1, '2026-06-24', 0, 'female', 168, 42.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (3, 1, '2026-06-24', 1, '18-24岁', 88, 22.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (4, 1, '2026-06-24', 1, '25-34岁', 156, 39.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (5, 1, '2026-06-24', 1, '35-44岁', 100, 25.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (6, 1, '2026-06-24', 1, '45-54岁', 40, 10.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (7, 1, '2026-06-24', 1, '55岁以上', 16, 4.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (8, 1, '2026-06-24', 2, '华东', 120, 30.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (9, 1, '2026-06-24', 2, '华南', 88, 22.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (10, 1, '2026-06-24', 2, '华北', 72, 18.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (11, 1, '2026-06-24', 2, '西南', 52, 13.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (12, 1, '2026-06-24', 2, '其他地区', 68, 17.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (13, 1, '2026-06-24', 3, 'iOS', 176, 44.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (14, 1, '2026-06-24', 3, 'Android', 208, 52.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (15, 1, '2026-06-24', 3, '其他', 16, 4.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (16, 1, '2026-06-24', 4, '早上6-10点', 60, 15.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (17, 1, '2026-06-24', 4, '上午10-12点', 48, 12.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (18, 1, '2026-06-24', 4, '中午12-14点', 72, 18.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (19, 1, '2026-06-24', 4, '下午14-18点', 56, 14.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (20, 1, '2026-06-24', 4, '晚上18-22点', 104, 26.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (21, 1, '2026-06-24', 4, '夜间22-6点', 60, 15.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (22, 1, '2026-06-24', 5, '社会', 72, 18.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (23, 1, '2026-06-24', 5, '科技', 88, 22.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (24, 1, '2026-06-24', 5, '财经', 52, 13.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (25, 1, '2026-06-24', 5, '娱乐', 68, 17.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (26, 1, '2026-06-24', 5, '体育', 40, 10.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (27, 1, '2026-06-24', 5, '生活', 48, 12.00, '2026-06-24 16:38:26');
INSERT INTO `fan_portrait_data` VALUES (28, 1, '2026-06-24', 5, '其他', 32, 8.00, '2026-06-24 16:38:26');

-- ----------------------------
-- Table structure for fan_read_hourly
-- ----------------------------
DROP TABLE IF EXISTS `fan_read_hourly`;
CREATE TABLE `fan_read_hourly`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '趋势记录ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '自媒体作者ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `hour` tinyint UNSIGNED NOT NULL COMMENT '小时(0-23 对应00:00-23:00)',
  `read_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '该小时阅读量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date_hour`(`user_id` ASC, `stat_date` ASC, `hour` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 218 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '粉丝阅读量小时趋势数据(折线图)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fan_read_hourly
-- ----------------------------
INSERT INTO `fan_read_hourly` VALUES (1, 1, '2026-06-15', 0, 40, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (2, 1, '2026-06-15', 1, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (3, 1, '2026-06-15', 2, 25, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (4, 1, '2026-06-15', 3, 36, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (5, 1, '2026-06-15', 4, 38, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (6, 1, '2026-06-15', 5, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (7, 1, '2026-06-15', 6, 29, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (8, 1, '2026-06-15', 7, 24, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (9, 1, '2026-06-15', 8, 97, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (10, 1, '2026-06-15', 9, 132, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (11, 1, '2026-06-15', 10, 154, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (12, 1, '2026-06-15', 11, 24, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (13, 1, '2026-06-15', 12, 98, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (14, 1, '2026-06-15', 13, 92, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (15, 1, '2026-06-15', 14, 128, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (16, 1, '2026-06-15', 15, 35, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (17, 1, '2026-06-15', 16, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (18, 1, '2026-06-15', 17, 29, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (19, 1, '2026-06-15', 18, 18, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (20, 1, '2026-06-15', 19, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (21, 1, '2026-06-15', 20, 155, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (22, 1, '2026-06-15', 21, 117, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (23, 1, '2026-06-15', 22, 135, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (24, 1, '2026-06-15', 23, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (25, 1, '2026-06-16', 0, 22, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (26, 1, '2026-06-16', 1, 42, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (27, 1, '2026-06-16', 2, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (28, 1, '2026-06-16', 3, 45, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (29, 1, '2026-06-16', 4, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (30, 1, '2026-06-16', 5, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (31, 1, '2026-06-16', 6, 49, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (32, 1, '2026-06-16', 7, 40, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (33, 1, '2026-06-16', 8, 116, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (34, 1, '2026-06-16', 9, 95, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (35, 1, '2026-06-16', 10, 135, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (36, 1, '2026-06-16', 11, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (37, 1, '2026-06-16', 12, 120, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (38, 1, '2026-06-16', 13, 129, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (39, 1, '2026-06-16', 14, 139, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (40, 1, '2026-06-16', 15, 24, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (41, 1, '2026-06-16', 16, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (42, 1, '2026-06-16', 17, 31, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (43, 1, '2026-06-16', 18, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (44, 1, '2026-06-16', 19, 31, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (45, 1, '2026-06-16', 20, 104, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (46, 1, '2026-06-16', 21, 108, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (47, 1, '2026-06-16', 22, 125, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (48, 1, '2026-06-16', 23, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (49, 1, '2026-06-17', 0, 24, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (50, 1, '2026-06-17', 1, 35, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (51, 1, '2026-06-17', 2, 44, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (52, 1, '2026-06-17', 3, 25, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (53, 1, '2026-06-17', 4, 38, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (54, 1, '2026-06-17', 5, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (55, 1, '2026-06-17', 6, 35, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (56, 1, '2026-06-17', 7, 36, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (57, 1, '2026-06-17', 8, 91, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (58, 1, '2026-06-17', 9, 139, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (59, 1, '2026-06-17', 10, 104, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (60, 1, '2026-06-17', 11, 30, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (61, 1, '2026-06-17', 12, 131, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (62, 1, '2026-06-17', 13, 108, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (63, 1, '2026-06-17', 14, 91, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (64, 1, '2026-06-17', 15, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (65, 1, '2026-06-17', 16, 44, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (66, 1, '2026-06-17', 17, 23, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (67, 1, '2026-06-17', 18, 35, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (68, 1, '2026-06-17', 19, 25, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (69, 1, '2026-06-17', 20, 90, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (70, 1, '2026-06-17', 21, 109, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (71, 1, '2026-06-17', 22, 170, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (72, 1, '2026-06-17', 23, 22, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (73, 1, '2026-06-18', 0, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (74, 1, '2026-06-18', 1, 15, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (75, 1, '2026-06-18', 2, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (76, 1, '2026-06-18', 3, 29, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (77, 1, '2026-06-18', 4, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (78, 1, '2026-06-18', 5, 26, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (79, 1, '2026-06-18', 6, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (80, 1, '2026-06-18', 7, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (81, 1, '2026-06-18', 8, 144, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (82, 1, '2026-06-18', 9, 179, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (83, 1, '2026-06-18', 10, 125, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (84, 1, '2026-06-18', 11, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (85, 1, '2026-06-18', 12, 90, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (86, 1, '2026-06-18', 13, 113, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (87, 1, '2026-06-18', 14, 148, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (88, 1, '2026-06-18', 15, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (89, 1, '2026-06-18', 16, 13, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (90, 1, '2026-06-18', 17, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (91, 1, '2026-06-18', 18, 36, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (92, 1, '2026-06-18', 19, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (93, 1, '2026-06-18', 20, 85, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (94, 1, '2026-06-18', 21, 81, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (95, 1, '2026-06-18', 22, 120, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (96, 1, '2026-06-18', 23, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (97, 1, '2026-06-19', 0, 42, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (98, 1, '2026-06-19', 1, 23, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (99, 1, '2026-06-19', 2, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (100, 1, '2026-06-19', 3, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (101, 1, '2026-06-19', 4, 48, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (102, 1, '2026-06-19', 5, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (103, 1, '2026-06-19', 6, 30, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (104, 1, '2026-06-19', 7, 30, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (105, 1, '2026-06-19', 8, 109, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (106, 1, '2026-06-19', 9, 123, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (107, 1, '2026-06-19', 10, 104, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (108, 1, '2026-06-19', 11, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (109, 1, '2026-06-19', 12, 162, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (110, 1, '2026-06-19', 13, 138, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (111, 1, '2026-06-19', 14, 118, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (112, 1, '2026-06-19', 15, 39, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (113, 1, '2026-06-19', 16, 44, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (114, 1, '2026-06-19', 17, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (115, 1, '2026-06-19', 18, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (116, 1, '2026-06-19', 19, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (117, 1, '2026-06-19', 20, 122, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (118, 1, '2026-06-19', 21, 102, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (119, 1, '2026-06-19', 22, 112, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (120, 1, '2026-06-19', 23, 44, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (121, 1, '2026-06-20', 0, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (122, 1, '2026-06-20', 1, 36, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (123, 1, '2026-06-20', 2, 30, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (124, 1, '2026-06-20', 3, 22, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (125, 1, '2026-06-20', 4, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (126, 1, '2026-06-20', 5, 24, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (127, 1, '2026-06-20', 6, 38, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (128, 1, '2026-06-20', 7, 31, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (129, 1, '2026-06-20', 8, 97, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (130, 1, '2026-06-20', 9, 103, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (131, 1, '2026-06-20', 10, 115, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (132, 1, '2026-06-20', 11, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (133, 1, '2026-06-20', 12, 116, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (134, 1, '2026-06-20', 13, 103, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (135, 1, '2026-06-20', 14, 104, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (136, 1, '2026-06-20', 15, 13, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (137, 1, '2026-06-20', 16, 25, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (138, 1, '2026-06-20', 17, 30, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (139, 1, '2026-06-20', 18, 40, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (140, 1, '2026-06-20', 19, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (141, 1, '2026-06-20', 20, 146, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (142, 1, '2026-06-20', 21, 144, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (143, 1, '2026-06-20', 22, 140, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (144, 1, '2026-06-20', 23, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (145, 1, '2026-06-21', 0, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (146, 1, '2026-06-21', 1, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (147, 1, '2026-06-21', 2, 42, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (148, 1, '2026-06-21', 3, 52, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (149, 1, '2026-06-21', 4, 42, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (150, 1, '2026-06-21', 5, 36, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (151, 1, '2026-06-21', 6, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (152, 1, '2026-06-21', 7, 22, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (153, 1, '2026-06-21', 8, 123, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (154, 1, '2026-06-21', 9, 91, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (155, 1, '2026-06-21', 10, 121, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (156, 1, '2026-06-21', 11, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (157, 1, '2026-06-21', 12, 135, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (158, 1, '2026-06-21', 13, 125, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (159, 1, '2026-06-21', 14, 114, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (160, 1, '2026-06-21', 15, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (161, 1, '2026-06-21', 16, 17, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (162, 1, '2026-06-21', 17, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (163, 1, '2026-06-21', 18, 41, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (164, 1, '2026-06-21', 19, 37, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (165, 1, '2026-06-21', 20, 93, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (166, 1, '2026-06-21', 21, 109, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (167, 1, '2026-06-21', 22, 155, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (168, 1, '2026-06-21', 23, 42, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (169, 1, '2026-06-22', 0, 39, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (170, 1, '2026-06-22', 1, 17, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (171, 1, '2026-06-22', 2, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (172, 1, '2026-06-22', 3, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (173, 1, '2026-06-22', 4, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (174, 1, '2026-06-22', 5, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (175, 1, '2026-06-22', 6, 20, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (176, 1, '2026-06-22', 7, 41, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (177, 1, '2026-06-22', 8, 105, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (178, 1, '2026-06-22', 9, 124, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (179, 1, '2026-06-22', 10, 120, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (180, 1, '2026-06-22', 11, 48, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (181, 1, '2026-06-22', 12, 97, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (182, 1, '2026-06-22', 13, 130, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (183, 1, '2026-06-22', 14, 143, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (184, 1, '2026-06-22', 15, 18, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (185, 1, '2026-06-22', 16, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (186, 1, '2026-06-22', 17, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (187, 1, '2026-06-22', 18, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (188, 1, '2026-06-22', 19, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (189, 1, '2026-06-22', 20, 113, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (190, 1, '2026-06-22', 21, 83, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (191, 1, '2026-06-22', 22, 134, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (192, 1, '2026-06-22', 23, 9, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (193, 1, '2026-06-23', 0, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (194, 1, '2026-06-23', 1, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (195, 1, '2026-06-23', 2, 34, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (196, 1, '2026-06-23', 3, 35, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (197, 1, '2026-06-23', 4, 43, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (198, 1, '2026-06-23', 5, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (199, 1, '2026-06-23', 6, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (200, 1, '2026-06-23', 7, 28, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (201, 1, '2026-06-23', 8, 114, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (202, 1, '2026-06-23', 9, 88, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (203, 1, '2026-06-23', 10, 111, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (204, 1, '2026-06-23', 11, 48, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (205, 1, '2026-06-23', 12, 138, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (206, 1, '2026-06-23', 13, 133, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (207, 1, '2026-06-23', 14, 124, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (208, 1, '2026-06-23', 15, 33, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (209, 1, '2026-06-23', 16, 11, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (210, 1, '2026-06-23', 17, 21, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (211, 1, '2026-06-23', 18, 27, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (212, 1, '2026-06-23', 19, 32, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (213, 1, '2026-06-23', 20, 88, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (214, 1, '2026-06-23', 21, 118, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (215, 1, '2026-06-23', 22, 117, '2026-06-23 21:33:53');
INSERT INTO `fan_read_hourly` VALUES (216, 1, '2026-06-23', 23, 28, '2026-06-23 21:33:53');

-- ----------------------------
-- Table structure for fan_stats_daily
-- ----------------------------
DROP TABLE IF EXISTS `fan_stats_daily`;
CREATE TABLE `fan_stats_daily`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计记录ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '自媒体作者ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `total_fan_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '累计粉丝总数',
  `fan_read_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '粉丝累计阅读量',
  `fan_revenue` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '粉丝收益(元)',
  `new_follow_count` int NOT NULL COMMENT '新增关注量',
  `unfollow_count` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '取消关注量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id` ASC, `stat_date` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '粉丝每日统计数据(粉丝数/阅读量/收益/取关量)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fan_stats_daily
-- ----------------------------
INSERT INTO `fan_stats_daily` VALUES (1, 1, '2026-06-15', 57, 53, 5.78, 57, 0, '2026-06-23 21:33:53', '2026-06-24 13:29:44');
INSERT INTO `fan_stats_daily` VALUES (2, 1, '2026-06-16', 126, 134, 13.52, 70, 1, '2026-06-23 21:33:53', '2026-06-24 13:30:36');
INSERT INTO `fan_stats_daily` VALUES (3, 1, '2026-06-17', 156, 158, 22.04, 35, 5, '2026-06-23 21:33:53', '2026-06-24 13:31:03');
INSERT INTO `fan_stats_daily` VALUES (4, 1, '2026-06-18', 199, 208, 33.88, 53, 10, '2026-06-23 21:33:53', '2026-06-24 13:32:21');
INSERT INTO `fan_stats_daily` VALUES (5, 1, '2026-06-19', 213, 200, 45.08, 18, 4, '2026-06-23 21:33:53', '2026-06-24 13:32:37');
INSERT INTO `fan_stats_daily` VALUES (6, 1, '2026-06-20', 200, 179, 14.39, 2, 15, '2026-06-23 21:33:53', '2026-06-24 13:32:48');
INSERT INTO `fan_stats_daily` VALUES (7, 1, '2026-06-21', 360, 366, 36.44, 160, 0, '2026-06-23 21:33:53', '2026-06-24 13:32:55');
INSERT INTO `fan_stats_daily` VALUES (8, 1, '2026-06-22', 378, 408, 52.07, 20, 2, '2026-06-23 21:33:53', '2026-06-24 13:33:07');
INSERT INTO `fan_stats_daily` VALUES (9, 1, '2026-06-23', 400, 467, 38.13, 26, 4, '2026-06-23 21:33:53', '2026-06-24 13:34:31');

-- ----------------------------
-- Table structure for fans
-- ----------------------------
DROP TABLE IF EXISTS `fans`;
CREATE TABLE `fans`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '粉丝记录ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '自媒体作者ID(被关注者)',
  `fan_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '粉丝用户名/昵称',
  `fan_avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '粉丝头像URL',
  `is_blocked` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '拉黑标记: 1=已拉黑 0=正常',
  `followed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_blocked`(`user_id` ASC, `is_blocked` ASC) USING BTREE,
  INDEX `idx_followed_at`(`followed_at` ASC) USING BTREE,
  INDEX `idx_user_followed`(`user_id` ASC, `followed_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 401 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '粉丝列表(支持拉黑/发消息)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fans
-- ----------------------------
INSERT INTO `fans` VALUES (1, 1, '北落师门', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan001', 0, '2026-06-23 08:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (2, 1, '南鱼座α', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan002', 0, '2026-06-23 08:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (3, 1, '参商永离', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan003', 0, '2026-06-23 08:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (4, 1, '北斗天璇', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan004', 0, '2026-06-23 08:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (5, 1, '荧惑守心', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan005', 0, '2026-06-23 08:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (6, 1, '太微右垣', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan006', 0, '2026-06-23 08:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (7, 1, '紫微星君', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan007', 0, '2026-06-23 08:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (8, 1, '二十八宿', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan008', 0, '2026-06-23 08:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (9, 1, '银河快递员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan009', 0, '2026-06-23 08:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (10, 1, '星际流浪者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan010', 0, '2026-06-23 09:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (11, 1, '黑洞观察员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan011', 0, '2026-06-23 09:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (12, 1, '引力波捕手', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan012', 0, '2026-06-23 09:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (13, 1, '暗物质猎人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan013', 0, '2026-06-23 09:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (14, 1, '光年之外', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan014', 0, '2026-06-23 09:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (15, 1, '三体观察者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan015', 0, '2026-06-23 09:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (16, 1, '曲率驱动', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan016', 0, '2026-06-23 09:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (17, 1, '降维打击', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan017', 0, '2026-06-23 09:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (18, 1, '二向箔批发', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan018', 0, '2026-06-23 09:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (19, 1, '面壁者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan019', 0, '2026-06-23 09:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (20, 1, '执剑人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan020', 0, '2026-06-23 09:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (21, 1, '破壁人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan021', 0, '2026-06-23 09:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (22, 1, '水滴探测器', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan022', 0, '2026-06-23 10:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (23, 1, '引力广播', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan023', 0, '2026-06-23 10:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (24, 1, '猜疑链', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan024', 0, '2026-06-23 10:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (25, 1, '技术爆炸', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan025', 0, '2026-06-23 10:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (26, 1, '山海关之外', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan026', 0, '2026-06-23 10:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (27, 1, '云天明', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan027', 0, '2026-06-23 10:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (28, 1, '蓝色空间号', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan028', 0, '2026-06-23 10:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (29, 1, '自然选择号', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan029', 0, '2026-06-23 10:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (30, 1, '万有引力号', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan030', 0, '2026-06-23 10:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (31, 1, '深海状态', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan031', 0, '2026-06-23 10:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (32, 1, '思想钢印', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan032', 1, '2026-06-23 10:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (33, 1, '只送大脑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan033', 0, '2026-06-23 10:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (34, 1, '不要回答', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan034', 0, '2026-06-22 09:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (35, 1, '给岁月以文明', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan035', 0, '2026-06-22 09:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (36, 1, '给时光以生命', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan036', 0, '2026-06-22 09:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (37, 1, '活着本身就是意义', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan037', 0, '2026-06-22 09:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (38, 1, '毁灭你与你何干', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan038', 0, '2026-06-22 09:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (39, 1, '弱小和无知不是生存的障碍', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan039', 0, '2026-06-22 09:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (40, 1, '傲慢才是', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan040', 0, '2026-06-22 09:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (41, 1, '万事胜意', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan041', 0, '2026-06-22 09:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (42, 1, '来日方长', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan042', 0, '2026-06-22 09:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (43, 1, '山高水长', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan043', 0, '2026-06-22 09:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (44, 1, '后会有期', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan044', 0, '2026-06-22 09:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (45, 1, '此间少年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan045', 1, '2026-06-22 09:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (46, 1, '盛夏光年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan046', 0, '2026-06-22 10:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (47, 1, '季风过境', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan047', 0, '2026-06-22 10:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (48, 1, '候鸟南飞', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan048', 0, '2026-06-22 10:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (49, 1, '北方的女王', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan049', 0, '2026-06-22 10:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (50, 1, '南方的女王', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan050', 0, '2026-06-22 10:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (51, 1, '西湖醋鱼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan051', 0, '2026-06-22 10:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (52, 1, '重庆森林', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan052', 0, '2026-06-22 10:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (53, 1, '成都带不走的只有你', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan053', 0, '2026-06-22 10:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (54, 1, '深圳速度', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan054', 0, '2026-06-22 10:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (55, 1, '北京北京', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan055', 0, '2026-06-22 10:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (56, 1, '上海1943', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan056', 0, '2026-06-22 10:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (57, 1, '关于郑州的记忆', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan057', 0, '2026-06-22 10:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (58, 1, '杀死那个石家庄人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan058', 1, '2026-06-21 09:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (59, 1, '热河路', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan059', 0, '2026-06-21 09:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (60, 1, '秦皇岛', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan060', 0, '2026-06-21 09:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (61, 1, '定西', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan061', 0, '2026-06-21 09:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (62, 1, '兰州兰州', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan062', 0, '2026-06-21 09:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (63, 1, '港岛妹妹', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan063', 0, '2026-06-21 09:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (64, 1, '李米的猜想', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan064', 0, '2026-06-21 09:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (65, 1, '大象席地而坐', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan065', 0, '2026-06-21 09:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (66, 1, '路边野餐', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan066', 0, '2026-06-21 09:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (67, 1, '海边的曼彻斯特', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan067', 0, '2026-06-21 09:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (68, 1, '重庆大厦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan068', 0, '2026-06-21 09:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (69, 1, '冬冬的假期', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan069', 0, '2026-06-21 09:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (70, 1, '一一', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan070', 0, '2026-06-21 10:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (71, 1, '坂本龙一', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan071', 0, '2026-06-21 10:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (72, 1, '久石让的夏天', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan072', 0, '2026-06-21 10:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (73, 1, '海上钢琴师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan073', 0, '2026-06-21 10:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (74, 1, '天堂电影院', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan074', 0, '2026-06-21 10:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (75, 1, '小确幸', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan075', 0, '2026-06-21 10:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (76, 1, '小森林', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan076', 0, '2026-06-21 10:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (77, 1, '步履不停', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan077', 0, '2026-06-21 10:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (78, 1, '如父如子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan078', 0, '2026-06-21 10:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (79, 1, '比海更深', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan079', 0, '2026-06-21 10:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (80, 1, '无人知晓', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan080', 0, '2026-06-21 10:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (81, 1, '西西弗斯', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan081', 0, '2026-06-21 10:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (82, 1, '推石头上山', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan082', 0, '2026-06-20 09:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (83, 1, '加缪的猫', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan083', 0, '2026-06-20 09:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (84, 1, '局外人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan084', 0, '2026-06-20 09:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (85, 1, '鼠疫', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan085', 0, '2026-06-20 09:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (86, 1, '薛定谔的猫', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan086', 0, '2026-06-20 09:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (87, 1, '既死又活', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan087', 0, '2026-06-20 09:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (88, 1, '测不准原理', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan088', 0, '2026-06-20 09:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (89, 1, '海森堡', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan089', 0, '2026-06-20 09:35:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (90, 1, '追光', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan090', 1, '2026-06-20 09:40:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (91, 1, '玻尔', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan091', 0, '2026-06-20 09:45:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (92, 1, '上帝不掷骰子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan092', 0, '2026-06-20 09:50:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (93, 1, '爱因斯坦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan093', 0, '2026-06-20 09:55:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (94, 1, '他掷骰子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan094', 0, '2026-06-20 10:00:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (95, 1, '奥本海默', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan095', 0, '2026-06-20 10:05:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (96, 1, '现在我成了死神', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan096', 0, '2026-06-20 10:10:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (97, 1, '世界的毁灭者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan097', 0, '2026-06-20 10:15:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (98, 1, '曼哈顿计划', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan098', 0, '2026-06-20 10:20:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (99, 1, '费曼的鼓', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan099', 0, '2026-06-20 10:25:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (100, 1, '盖茨比与绿光', 'https://api.dicebear.com/7.x/avataaars/svg?seed=fan100', 0, '2026-06-20 10:30:00', '2026-06-23 20:57:05', '2026-06-23 21:04:24');
INSERT INTO `fans` VALUES (101, 1, '云端漫游者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f101', 0, '2026-06-20 10:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (102, 1, '代码诗人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f102', 0, '2026-06-20 10:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (103, 1, '夜雨微凉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f103', 0, '2026-06-20 10:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (104, 1, '清风徐来', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f104', 0, '2026-06-20 10:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (105, 1, '墨染青衣', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f105', 0, '2026-06-20 10:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (106, 1, '星河滚烫', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f106', 0, '2026-06-19 08:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (107, 1, '一路向北', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f107', 0, '2026-06-19 08:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (108, 1, '算法小王子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f108', 0, '2026-06-19 08:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (109, 1, '柠檬不酸', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f109', 0, '2026-06-19 08:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (110, 1, '且听风吟', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f110', 1, '2026-06-19 08:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (111, 1, '月光倾城', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f111', 0, '2026-06-19 08:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (112, 1, '数字游民', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f112', 0, '2026-06-19 08:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (113, 1, '深海鲸鱼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f113', 0, '2026-06-19 08:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (114, 1, '晚风吻尽', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f114', 0, '2026-06-19 08:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (115, 1, '极客先锋', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f115', 0, '2026-06-19 08:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (116, 1, '橘子汽水', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f116', 0, '2026-06-19 08:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (117, 1, '独行侠客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f117', 0, '2026-06-19 09:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (118, 1, '花开半夏', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f118', 0, '2026-06-19 09:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (119, 1, '技术宅男', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f119', 0, '2026-06-19 09:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (120, 1, '晴空万里', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f120', 0, '2026-06-19 09:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (121, 1, '浪迹天涯', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f121', 0, '2026-06-19 09:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (122, 1, '北冥有鱼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f122', 0, '2026-06-19 09:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (123, 1, '辣椒有点甜', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f123', 0, '2026-06-19 09:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (124, 1, '半盏流年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f124', 0, '2026-06-19 09:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (125, 1, '程序猿日常', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f125', 1, '2026-06-19 09:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (126, 1, '旧时光', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f126', 0, '2026-06-19 09:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (127, 1, '逐梦少年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f127', 0, '2026-06-19 09:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (128, 1, '薄荷微凉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f128', 0, '2026-06-19 09:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (129, 1, '键盘侠来了', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f129', 0, '2026-06-19 10:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (130, 1, '秋水共长天', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f130', 0, '2026-06-19 10:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (131, 1, '黑夜问白天', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f131', 0, '2026-06-19 10:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (132, 1, '星辰大海', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f132', 0, '2026-06-19 10:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (133, 1, '小楼听雨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f133', 0, '2026-06-19 10:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (134, 1, '架构师的梦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f134', 0, '2026-06-19 10:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (135, 1, '落花如雪', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f135', 0, '2026-06-19 10:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (136, 1, '风起云涌', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f136', 0, '2026-06-18 08:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (137, 1, '数据挖掘机', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f137', 0, '2026-06-18 08:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (138, 1, '南山南', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f138', 0, '2026-06-18 08:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (139, 1, '梦想家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f139', 0, '2026-06-18 08:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (140, 1, '暖阳如初', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f140', 0, '2026-06-18 08:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (141, 1, '全干工程师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f141', 0, '2026-06-18 08:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (142, 1, '时光煮雨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f142', 0, '2026-06-18 08:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (143, 1, '余生请指教', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f143', 0, '2026-06-18 08:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (144, 1, '梅子黄时雨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f144', 0, '2026-06-18 08:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (145, 1, '运维老司机', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f145', 1, '2026-06-18 08:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (146, 1, '白日梦想家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f146', 0, '2026-06-18 08:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (147, 1, '繁星点点', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f147', 0, '2026-06-18 08:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (148, 1, '山有木兮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f148', 0, '2026-06-18 09:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (149, 1, '代码搬运工', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f149', 0, '2026-06-18 09:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (150, 1, '长夜未央', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f150', 0, '2026-06-18 09:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (151, 1, '晨光熹微', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f151', 0, '2026-06-18 09:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (152, 1, '前端小菜鸟', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f152', 0, '2026-06-18 09:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (153, 1, '桃李春风', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f153', 0, '2026-06-18 09:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (154, 1, '逆风飞扬', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f154', 0, '2026-06-18 09:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (155, 1, '冰阔落', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f155', 0, '2026-06-18 09:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (156, 1, '江湖故人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f156', 0, '2026-06-18 09:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (157, 1, '测试大魔王', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f157', 0, '2026-06-18 09:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (158, 1, '陌上花开', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f158', 0, '2026-06-18 09:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (159, 1, '如风过境', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f159', 0, '2026-06-18 09:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (160, 1, '二次元来客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f160', 1, '2026-06-18 10:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (161, 1, '烟雨江南', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f161', 0, '2026-06-18 10:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (162, 1, '浅梦半夏', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f162', 0, '2026-06-18 10:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (163, 1, '微服务专家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f163', 0, '2026-06-18 10:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (164, 1, '素笺淡墨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f164', 0, '2026-06-18 10:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (165, 1, '飞鱼在空中', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f165', 0, '2026-06-18 10:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (166, 1, '蝶恋花', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f166', 0, '2026-06-18 10:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (167, 1, '安全第一', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f167', 0, '2026-06-18 10:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (168, 1, '浮生若梦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f168', 0, '2026-06-18 10:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (169, 1, '海阔天空', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f169', 0, '2026-06-18 10:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (170, 1, '懒猫晒太阳', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f170', 0, '2026-06-18 10:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (171, 1, '开源贡献者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f171', 0, '2026-06-18 10:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (172, 1, '岁月神偷', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f172', 0, '2026-06-17 08:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (173, 1, '静水流深', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f173', 0, '2026-06-17 08:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (174, 1, '一路繁花', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f174', 0, '2026-06-17 08:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (175, 1, '雪落无声', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f175', 1, '2026-06-17 08:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (176, 1, '极简主义', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f176', 0, '2026-06-17 08:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (177, 1, '夜色撩人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f177', 0, '2026-06-17 08:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (178, 1, '人间烟火', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f178', 0, '2026-06-17 08:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (179, 1, '雨打芭蕉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f179', 0, '2026-06-17 08:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (180, 1, '云深不知处', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f180', 0, '2026-06-17 08:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (181, 1, '追风筝的人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f181', 0, '2026-06-17 08:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (182, 1, '梨花院落', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f182', 0, '2026-06-17 08:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (183, 1, '科技观察者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f183', 0, '2026-06-17 08:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (184, 1, '浅喜似苍狗', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f184', 0, '2026-06-17 09:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (185, 1, '深爱如长风', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f185', 0, '2026-06-17 09:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (186, 1, '暮色挽歌', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f186', 0, '2026-06-17 09:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (187, 1, '且共从容', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f187', 0, '2026-06-17 09:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (188, 1, '诗酒趁年华', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f188', 0, '2026-06-17 09:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (189, 1, '春风十里', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f189', 0, '2026-06-17 09:25:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (190, 1, '寒江独钓', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f190', 1, '2026-06-17 09:30:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (191, 1, '晚来天欲雪', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f191', 0, '2026-06-17 09:35:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (192, 1, '能饮一杯无', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f192', 0, '2026-06-17 09:40:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (193, 1, '一蓑烟雨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f193', 0, '2026-06-17 09:45:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (194, 1, '也无风雨也无晴', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f194', 0, '2026-06-17 09:50:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (195, 1, '满船清梦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f195', 0, '2026-06-17 09:55:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (196, 1, '压星河', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f196', 0, '2026-06-17 10:00:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (197, 1, '知否知否', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f197', 0, '2026-06-17 10:05:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (198, 1, '应是绿肥红瘦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f198', 0, '2026-06-17 10:10:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (199, 1, '长风破浪', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f199', 0, '2026-06-17 10:15:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (200, 1, '直挂云帆', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f200', 0, '2026-06-17 10:20:00', '2026-06-23 20:58:33', '2026-06-23 21:02:39');
INSERT INTO `fans` VALUES (201, 1, '沧海一声笑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f201', 0, '2026-06-17 10:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (202, 1, '涛涛两岸潮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f202', 0, '2026-06-17 10:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (203, 1, '浮沉随浪', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f203', 0, '2026-06-17 10:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (204, 1, '只记今朝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f204', 0, '2026-06-17 10:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (205, 1, '苍天笑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f205', 0, '2026-06-17 10:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (206, 1, '纷纷世上潮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f206', 0, '2026-06-16 08:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (207, 1, '谁负谁胜出', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f207', 0, '2026-06-16 08:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (208, 1, '天知晓', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f208', 0, '2026-06-16 08:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (209, 1, '江山笑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f209', 0, '2026-06-16 08:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (210, 1, '烟雨遥', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f210', 1, '2026-06-16 08:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (211, 1, '清风笑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f211', 0, '2026-06-16 08:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (212, 1, '竟惹寂寥', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f212', 0, '2026-06-16 08:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (213, 1, '豪情还剩了', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f213', 0, '2026-06-16 08:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (214, 1, '一襟晚照', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f214', 0, '2026-06-16 08:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (215, 1, '产品经理不背锅', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f215', 0, '2026-06-16 08:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (216, 1, '设计狮吼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f216', 0, '2026-06-16 08:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (217, 1, 'BUG修不好', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f217', 0, '2026-06-16 08:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (218, 1, '摸鱼大师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f218', 0, '2026-06-16 09:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (219, 1, '秃头预备役', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f219', 0, '2026-06-16 09:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (220, 1, '深夜推送者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f220', 0, '2026-06-16 09:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (221, 1, '改需求就消失', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f221', 0, '2026-06-16 09:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (222, 1, '上线即跑路', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f222', 0, '2026-06-16 09:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (223, 1, '降级保平安', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f223', 0, '2026-06-16 09:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (224, 1, '回滚小能手', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f224', 0, '2026-06-16 09:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (225, 1, '黑客不黑', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f225', 1, '2026-06-16 09:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (226, 1, '风控哨兵', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f226', 0, '2026-06-16 09:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (227, 1, '加密通信', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f227', 0, '2026-06-16 09:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (228, 1, '零日漏洞', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f228', 0, '2026-06-16 09:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (229, 1, '白帽侠客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f229', 0, '2026-06-16 09:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (230, 1, '蜜罐陷阱', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f230', 0, '2026-06-16 10:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (231, 1, '数字堡垒', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f231', 0, '2026-06-16 10:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (232, 1, '暗网潜水员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f232', 0, '2026-06-16 10:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (233, 1, '量子比特', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f233', 0, '2026-06-16 10:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (234, 1, '神经网路', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f234', 0, '2026-06-16 10:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (235, 1, '深度学习家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f235', 0, '2026-06-16 10:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (236, 1, '卷积人生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f236', 0, '2026-06-16 10:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (237, 1, '梯度下降中', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f237', 0, '2026-06-16 10:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (238, 1, '过拟合了', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f238', 0, '2026-06-16 10:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (239, 1, '损失函数', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f239', 0, '2026-06-16 10:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (240, 1, '激活人生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f240', 1, '2026-06-16 10:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (241, 1, '正则化行者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f241', 0, '2026-06-16 10:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (242, 1, '批量归一化', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f242', 0, '2026-06-15 08:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (243, 1, '云端之上', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f243', 0, '2026-06-15 08:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (244, 1, '容器里的鱼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f244', 0, '2026-06-15 08:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (245, 1, 'K8S舵手', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f245', 1, '2026-06-15 08:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (246, 1, '弹性伸缩', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f246', 0, '2026-06-15 08:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (247, 1, '无服务器架构', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f247', 0, '2026-06-15 08:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (248, 1, '边缘节点', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f248', 0, '2026-06-15 08:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (249, 1, 'CDN加速中', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f249', 0, '2026-06-15 08:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (250, 1, '负载均衡器', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f250', 0, '2026-06-15 08:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (251, 1, '微服务网格', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f251', 0, '2026-06-15 08:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (252, 1, '前端小透明', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f252', 0, '2026-06-15 08:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (253, 1, 'CSS魔法师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f253', 0, '2026-06-15 08:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (254, 1, '像素眼', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f254', 0, '2026-06-15 09:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (255, 1, '响应式人生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f255', 0, '2026-06-15 09:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (256, 1, 'Flex布局控', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f256', 0, '2026-06-15 09:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (257, 1, 'Vue星人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f257', 0, '2026-06-15 09:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (258, 1, 'React钩子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f258', 0, '2026-06-15 09:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (259, 1, 'TypeScript卫兵', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f259', 0, '2026-06-15 09:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (260, 1, 'Webpack调优师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f260', 0, '2026-06-15 09:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (261, 1, '大前端航海家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f261', 0, '2026-06-15 09:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (262, 1, '全栈梦想家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f262', 0, '2026-06-15 09:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (263, 1, 'Java老炮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f263', 0, '2026-06-15 09:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (264, 1, 'Spring守护者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f264', 0, '2026-06-15 09:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (265, 1, '并发编程狂', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f265', 1, '2026-06-15 09:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (266, 1, 'JVM调优师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f266', 0, '2026-06-15 10:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (267, 1, '消息队列砖家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f267', 0, '2026-06-15 10:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (268, 1, '分布式锁匠', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f268', 0, '2026-06-15 10:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (269, 1, '缓存击穿者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f269', 0, '2026-06-15 10:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (270, 1, '读写分离中', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f270', 0, '2026-06-15 10:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (271, 1, '分库分表侠', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f271', 0, '2026-06-15 10:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (272, 1, '最终一致性', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f272', 0, '2026-06-15 10:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (273, 1, '数据湖守护者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f273', 0, '2026-06-15 10:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (274, 1, '流批一体', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f274', 0, '2026-06-15 10:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (275, 1, '实时计算', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f275', 1, '2026-06-15 10:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (276, 1, '离线数仓', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f276', 0, '2026-06-15 10:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (277, 1, 'OLAP玩家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f277', 0, '2026-06-15 10:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (278, 1, '时序数据库', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f278', 0, '2026-06-14 08:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (279, 1, '图计算达人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f279', 0, '2026-06-14 08:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (280, 1, '特征工程狮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f280', 0, '2026-06-14 08:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (281, 1, '区块链矿工', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f281', 0, '2026-06-14 08:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (282, 1, '智能合约审计', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f282', 0, '2026-06-14 08:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (283, 1, '去中心化梦想', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f283', 0, '2026-06-14 08:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (284, 1, 'Web3先锋', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f284', 0, '2026-06-14 08:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (285, 1, '元宇宙居民', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f285', 1, '2026-06-14 08:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (286, 1, '数字藏品猎人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f286', 0, '2026-06-14 08:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (287, 1, 'DAO组织成员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f287', 0, '2026-06-14 08:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (288, 1, 'Defi矿农', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f288', 0, '2026-06-14 08:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (289, 1, 'NFT收藏家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f289', 0, '2026-06-14 08:55:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (290, 1, '链上分析师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f290', 0, '2026-06-14 09:00:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (291, 1, '物联网极客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f291', 0, '2026-06-14 09:05:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (292, 1, '嵌入式大佬', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f292', 0, '2026-06-14 09:10:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (293, 1, '树莓派玩家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f293', 0, '2026-06-14 09:15:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (294, 1, '传感器猎人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f294', 0, '2026-06-14 09:20:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (295, 1, '边缘计算师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f295', 0, '2026-06-14 09:25:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (296, 1, '自动驾驶梦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f296', 0, '2026-06-14 09:30:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (297, 1, '车联网行者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f297', 0, '2026-06-14 09:35:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (298, 1, '智慧城市', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f298', 0, '2026-06-14 09:40:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (299, 1, '数字孪生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f299', 0, '2026-06-14 09:45:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (300, 1, '工业40', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f300', 1, '2026-06-14 09:50:00', '2026-06-23 20:59:07', '2026-06-23 21:02:55');
INSERT INTO `fans` VALUES (301, 1, '青梅煮酒', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f301', 0, '2026-06-14 09:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (302, 1, '红叶题诗', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f302', 0, '2026-06-14 10:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (303, 1, '松间明月', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f303', 0, '2026-06-14 10:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (304, 1, '石上清泉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f304', 0, '2026-06-14 10:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (305, 1, '竹杖芒鞋', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f305', 1, '2026-06-14 10:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (306, 1, '轻胜马', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f306', 0, '2026-06-13 08:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (307, 1, '谁怕', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f307', 0, '2026-06-13 08:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (308, 1, '一蓑烟雨任平生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f308', 0, '2026-06-13 08:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (309, 1, '料峭春风', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f309', 0, '2026-06-13 08:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (310, 1, '微冷', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f310', 0, '2026-06-13 08:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (311, 1, '山头斜照', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f311', 0, '2026-06-13 08:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (312, 1, '却相迎', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f312', 0, '2026-06-13 08:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (313, 1, '回首向来萧瑟处', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f313', 0, '2026-06-13 08:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (314, 1, '归去', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f314', 0, '2026-06-13 08:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (315, 1, '也无风雨', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f315', 1, '2026-06-13 08:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (316, 1, '也无晴', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f316', 0, '2026-06-13 08:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (317, 1, '野火烧不尽', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f317', 0, '2026-06-13 08:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (318, 1, '春风吹又生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f318', 0, '2026-06-13 09:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (319, 1, '远芳侵古道', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f319', 0, '2026-06-13 09:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (320, 1, '晴翠接荒城', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f320', 0, '2026-06-13 09:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (321, 1, '程序员小Q', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f321', 0, '2026-06-13 09:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (322, 1, '夜猫子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f322', 0, '2026-06-13 09:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (323, 1, '代码即诗', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f323', 0, '2026-06-13 09:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (324, 1, '柠檬精', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f324', 0, '2026-06-13 09:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (325, 1, '佛系青年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f325', 1, '2026-06-13 09:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (326, 1, '吃瓜群众', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f326', 0, '2026-06-13 09:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (327, 1, '躺平大师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f327', 0, '2026-06-13 09:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (328, 1, '内卷战士', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f328', 0, '2026-06-13 09:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (329, 1, '社恐星人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f329', 0, '2026-06-13 09:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (330, 1, '社牛本牛', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f330', 0, '2026-06-13 10:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (331, 1, '熬夜冠军', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f331', 0, '2026-06-13 10:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (332, 1, '早起困难户', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f332', 0, '2026-06-13 10:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (333, 1, '奶茶重度患者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f333', 0, '2026-06-13 10:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (334, 1, '咖啡续命中', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f334', 0, '2026-06-13 10:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (335, 1, '螺蛳粉代言人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f335', 1, '2026-06-13 10:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (336, 1, '火锅达人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f336', 0, '2026-06-13 10:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (337, 1, '撸猫专业户', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f337', 0, '2026-06-13 10:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (338, 1, '养狗积极分子', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f338', 0, '2026-06-13 10:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (339, 1, '绿植杀手', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f339', 0, '2026-06-13 10:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (340, 1, '养生朋克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f340', 0, '2026-06-13 10:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (341, 1, '遛弯大爷', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f341', 0, '2026-06-13 10:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (342, 1, '广场舞新星', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f342', 0, '2026-06-12 07:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (343, 1, '钓鱼老翁', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f343', 0, '2026-06-12 07:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (344, 1, '种菜狂魔', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f344', 0, '2026-06-12 07:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (345, 1, '追剧少女', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f345', 1, '2026-06-12 07:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (346, 1, '番剧猎人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f346', 0, '2026-06-12 07:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (347, 1, '电竞少年', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f347', 0, '2026-06-12 07:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (348, 1, '主机玩家', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f348', 0, '2026-06-12 07:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (349, 1, '桌游爱好者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f349', 0, '2026-06-12 07:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (350, 1, '跑步达人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f350', 0, '2026-06-12 07:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (351, 1, '撸铁战士', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f351', 0, '2026-06-12 07:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (352, 1, '瑜伽修行者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f352', 0, '2026-06-12 07:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (353, 1, '冥想入门', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f353', 0, '2026-06-12 07:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (354, 1, '旅行青蛙', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f354', 0, '2026-06-12 08:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (355, 1, '背包客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f355', 1, '2026-06-12 08:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (356, 1, '露营小能手', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f356', 0, '2026-06-12 08:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (357, 1, '摄影法师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f357', 0, '2026-06-12 08:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (358, 1, '胶片控', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f358', 0, '2026-06-12 08:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (359, 1, '手账达人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f359', 0, '2026-06-12 08:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (360, 1, '乐高建筑师', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f360', 0, '2026-06-12 08:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (361, 1, '键盘侠退隐版', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f361', 0, '2026-06-12 08:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (362, 1, '读书破万卷', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f362', 0, '2026-06-12 08:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (363, 1, '下笔如有神', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f363', 0, '2026-06-12 08:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (364, 1, '乘风破浪的姐姐', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f364', 0, '2026-06-12 08:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (365, 1, '披荆斩棘的哥哥', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f365', 1, '2026-06-12 08:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (366, 1, '孤勇者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f366', 0, '2026-06-12 09:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (367, 1, '暗夜行者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f367', 0, '2026-06-12 09:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (368, 1, '追光者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f368', 0, '2026-06-12 09:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (369, 1, '向阳而生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f369', 0, '2026-06-12 09:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (370, 1, '破茧成蝶', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f370', 0, '2026-06-11 07:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (371, 1, '涅槃重生', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f371', 0, '2026-06-11 07:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (372, 1, '锋芒毕露', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f372', 0, '2026-06-11 07:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (373, 1, '韬光养晦', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f373', 0, '2026-06-11 07:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (374, 1, '大器晚成', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f374', 0, '2026-06-11 07:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (375, 1, '天道酬勤', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f375', 1, '2026-06-11 07:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (376, 1, '厚积薄发', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f376', 0, '2026-06-11 07:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (377, 1, '水滴石穿', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f377', 0, '2026-06-11 07:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (378, 1, '铁杵磨成针', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f378', 0, '2026-06-11 07:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (379, 1, '不积跬步', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f379', 0, '2026-06-11 07:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (380, 1, '无以至千里', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f380', 0, '2026-06-11 07:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (381, 1, '积土成山', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f381', 0, '2026-06-11 07:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (382, 1, '风雨兴焉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f382', 0, '2026-06-11 08:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (383, 1, '积水成渊', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f383', 0, '2026-06-11 08:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (384, 1, '蛟龙生焉', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f384', 0, '2026-06-11 08:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (385, 1, '不积小流', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f385', 1, '2026-06-11 08:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (386, 1, '无以成江海', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f386', 0, '2026-06-11 08:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (387, 1, '骐骥一跃', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f387', 0, '2026-06-11 08:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (388, 1, '不能十步', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f388', 0, '2026-06-11 08:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (389, 1, '驽马十驾', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f389', 0, '2026-06-11 08:35:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (390, 1, '功在不舍', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f390', 0, '2026-06-11 08:40:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (391, 1, '锲而舍之', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f391', 0, '2026-06-11 08:45:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (392, 1, '朽木不折', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f392', 0, '2026-06-11 08:50:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (393, 1, '锲而不舍', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f393', 0, '2026-06-11 08:55:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (394, 1, '金石可镂', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f394', 0, '2026-06-11 09:00:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (395, 1, '青取之于蓝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f395', 1, '2026-06-11 09:05:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (396, 1, '而青于蓝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f396', 0, '2026-06-11 09:10:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (397, 1, '冰水为之', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f397', 0, '2026-06-11 09:15:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (398, 1, '而寒于水', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f398', 0, '2026-06-11 09:20:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (399, 1, '木直中绳', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f399', 0, '2026-06-11 09:25:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');
INSERT INTO `fans` VALUES (400, 1, '輮以为轮', 'https://api.dicebear.com/7.x/avataaars/svg?seed=f400', 0, '2026-06-11 09:30:00', '2026-06-23 20:59:41', '2026-06-23 21:03:10');

-- ----------------------------
-- Table structure for materials
-- ----------------------------
DROP TABLE IF EXISTS `materials`;
CREATE TABLE `materials`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '素材ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '上传者ID',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储路径/URL',
  `file_size` int UNSIGNED NOT NULL COMMENT '文件大小(字节 上限2MB即2097152)',
  `mime_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image/jpeg' COMMENT 'MIME类型(image/jpeg 或 image/png)',
  `is_favorite` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '收藏标记: 1=已收藏 0=未收藏',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '软删除时间(NULL=未删除)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_favorite`(`user_id` ASC, `is_favorite` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '素材管理(图片资源, 支持收藏/删除)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of materials
-- ----------------------------
INSERT INTO `materials` VALUES (1, 1, '7c02a26086f7bdb07832d7d8f5f35207.jpeg', 'https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/1c2a3a08ec76459a92b07cded858575b.jpeg', 1875399, 'image/jpeg', 0, NULL, '2026-06-23 18:14:36', '2026-06-23 18:14:36');
INSERT INTO `materials` VALUES (2, 1, '603bc394465439479e746cc331abadc3.jpeg', 'https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/a319a521af94481787db571317214b17.jpeg', 22905, 'image/jpeg', 0, NULL, '2026-06-23 18:14:45', '2026-06-23 18:14:45');
INSERT INTO `materials` VALUES (3, 1, 'db3abd518317529bbc5b1f1ba95ca005.jpeg', 'https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/45957eebc6524949a4d87e7efe7e3fc0.jpeg', 98764, 'image/jpeg', 0, NULL, '2026-06-23 18:14:52', '2026-06-23 18:14:52');
INSERT INTO `materials` VALUES (4, 1, 'fc148ac99de1a0b18e48dccd1571a5ec.jpeg', 'https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/60b09c49230541fa933580c9cd902eaf.jpeg', 122592, 'image/jpeg', 0, NULL, '2026-06-23 18:15:06', '2026-06-23 18:15:06');
INSERT INTO `materials` VALUES (5, 1, '9c56d2e826ce4ea0a82035345f661435.jpeg', 'https://heimamovies.oss-cn-beijing.aliyuncs.com/materials/1/20260623/b49495fb6d1f4d7fbcd4ca44dfe13a45.jpeg', 647158, 'image/jpeg', 1, NULL, '2026-06-23 18:15:43', '2026-06-23 18:15:43');

-- ----------------------------
-- Table structure for user_agreement_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_agreement_logs`;
CREATE TABLE `user_agreement_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `agreement_type` tinyint NOT NULL DEFAULT 0 COMMENT '协议类型: 0用户协议 1隐私政策',
  `agreed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '同意时间',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '客户端IP地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_agreed_at`(`agreed_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户协议和隐私政策确认记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_agreement_logs
-- ----------------------------
INSERT INTO `user_agreement_logs` VALUES (1, 1, 1, '2026-06-23 18:10:55', NULL);
INSERT INTO `user_agreement_logs` VALUES (2, 1, 2, '2026-06-23 18:10:55', NULL);
INSERT INTO `user_agreement_logs` VALUES (3, 1, 1, '2026-06-23 18:33:37', NULL);
INSERT INTO `user_agreement_logs` VALUES (4, 1, 2, '2026-06-23 18:33:37', NULL);
INSERT INTO `user_agreement_logs` VALUES (5, 1, 1, '2026-06-23 18:34:56', NULL);
INSERT INTO `user_agreement_logs` VALUES (6, 1, 2, '2026-06-23 18:34:56', NULL);
INSERT INTO `user_agreement_logs` VALUES (7, 1, 1, '2026-06-23 18:35:01', NULL);
INSERT INTO `user_agreement_logs` VALUES (8, 1, 2, '2026-06-23 18:35:01', NULL);
INSERT INTO `user_agreement_logs` VALUES (9, 1, 1, '2026-06-23 20:47:28', NULL);
INSERT INTO `user_agreement_logs` VALUES (10, 1, 2, '2026-06-23 20:47:28', NULL);
INSERT INTO `user_agreement_logs` VALUES (11, 1, 1, '2026-06-23 21:17:51', NULL);
INSERT INTO `user_agreement_logs` VALUES (12, 1, 2, '2026-06-23 21:17:51', NULL);
INSERT INTO `user_agreement_logs` VALUES (13, 1, 1, '2026-06-24 12:56:08', NULL);
INSERT INTO `user_agreement_logs` VALUES (14, 1, 2, '2026-06-24 12:56:08', NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名(登录账号)',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码哈希(BCrypt)',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '账号状态: 1=正常 0=禁用',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '自媒体创作者用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'xiaoming', '$2b$12$vuUg/NSWsj6vds9NigBw9.9e2Fnf7OYCkmNmsgA1006pht5k121He', NULL, 1, '2026-06-24 12:56:08', '2026-06-23 18:09:56', '2026-06-23 18:10:42');

SET FOREIGN_KEY_CHECKS = 1;
