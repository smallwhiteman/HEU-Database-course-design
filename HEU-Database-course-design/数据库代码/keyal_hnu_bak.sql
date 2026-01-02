/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : localhost:3306
 Source Schema         : keyal_hnu

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 20/11/2023 19:58:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;





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
-- Records of dispatcher
-- ----------------------------
INSERT INTO `dispatcher` VALUES ('111111', '路人甲', '11111111111');
INSERT INTO `dispatcher` VALUES ('222222', '路人乙', '22222222222');
INSERT INTO `dispatcher` VALUES ('333333', '路人丙', '33333333333');
INSERT INTO `dispatcher` VALUES ('114514', '何意味', '44444444444');

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
-- Records of fastfood_shop
-- ----------------------------
INSERT INTO `fastfood_shop` (`shop_name`, `price`, `m_sale_v`, `avg_score`, `total_comments`) VALUES 
('黄鼠狼鸡公煲', 15, 100, 4.50, 10),
('天马自选饭', 10, 200, 4.20, 15),
('天马馋嘴鸭', 16, 61, 4.70, 8),
('师大烤盘饭', 12, 101, 4.30, 9),
('师大章丘炒鸡', 16, 99, 4.60, 7),
('岳麓汇蛋炒饭', 10, 101, 4.40, 6),
('小美麻辣烫', 15, 103, 4.80, 5),
('隆江猪脚饭', 20, 52, 4.90, 4);

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
-- Records of oorder
-- ----------------------------
INSERT INTO `oorder` VALUES (1, '黄鼠狼鸡公煲', 12, '人工订餐', '13525188888', '潘俊衡', '3区11', 0, '2025-12-16 14:35:17');
INSERT INTO `oorder` VALUES (2, '岳麓汇蛋炒饭', 10, '人工订餐', '13525188888', '傅程凯', '3区11', 2, '2025-12-16 14:35:26');
INSERT INTO `oorder` VALUES (3, '隆江猪脚饭', 20, '人工订餐', '13525188888', '思思', '3区9', 0, '2025-12-16 14:35:35');
------------------------------------------------------------------------------------------------------------------------------

-- (修改嘛?)

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
-- Records of comments
-- ----------------------------
INSERT INTO `comments` (`shop_name`, `username`, `telephone`, `score`, `content`) VALUES
('黄鼠狼鸡公煲', 'iu', '13525188888', 5, '味道超级好，鸡肉很嫩，配菜丰富！'),
('黄鼠狼鸡公煲', 'mty', '15967789756', 3, '味道不错，就是有点咸，下次少放盐'),
('小美麻辣烫', 'iu', '13525188888', 4, '汤底一般，菜品还算新鲜'),
('隆江猪脚饭', 'mty', '15967789756', 5, '猪脚炖得很烂，非常入味！'),
('天马自选饭', 'iu', '13525188888', 4, '性价比高，选择多样');

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
-- Records of orderway
-- ----------------------------
INSERT INTO `orderway` VALUES ('网上订餐', 51);
INSERT INTO `orderway` VALUES ('人工订餐', 108);

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
-- Records of server
-- ----------------------------
INSERT INTO `server` VALUES ('100000', '服务员1号', '师大烤盘饭');
INSERT INTO `server` VALUES ('100001', '小美', '小美麻辣烫');
INSERT INTO `server` VALUES ('100002', '黄鼠狼', '黄鼠狼鸡公煲');

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
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (2, 'iu', '123456789', '13525188888', 0);
INSERT INTO `user` VALUES (3, 'mty', '123456', '15967789756', 0);
-- 管理员
INSERT INTO `user` VALUES (4, 'admin', 'admin123', '13888888888', 1);

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
-- Records of user_msg
-- ----------------------------
INSERT INTO `user_msg` VALUES (2, '李知恩', '男', 18, '320836@qq.com', '13525199999', 'iu');
INSERT INTO `user_msg` VALUES (3, '马天宇', '男', 20, '787898@qq.com', '11111111111', '马天宇');

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
-- Records of wuliu
-- ----------------------------

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

-- ----------------------------
-- Records of feedback
-- ----------------------------
INSERT INTO `feedback` (`user_id`, `username`, `telephone`, `feedback_content`, `feedback_type`) VALUES
(2, 'iu', '13525188888', '配送速度有点慢，希望能改进', '投诉'),
(2, 'iu', '13525188888', '建议增加更多优惠活动', '建议'),
(3, 'mty', '15967789756', '商家服务态度很好，点赞！', '其他'),
(2, 'iu', '13525188888', '订单状态更新不及时', '投诉'),
(3, 'mty', '15967789756', '希望增加更多的支付方式', '建议');

























-- ----------------------------
-- View structure for sended_order
-- ----------------------------
DROP VIEW IF EXISTS `sended_order`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `sended_order` AS select `oorder`.`order_id` AS `order_id`,`oorder`.`shop_name` AS `shop_name`,`oorder`.`order_money` AS `order_money`,`oorder`.`order_way` AS `order_way`,`oorder`.`cons_phone` AS `cons_phone`,`oorder`.`cons_name` AS `cons_name`,`oorder`.`cons_addre` AS `cons_addre`,`wuliu`.`disp_id` AS `disp_id`,`wuliu`.`deliver_time` AS `deliver_time`,`dispatcher`.`dispatcher_phone` AS `dispatcher_phone` from ((`oorder` join `wuliu` on((`oorder`.`order_id` = `wuliu`.`order_id`))) join `dispatcher` on((`wuliu`.`disp_id` = `dispatcher`.`dispatcher_id`))) where (`oorder`.`checked` = 2);

-- ----------------------------
-- View structure for sending_order
-- ----------------------------
DROP VIEW IF EXISTS `sending_order`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `sending_order` AS select `oorder`.`order_id` AS `order_id`,`oorder`.`shop_name` AS `shop_name`,`oorder`.`order_money` AS `order_money`,`oorder`.`order_way` AS `order_way`,`oorder`.`cons_phone` AS `cons_phone`,`oorder`.`cons_name` AS `cons_name`,`oorder`.`cons_addre` AS `cons_addre`,`wuliu`.`disp_id` AS `disp_id`,`wuliu`.`deliver_time` AS `deliver_time`,`dispatcher`.`dispatcher_phone` AS `dispatcher_phone` from ((`oorder` join `wuliu` on((`oorder`.`order_id` = `wuliu`.`order_id`))) join `dispatcher` on((`wuliu`.`disp_id` = `dispatcher`.`dispatcher_id`))) where (`oorder`.`checked` = 1);


-- ----------------------------
-- View structure for shop_score_detail 
-- ----------------------------

-- 1. 店铺评分详情视图
CREATE OR REPLACE VIEW `shop_score_detail` AS
SELECT 
    fs.`shop_name`,
    fs.`price`,
    fs.`m_sale_v`,
    fs.`avg_score`,
    fs.`total_comments`,
    -- 评分等级（5星制）
    CASE 
        WHEN fs.avg_score >= 4.5 THEN '★★★★★'
        WHEN fs.avg_score >= 4.0 THEN '★★★★☆'
        WHEN fs.avg_score >= 3.5 THEN '★★★☆☆'
        WHEN fs.avg_score >= 3.0 THEN '★★☆☆☆'
        ELSE '★☆☆☆☆'
    END AS `star_rating`,
    -- 最近一条评论
    (SELECT c.`content` 
     FROM `comments` c 
     WHERE c.`shop_name` = fs.`shop_name` 
       AND c.`is_deleted` = 0 
     ORDER BY c.`create_time` DESC 
     LIMIT 1) AS `latest_comment`
FROM `fastfood_shop` fs
ORDER BY fs.`avg_score` DESC;


-----------------------------
-- View structure for user_comments_history
----------------------------

-- 2. 用户评论历史视图
CREATE OR REPLACE VIEW `user_comments_history` AS
SELECT 
    u.`id` AS `user_id`,
    u.`username`,
    c.`shop_name`,
    c.`score`,
    c.`content`,
    c.`create_time`,
    fs.`avg_score` AS `shop_avg_score`
FROM `user` u
JOIN `comments` c ON u.`telephone` = c.`telephone`
JOIN `fastfood_shop` fs ON c.`shop_name` = fs.`shop_name`
WHERE c.`is_deleted` = 0
ORDER BY c.`create_time` DESC;
























-- ----------------------------
-- Triggers structure for table oorder
-- ----------------------------
DROP TRIGGER IF EXISTS `order_insert`;
delimiter ;;
CREATE TRIGGER `order_insert` AFTER INSERT ON `oorder` FOR EACH ROW BEGIN
UPDATE orderway 
SET orderway.count=orderway.count+1
WHERE orderway.orderway_name=new.order_way;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table oorder
-- ----------------------------
DROP TRIGGER IF EXISTS `order_insert_sale`;
delimiter ;;
CREATE TRIGGER `order_insert_sale` AFTER INSERT ON `oorder` FOR EACH ROW BEGIN
UPDATE fastfood_shop
SET fastfood_shop.m_sale_v=fastfood_shop.m_sale_v+1
WHERE fastfood_shop.shop_name=new.shop_name;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table oorder
-- ----------------------------
DROP TRIGGER IF EXISTS `order_update`;
delimiter ;;
CREATE TRIGGER `order_update` AFTER UPDATE ON `oorder` FOR EACH ROW BEGIN
if(new.order_way!=old.order_way)
	then
	UPDATE orderway SET orderway.count=orderway.count-1 WHERE orderway.orderway_name=old.order_way;
	UPDATE orderway SET orderway.count=orderway.count+1 WHERE orderway.orderway_name=new.order_way;
	END IF;
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table oorder
-- ----------------------------
DROP TRIGGER IF EXISTS `order_delete`;
delimiter ;;
CREATE TRIGGER `order_delete` AFTER DELETE ON `oorder` FOR EACH ROW BEGIN
UPDATE orderway
SET orderway.count=orderway.count-1
WHERE orderway.orderway_name=old.order_way;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table oorder
-- ----------------------------
DROP TRIGGER IF EXISTS `order_delete_sale`;
delimiter ;;
CREATE TRIGGER `order_delete_sale` AFTER DELETE ON `oorder` FOR EACH ROW BEGIN
UPDATE fastfood_shop
SET fastfood_shop.m_sale_v=fastfood_shop.m_sale_v-1
WHERE fastfood_shop.shop_name=old.shop_name;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table wuliu
-- ----------------------------
DROP TRIGGER IF EXISTS `wuliu_insert`;
delimiter ;;
CREATE TRIGGER `wuliu_insert` AFTER INSERT ON `wuliu` FOR EACH ROW BEGIN
UPDATE oorder
SET oorder.checked=1
WHERE oorder.order_id=new.order_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- Triggers structure for table comments
-- ----------------------------
-- 1. 新增评论时更新店铺平均分
DROP TRIGGER IF EXISTS `update_shop_score_insert`;
DELIMITER ;;
CREATE TRIGGER `update_shop_score_insert` 
AFTER INSERT ON `comments` 
FOR EACH ROW 
BEGIN
    DECLARE avg_score DECIMAL(3,2);
    DECLARE total_comments INT;
    
    -- 计算新的平均分
    SELECT 
        AVG(score),
        COUNT(*)
    INTO 
        avg_score,
        total_comments
    FROM `comments` 
    WHERE `shop_name` = NEW.shop_name 
      AND `is_deleted` = 0;
    
    -- 更新店铺表
    UPDATE `fastfood_shop` 
    SET 
        `avg_score` = avg_score,
        `total_comments` = total_comments
    WHERE `shop_name` = NEW.shop_name;
    
    -- 记录评分历史
    INSERT INTO `score_history` (`shop_name`, `new_score`, `change_reason`)
    VALUES (NEW.shop_name, avg_score, '新增评论');
END;;
DELIMITER ;

-- 2. 更新评论时重新计算评分（简化版）
DROP TRIGGER IF EXISTS `update_shop_score_update`;
DELIMITER ;;
CREATE TRIGGER `update_shop_score_update` 
AFTER UPDATE ON `comments` 
FOR EACH ROW 
BEGIN
    -- 声明变量
    DECLARE v_avg_score DECIMAL(3,2);
    DECLARE v_total_comments INT;
    
    -- 只有当评分被修改时才更新
    IF OLD.score != NEW.score THEN
        -- 计算新的平均分（根据E-R图，使用shop_name关联）
        SELECT 
            AVG(score),
            COUNT(*)
        INTO 
            v_avg_score,
            v_total_comments
        FROM `comments` 
        WHERE `shop_name` = NEW.shop_name;
        
        -- 更新店铺表
        UPDATE `fastfood_shop` 
        SET 
            `avg_score` = IFNULL(v_avg_score, 0),
            `total_comments` = v_total_comments
        WHERE `shop_name` = NEW.shop_name;
    END IF;
END;;
DELIMITER ;


-- 3. 删除评论时更新评分
DROP TRIGGER IF EXISTS `update_shop_score_delete`;
DELIMITER ;;
CREATE TRIGGER `update_shop_score_delete` 
AFTER DELETE ON `comments` 
FOR EACH ROW 
BEGIN
    DECLARE avg_score DECIMAL(3,2);
    DECLARE total_comments INT;
    
    -- 重新计算平均分
    SELECT 
        AVG(score),
        COUNT(*)
    INTO 
        avg_score,
        total_comments
    FROM `comments` 
    WHERE `shop_name` = OLD.shop_name 
      AND `is_deleted` = 0;
    
    -- 处理所有评论都被删除的情况
    IF avg_score IS NULL THEN
        SET avg_score = 0.00;
        SET total_comments = 0;
    END IF;
    
    -- 更新店铺表
    UPDATE `fastfood_shop` 
    SET 
        `avg_score` = avg_score,
        `total_comments` = total_comments
    WHERE `shop_name` = OLD.shop_name;
    
    -- 记录评分历史
    INSERT INTO `score_history` (`shop_name`, `old_score`, `new_score`, `change_reason`)
    VALUES (OLD.shop_name, OLD.score, avg_score, '删除评论');
END;;
DELIMITER ;














-- ----------------------------
-- Stored Procedures for comments
-- ----------------------------

-- 1. 添加评论的存储过程
DROP PROCEDURE IF EXISTS `sp_add_comment`;
DELIMITER ;;
CREATE PROCEDURE `sp_add_comment`(
    IN p_shop_name VARCHAR(50),
    IN p_username VARCHAR(50),
    IN p_telephone VARCHAR(20),
    IN p_score TINYINT,
    IN p_content TEXT
)
BEGIN
    -- 参数验证
    IF p_score < 1 OR p_score > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '评分必须在1-5分之间';
    END IF;
    
    -- 检查用户是否存在
    IF NOT EXISTS (SELECT 1 FROM `user` WHERE `telephone` = p_telephone) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '用户不存在';
    END IF;
    
    -- 检查店铺是否存在
    IF NOT EXISTS (SELECT 1 FROM `fastfood_shop` WHERE `shop_name` = p_shop_name) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '店铺不存在';
    END IF;
    
    -- 插入评论
    INSERT INTO `comments` (
        `shop_name`,
        `username`,
        `telephone`,
        `score`,
        `content`
    ) VALUES (
        p_shop_name,
        p_username,
        p_telephone,
        p_score,
        p_content
    );
    
    -- 返回成功信息
    SELECT '评论添加成功' AS `message`, LAST_INSERT_ID() AS `comment_id`;
END;;
DELIMITER ;


-- ----------------------------
-- Stored Procedures for fastfood_shop  
-- ----------------------------

-- 2. 获取店铺评分统计的存储过程
DROP PROCEDURE IF EXISTS `sp_get_shop_score_stats`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_shop_score_stats`(
    IN p_shop_name VARCHAR(50)
)
BEGIN
    -- 店铺评分统计
    SELECT 
        fs.`shop_name`,
        fs.`avg_score`,
        fs.`total_comments`,
        -- 各评分数量统计
        COUNT(CASE WHEN c.`score` = 5 THEN 1 END) AS `count_5star`,
        COUNT(CASE WHEN c.`score` = 4 THEN 1 END) AS `count_4star`,
        COUNT(CASE WHEN c.`score` = 3 THEN 1 END) AS `count_3star`,
        COUNT(CASE WHEN c.`score` = 2 THEN 1 END) AS `count_2star`,
        COUNT(CASE WHEN c.`score` = 1 THEN 1 END) AS `count_1star`,
        -- 最近一周评论数
        COUNT(CASE WHEN c.`create_time` >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 1 END) AS `recent_7days`
    FROM `fastfood_shop` fs
    LEFT JOIN `comments` c ON fs.`shop_name` = c.`shop_name` AND c.`is_deleted` = 0
    WHERE fs.`shop_name` = p_shop_name
    GROUP BY fs.`shop_name`, fs.`avg_score`, fs.`total_comments`;
END;;
DELIMITER ;