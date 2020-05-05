-- phpMyAdmin SQL Dump
-- version 4.3.13
-- http://www.phpmyadmin.net
--
-- Host: gdcchueomenb.mysql.sae.sina.com.cn:10105
-- Generation Time: 2020-05-05 22:45:58
-- 服务器版本： 5.6.23-72.1-log
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `player`
--

-- --------------------------------------------------------

--
-- 表的结构 `store_item`
--

CREATE TABLE IF NOT EXISTS `store_item` (
  `ItemName` varchar(100) NOT NULL COMMENT '物品名字',
  `Shard` int(10) NOT NULL COMMENT '碎片价格',
  `Price` int(10) NOT NULL COMMENT '金钱价格',
  `Validity` int(5) DEFAULT NULL COMMENT '有效期',
  `Purchaseable` tinyint(1) NOT NULL COMMENT '可购买',
  `Pack` varchar(100) DEFAULT NULL COMMENT '包含物品',
  `Type` varchar(20) NOT NULL COMMENT '物品类型',
  `NoteName` varchar(20) NOT NULL COMMENT '物品名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品表';

TRUNCATE `store_item`;
--
-- 转存表中的数据 `store_item`
--

INSERT INTO `store_item` (`ItemName`, `Shard`, `Price`, `Validity`, `Purchaseable`, `Pack`, `Type`, `NoteName`) VALUES
('nevermore', -1, 250, NULL, 1, NULL, 'hero', '塔尔塔罗斯'),
('phantom_assassin_01', -1, 50, NULL, 1, NULL, 'skin', '纯金影月守望者'),
('potion', 100, 10, NULL, 1, NULL, 'gameplay', '药水礼包'),
('rubick_01', -1, 50, NULL, 1, NULL, 'skin', '纯金时空魔术师'),
('spectre', -1, 300, NULL, 1, NULL, 'hero', '墨丘利'),
('templar_assassin', -1, 200, NULL, 1, NULL, 'hero', '天启者'),
('windrunner_01', -1, 50, NULL, 1, NULL, 'skin', '纯金风行者'),
('wing_01', -1, 50, NULL, 1, NULL, 'particle', '纯金翅膀'),
('pet_1', 100, 10, NULL, 1, NULL, 'pet', '勇敢的小鸡'),
('pet_2', 200, 20, NULL, 0, NULL, 'pet', '火箭小鸡'),
('pet_3', 800, 80, NULL, 0, NULL, 'pet', '纯金咬人箱'),
('pet_4', 400, 40, NULL, 1, NULL, 'pet', '膜法师'),
('pet_5', 800, 80, NULL, 0, NULL, 'pet', '纯金小螈'),
('pet_6', 800, 80, NULL, 1, NULL, 'pet', '纯金飞龙'),
('pet_7', 800, 80, NULL, 0, NULL, 'pet', '纯金独角仙'),
('pet_8', 800, 80, NULL, 0, NULL, 'pet', '纯金黑曜石小鸟'),
('pet_9', 800, 80, NULL, 1, NULL, 'pet', '纯金末日小子'),
('pet_10', 800, 80, NULL, 0, NULL, 'pet', '纯金珍小宝'),
('pet_11', 800, 80, NULL, 0, NULL, 'pet', '纯金血魔宝宝'),
('pet_12', 800, 80, NULL, 0, NULL, 'pet', '纯金剧毒宝宝'),
('pet_13', 400, 40, NULL, 0, NULL, 'pet', '天照小神'),
('pet_14', 400, 40, NULL, 0, NULL, 'pet', '腥红小螈'),
('pet_15', 400, 40, NULL, 1, NULL, 'pet', '小火龙'),
('pet_16', 400, 40, NULL, 1, NULL, 'pet', '小冰龙'),
('pet_17', 400, 40, NULL, 0, NULL, 'pet', '蜚廉'),
('pet_18', 400, 40, NULL, 0, NULL, 'pet', '灵犀弗拉尔'),
('pet_19', 400, 40, NULL, 0, NULL, 'pet', '圣盾蟹小蜗'),
('pet_20', 400, 40, NULL, 0, NULL, 'pet', '苦木小独苗'),
('pet_21', 400, 40, NULL, 0, NULL, 'pet', '战龟飞船'),
('pet_22', 400, 40, NULL, 1, NULL, 'pet', '哎呀'),
('pet_23', 400, 40, NULL, 0, NULL, 'pet', '地狗天猫'),
('pet_24', 400, 40, NULL, 1, NULL, 'pet', '小兔几'),
('pet_25', 200, 20, NULL, 0, NULL, 'pet', '飞掠之翼'),
('pet_26', 200, 20, NULL, 0, NULL, 'pet', '蔚蓝小龙'),
('pet_27', 200, 20, NULL, 0, NULL, 'pet', '白小虎'),
('pet_28', 200, 20, NULL, 0, NULL, 'pet', '八小戒'),
('pet_29', 200, 20, NULL, 0, NULL, 'pet', '海狸勇士'),
('pet_30', 200, 20, NULL, 0, NULL, 'pet', '老绅士'),
('pet_31', 200, 20, NULL, 0, NULL, 'pet', '伐士奇'),
('pet_32', 200, 20, NULL, 0, NULL, 'pet', '勇士欢欢'),
('pet_33', 200, 20, NULL, 0, NULL, 'pet', '丛林羊人'),
('pet_34', 200, 20, NULL, 0, NULL, 'pet', '三只小驴'),
('pet_35', 200, 20, NULL, 0, NULL, 'pet', '神猫侠'),
('pet_36', 200, 20, NULL, 0, NULL, 'pet', '胜利记录机'),
('pet_37', 200, 20, NULL, 1, NULL, 'pet', '虚空霸王龙'),
('pet_38', 200, 20, NULL, 0, NULL, 'pet', '章鱼斯派罗'),
('pet_39', 200, 20, NULL, 0, NULL, 'pet', '抬轿兄弟'),
('pet_40', 200, 20, NULL, 0, NULL, 'pet', '丰豚公主'),
('pet_41', 200, 20, NULL, 1, NULL, 'pet', '千里马'),
('pet_42', 200, 20, NULL, 0, NULL, 'pet', '小龙尤涅克斯'),
('pet_43', 200, 20, NULL, 0, NULL, 'pet', '狐灵小银'),
('pet_44', 200, 20, NULL, 1, NULL, 'pet', '斯拉萌'),
('pet_45', 200, 20, NULL, 0, NULL, 'pet', '骑蟹小恶魔'),
('pet_46', 200, 20, NULL, 0, NULL, 'pet', '诡笑邪灵'),
('pet_47', 200, 20, NULL, 0, NULL, 'pet', '章鱼保罗'),
('pet_48', 200, 20, NULL, 0, NULL, 'pet', '侍卫波利'),
('pet_49', 200, 20, NULL, 1, NULL, 'pet', '飞僵小宝'),
('pet_50', 200, 20, NULL, 0, NULL, 'pet', '雷克'),
('pet_51', 200, 20, NULL, 0, NULL, 'pet', '皇家小狮鹫'),
('pet_52', 200, 20, NULL, 0, NULL, 'pet', '胡小桃'),
('pet_53', 200, 20, NULL, 0, NULL, 'pet', '小蘑菇'),
('pet_54', 200, 20, NULL, 0, NULL, 'pet', '鹦鹉副将'),
('pet_55', 200, 20, NULL, 0, NULL, 'pet', '骑鸟小恶魔'),
('pet_56', 200, 20, NULL, 0, NULL, 'pet', '骑象小恶魔'),
('pet_57', 200, 20, NULL, 1, NULL, 'pet', '地狱双头狗'),
('pet_58', 200, 20, NULL, 0, NULL, 'pet', '金虺翠莺'),
('pet_59', 200, 20, NULL, 0, NULL, 'pet', '小石人瓦尔'),
('pet_60', 200, 20, NULL, 0, NULL, 'pet', '小熊人'),
('pet_61', 200, 20, NULL, 0, NULL, 'pet', '小仙鹤'),
('pet_62', 800, 80, NULL, 0, NULL, 'pet', '铂金肉山宝宝'),
('pet_63', 100, 10, NULL, 0, NULL, 'pet', '神小兔'),
('pet_64', 100, 10, NULL, 0, NULL, 'pet', '蝾小螈'),
('pet_65', 100, 10, NULL, 0, NULL, 'pet', '蓝电小马'),
('pet_66', 100, 10, NULL, 0, NULL, 'pet', '毛毛鱼'),
('pet_67', 100, 10, NULL, 0, NULL, 'pet', '臭鼬香香'),
('pet_68', 100, 10, NULL, 0, NULL, 'pet', '榛榛'),
('pet_69', 100, 10, NULL, 0, NULL, 'pet', '变色龙蝶'),
('pet_70', 100, 10, NULL, 0, NULL, 'pet', '呱'),
('pet_71', 100, 10, NULL, 0, NULL, 'pet', '狂奔小恶魔'),
('pet_72', 100, 10, NULL, 0, NULL, 'pet', '萌蛛'),
('pet_73', 100, 10, NULL, 0, NULL, 'pet', '机灵本'),
('pet_74', 100, 10, NULL, 0, NULL, 'pet', '小鲨鱼'),
('pet_75', 100, 10, NULL, 0, NULL, 'pet', '草泥马'),
('pet_76', 100, 10, NULL, 0, NULL, 'pet', '钢小驴'),
('pet_77', 100, 10, NULL, 0, NULL, 'pet', '玉兔美萱'),
('pet_78', 100, 10, NULL, 0, NULL, 'pet', '矿车鼠'),
('pet_79', 100, 10, NULL, 0, NULL, 'pet', '奥比幽灵'),
('pet_80', 100, 10, NULL, 0, NULL, 'pet', '旗龟'),
('pet_81', 100, 10, NULL, 0, NULL, 'pet', '七彩亚龙'),
('pet_82', 100, 10, NULL, 0, NULL, 'pet', '魔法飞毯小恶魔'),
('pet_83', 100, 10, NULL, 0, NULL, 'pet', '树墩'),
('pet_84', 100, 10, NULL, 0, NULL, 'pet', '泰伦'),
('pet_85', 100, 10, NULL, 1, NULL, 'pet', '充电宝'),
('pet_86', 100, 10, NULL, 1, NULL, 'pet', '小鸟'),
('pet_87', 100, 10, NULL, 0, NULL, 'pet', '骑龟小恶魔'),
('pet_88', 800, 80, NULL, 0, NULL, 'pet', '金色矿车鼠'),
('pet_89', 200, 20, NULL, 0, NULL, 'pet', '矿车鼠小弟'),
('pet_90', 800, 80, NULL, 0, NULL, 'pet', '黄金肉山宝宝');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `store_item`
--

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
