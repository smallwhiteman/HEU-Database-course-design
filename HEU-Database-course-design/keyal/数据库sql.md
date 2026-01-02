# 总共十张表

![image-20260102204247846](C:\Users\keyal\AppData\Roaming\Typora\typora-user-images\image-20260102204247846.png)

----

## 每张表的表名和属性

```sql
-- ----------------------------
-- Table structure for dispatcher
-- ----------------------------
DROP TABLE IF EXISTS `dispatcher`;
CREATE TABLE `dispatcher`  (
  `dispatcher_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dispatcher_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dispatcher_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`dispatcher_id`) USING BTREE,
  UNIQUE INDEX `dispatcher_id`(`dispatcher_id`) USING BTREE,
  INDEX `dispatcher_name`(`dispatcher_name`) USING BTREE,
  INDEX `dispatcher_phone`(`dispatcher_phone`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for fastfood_shop
-- ----------------------------
-- 添加avg_score和total_comments字段
DROP TABLE IF EXISTS `fastfood_shop`;
CREATE TABLE `fastfood_shop`  (
  `shop_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int NOT NULL COMMENT '价格',
  `m_sale_v` int NOT NULL COMMENT '月销售量',
  `avg_score` DECIMAL(3, 2) DEFAULT 0.00 COMMENT '平均评分(0.00-5.00)',
  `total_comments` int DEFAULT 0 COMMENT '总评论数',
  `n_sale_v` int DEFAULT 0 COMMENT '年销售量(根据E-R图新增)',
  `attribute` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '店铺属性',
  PRIMARY KEY (`shop_name`) USING BTREE,
  UNIQUE INDEX `shop_name`(`shop_name`) USING BTREE,
  INDEX `price`(`price`) USING BTREE,
  INDEX `m_sale_v`(`m_sale_v`) USING BTREE,
  INDEX `idx_avg_score`(`avg_score`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oorder
-- ----------------------------
DROP TABLE IF EXISTS `oorder`;
CREATE TABLE `oorder`  (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `order_money` int NOT NULL,
  `order_way` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cons_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cons_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cons_addre` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `checked` int NULL DEFAULT 0,
  `create_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id`) USING BTREE,
  INDEX `shop_name`(`shop_name`) USING BTREE,
  INDEX `order_money`(`order_money`) USING BTREE,
  INDEX `order_way`(`order_way`) USING BTREE,
  INDEX `cons_phone`(`cons_phone`) USING BTREE,
  INDEX `cons_name`(`cons_name`) USING BTREE,
  INDEX `cons_addre`(`cons_addre`) USING BTREE,
  INDEX `checked`(`checked`) USING BTREE,
  INDEX `create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
-- 添加comments表 --
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `comment_id` INT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `shop_name` VARCHAR(50) NOT NULL COMMENT '店铺名称',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `telephone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `score` TINYINT NOT NULL COMMENT '评分(1-5分)',
  `content` TEXT COMMENT '评论内容',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `is_deleted` TINYINT DEFAULT 0 COMMENT '是否删除(0=正常,1=删除)',
  PRIMARY KEY (`comment_id`) USING BTREE,
  UNIQUE INDEX `comment_id` (`comment_id`) USING BTREE,
  INDEX `idx_shop_name` (`shop_name`) USING BTREE,
  INDEX `idx_username` (`username`) USING BTREE,
  INDEX `idx_score` (`score`) USING BTREE,
  INDEX `idx_create_time` (`create_time`) USING BTREE,
  CONSTRAINT `fk_comments_shop` FOREIGN KEY (`shop_name`) 
    REFERENCES `fastfood_shop` (`shop_name`) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`telephone`) 
    REFERENCES `user` (`telephone`) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci 
COMMENT = '店铺评论表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for orderway
-- ----------------------------
DROP TABLE IF EXISTS `orderway`;
CREATE TABLE `orderway`  (
  `orderway_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '订餐方式',
  `count` int NOT NULL COMMENT '该种方式的订餐数量',
  PRIMARY KEY (`orderway_name`) USING BTREE,
  UNIQUE INDEX `orderway_name`(`orderway_name`) USING BTREE,
  INDEX `count`(`count`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for server
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server`  (
  `service_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务员编号',
  `service_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fastfood_shop_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所在的店铺名字',
  PRIMARY KEY (`service_id`) USING BTREE,
  UNIQUE INDEX `service_id`(`service_id`) USING BTREE,
  INDEX `service_name`(`service_name`) USING BTREE,
  INDEX `fastfood_shop_name`(`fastfood_shop_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `telephone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `role` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE COMMENT '主键索引，选UNIQUE',
  INDEX `username`(`username`) USING BTREE,
  INDEX `password`(`password`) USING BTREE,
  INDEX `telephone`(`telephone`) USING BTREE,
  INDEX `role`(`role`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_msg
-- ----------------------------
DROP TABLE IF EXISTS `user_msg`;
CREATE TABLE `user_msg`  (
  `id` int UNSIGNED NULL DEFAULT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `sex` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `age` int NOT NULL,
  `mail` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  INDEX `userid`(`id`) USING BTREE,
  INDEX `real_name`(`real_name`) USING BTREE,
  INDEX `sex`(`sex`) USING BTREE,
  INDEX `age`(`age`) USING BTREE,
  INDEX `mail`(`mail`) USING BTREE,
  INDEX `phone`(`phone`) USING BTREE,
  INDEX `user_name`(`user_name`) USING BTREE,
  CONSTRAINT `userid` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for wuliu
-- ----------------------------
DROP TABLE IF EXISTS `wuliu`;
CREATE TABLE `wuliu`  (
  `order_id` int NOT NULL COMMENT '订单的编号',
  `cons_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `disp_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `deliver_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ended` int NOT NULL DEFAULT 0 COMMENT '是否结束',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id`) USING BTREE,
  INDEX `cons_phone`(`cons_phone`) USING BTREE,
  INDEX `disp_id`(`disp_id`) USING BTREE,
  INDEX `deliver_time`(`deliver_time`) USING BTREE,
  INDEX `ended`(`ended`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `feedback_id` INT NOT NULL AUTO_INCREMENT COMMENT '反馈ID',
  `user_id` INT UNSIGNED NOT NULL COMMENT '用户ID（外键关联user.id）',
  `username` VARCHAR(20) NOT NULL COMMENT '用户名',
  `telephone` VARCHAR(20) NOT NULL COMMENT '用户电话',
  `feedback_content` TEXT NOT NULL COMMENT '反馈内容',
  `feedback_type` VARCHAR(20) DEFAULT '建议' COMMENT '反馈类型：投诉/建议/咨询/其他',
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`feedback_id`) USING BTREE,
  UNIQUE KEY `idx_feedback_id` (`feedback_id`) USING BTREE,
  INDEX `idx_user_id` (`user_id`) USING BTREE,
  INDEX `idx_telephone` (`telephone`) USING BTREE,
  INDEX `idx_create_time` (`create_time`) USING BTREE,
  CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) 
    REFERENCES `user` (`id`) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci 
COMMENT = '用户反馈表' ROW_FORMAT = DYNAMIC;

```





