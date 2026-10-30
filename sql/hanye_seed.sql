-- 苍穹外卖 hanye_take_out 完整建表与种子数据（与后端实体对齐）
DROP DATABASE IF EXISTS hanye_take_out;
CREATE DATABASE hanye_take_out DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hanye_take_out;

-- 1、员工（密码为 MD5(123456) = e10adc3949ba59abbe56e057f20f883e）
CREATE TABLE employee(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) NOT NULL DEFAULT '员工',
    account varchar(64) UNIQUE NOT NULL,
    password varchar(255) NOT NULL,
    phone varchar(16) NULL,
    age int NULL,
    gender tinyint NULL,
    pic longtext NULL,
    status tinyint NOT NULL DEFAULT 0,
    create_user int NOT NULL,
    update_user int NOT NULL,
    create_time datetime NOT NULL DEFAULT now(),
    update_time datetime NOT NULL DEFAULT now()
);
INSERT INTO employee (id,name,account,password,phone,age,gender,status,create_user,update_user) VALUES
(1,'陈大厨','cyh','e10adc3949ba59abbe56e057f20f883e','13800000001',32,1,1,1,1),
(2,'王强','wangqiang','e10adc3949ba59abbe56e057f20f883e','13800000002',28,1,1,1,1);

-- 2、分类
CREATE TABLE category(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) UNIQUE NOT NULL,
    type tinyint NOT NULL,
    sort int NOT NULL,
    status tinyint NOT NULL DEFAULT 1,
    create_user int NOT NULL,
    update_user int NOT NULL,
    create_time datetime NOT NULL DEFAULT now(),
    update_time datetime NOT NULL DEFAULT now()
);
INSERT INTO category (id,name,type,sort,status,create_user,update_user) VALUES
(1,'招牌热菜',1,1,1,1,1),
(2,'爽口凉菜',1,2,1,1,1),
(3,'主食',1,3,1,1,1),
(4,'饮品',1,4,1,1,1),
(5,'超值套餐',2,1,1,1,1);

-- 3、菜品
CREATE TABLE dish(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) UNIQUE NOT NULL,
    pic longtext NULL,
    detail varchar(255) NOT NULL,
    price decimal(10,2) NOT NULL,
    status tinyint NOT NULL DEFAULT 1,
    category_id int NOT NULL,
    create_user int NOT NULL,
    update_user int NOT NULL,
    create_time datetime NOT NULL DEFAULT now(),
    update_time datetime NOT NULL DEFAULT now(),
    CONSTRAINT fk_dish_category FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO dish (id,name,detail,price,status,category_id,create_user,update_user) VALUES
(1,'宫保鸡丁','经典川菜，鸡肉滑嫩花生香脆',38.00,1,1,1,1),
(2,'鱼香肉丝','咸甜酸辣兼备，下饭神器',32.00,1,1,1,1),
(3,'红烧狮子头','肉质酥烂，汤汁浓郁',42.00,1,1,1,1),
(4,'麻婆豆腐','麻辣鲜香，豆腐嫩滑',22.00,1,1,1,1),
(5,'凉拌黄瓜','清脆爽口，开胃小菜',12.00,1,2,1,1),
(6,'口水鸡','麻辣鲜香，回味无穷',28.00,1,2,1,1),
(7,'扬州炒饭','粒粒分明，配料丰富',18.00,1,3,1,1),
(8,'手工水饺','现包现煮，皮薄馅大',20.00,1,3,1,1),
(9,'鲜榨橙汁','现榨现卖，维C满满',15.00,1,4,1,1),
(10,'酸梅汤','生津止渴，解辣首选',8.00,1,4,1,1);

-- 4、口味
CREATE TABLE dish_flavor(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    list varchar(255) NOT NULL,
    dish_id int NOT NULL
);
INSERT INTO dish_flavor (name,list,dish_id) VALUES
('辣度','["不辣","微辣","中辣","重辣"]',1),
('辣度','["不辣","微辣","中辣","重辣"]',2),
('辣度','["不辣","微辣","重辣"]',4),
('温度','["热","温","冷"]',9),
('温度','["常温","冰镇"]',10);

-- 5、套餐
CREATE TABLE setmeal(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) UNIQUE NOT NULL,
    pic longtext NULL,
    detail varchar(255) NOT NULL,
    price decimal(10,2) NOT NULL,
    status tinyint NOT NULL DEFAULT 1,
    category_id int NOT NULL,
    create_user int NOT NULL,
    update_user int NOT NULL,
    create_time datetime NOT NULL DEFAULT now(),
    update_time datetime NOT NULL DEFAULT now(),
    CONSTRAINT fk_setmeal_category FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO setmeal (id,name,detail,price,status,category_id,create_user,update_user) VALUES
(1,'双人套餐A','宫保鸡丁+凉拌黄瓜+扬州炒饭+酸梅汤',78.00,1,5,1,1),
(2,'单人套餐B','鱼香肉丝+扬州炒饭+酸梅汤',52.00,1,5,1,1);

-- 6、套餐-菜品中间表
CREATE TABLE setmeal_dish(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    price decimal(10,2) NOT NULL,
    copies int NOT NULL,
    dish_id int NOT NULL,
    setmeal_id int NOT NULL,
    CONSTRAINT fk_between_dish FOREIGN KEY (dish_id) REFERENCES dish(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_between_setmeal FOREIGN KEY (setmeal_id) REFERENCES setmeal(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO setmeal_dish (name,price,copies,dish_id,setmeal_id) VALUES
('宫保鸡丁',38.00,1,1,1),
('凉拌黄瓜',12.00,1,5,1),
('扬州炒饭',18.00,1,7,1),
('酸梅汤',8.00,2,10,1),
('鱼香肉丝',32.00,1,2,2),
('扬州炒饭',18.00,1,7,2),
('酸梅汤',8.00,1,10,2);

-- 7、小程序用户
CREATE TABLE user(
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(64) NULL,
    openid varchar(45) NOT NULL,
    phone varchar(11) NULL,
    gender tinyint NULL,
    id_number varchar(18) NULL,
    pic longtext NULL,
    create_time datetime NOT NULL
);
INSERT INTO user (id,name,openid,phone,gender,create_time) VALUES
(1,'李明','openid_test_001','13900000001',1,'2026-10-20 11:30:00'),
(2,'赵芳','openid_test_002','13900000002',2,'2026-10-22 18:20:00');

-- 8、订单明细
CREATE TABLE order_detail(
    id bigint PRIMARY KEY AUTO_INCREMENT,
    name varchar(32) DEFAULT NULL,
    pic longtext DEFAULT NULL,
    order_id bigint NOT NULL,
    dish_id bigint DEFAULT NULL,
    setmeal_id bigint DEFAULT NULL,
    dish_flavor varchar(50) DEFAULT NULL,
    number int NOT NULL DEFAULT 1,
    amount decimal(10,2) NOT NULL
);

-- 9、订单
CREATE TABLE orders(
    id bigint PRIMARY KEY AUTO_INCREMENT,
    number varchar(50) DEFAULT NULL,
    status int NOT NULL DEFAULT 1,
    user_id bigint NOT NULL,
    address_book_id bigint NOT NULL,
    order_time datetime NOT NULL,
    checkout_time datetime DEFAULT NULL,
    pay_method int NOT NULL DEFAULT 1,
    pay_status tinyint NOT NULL DEFAULT 0,
    amount decimal(10,2) NOT NULL,
    remark varchar(100) DEFAULT NULL,
    phone varchar(11) DEFAULT NULL,
    address varchar(255) DEFAULT NULL,
    user_name varchar(32) DEFAULT NULL,
    consignee varchar(32) DEFAULT NULL,
    cancel_reason varchar(255) DEFAULT NULL,
    rejection_reason varchar(255) DEFAULT NULL,
    cancel_time datetime DEFAULT NULL,
    estimated_delivery_time datetime DEFAULT NULL,
    delivery_status tinyint(1) NOT NULL DEFAULT 1,
    delivery_time datetime DEFAULT NULL,
    pack_amount int DEFAULT NULL,
    tableware_number int DEFAULT NULL,
    tableware_status tinyint(1) NOT NULL DEFAULT 1
);
INSERT INTO orders (id,number,status,user_id,address_book_id,order_time,checkout_time,pay_method,pay_status,amount,phone,address,user_name,consignee,estimated_delivery_time,pack_amount,tableware_number) VALUES
(1,'HY202610280001',5,1,1,'2026-10-28 11:20:00','2026-10-28 11:21:30',1,1,96.00,'13900000001','幸福小区3栋502','李明','李明','2026-10-28 12:00:00',2,1),
(2,'HY202610280002',3,2,2,'2026-10-28 12:05:00','2026-10-28 12:06:00',1,1,60.00,'13900000002','科技园A座1808','赵芳','赵芳','2026-10-28 12:45:00',2,2),
(3,'HY202610280003',2,1,1,'2026-10-28 15:30:00','2026-10-28 15:31:00',1,1,52.00,'13900000001','幸福小区3栋502','李明','李明','2026-10-28 16:10:00',2,1);
INSERT INTO order_detail (name,order_id,dish_id,number,amount) VALUES
('宫保鸡丁',1,1,1,38.00),('凉拌黄瓜',1,5,1,12.00),('扬州炒饭',1,7,2,36.00),('酸梅汤',1,10,2,10.00),
('鱼香肉丝',2,2,1,32.00),('手工水饺',2,8,1,20.00),
('鱼香肉丝',3,2,1,32.00),('鲜榨橙汁',3,9,1,15.00);

-- 10、购物车
CREATE TABLE cart(
    id bigint PRIMARY KEY AUTO_INCREMENT,
    name varchar(32) NULL,
    pic longtext NULL,
    user_id bigint NOT NULL,
    dish_id bigint NULL,
    setmeal_id bigint NULL,
    dish_flavor varchar(50) NULL,
    number int NOT NULL DEFAULT 1,
    amount decimal(10,2) NOT NULL,
    create_time datetime NULL
);
INSERT INTO cart (name,user_id,dish_id,number,amount,create_time) VALUES
('宫保鸡丁',1,1,1,38.00,'2026-10-28 15:50:00'),
('酸梅汤',1,10,2,16.00,'2026-10-28 15:51:00'),
('单人套餐B',2,NULL,1,52.00,'2026-10-28 15:52:00');
UPDATE cart SET setmeal_id=2 WHERE name='单人套餐B';

-- 11、地址簿
CREATE TABLE address_book(
    id bigint PRIMARY KEY AUTO_INCREMENT,
    user_id bigint NOT NULL,
    consignee varchar(50) NULL,
    gender tinyint(1) NULL,
    phone varchar(11) NOT NULL,
    province_code varchar(12) NULL,
    province_name varchar(32) NULL,
    city_code varchar(12) NULL,
    city_name varchar(32) NULL,
    district_code varchar(12) NULL,
    district_name varchar(32) NULL,
    detail varchar(200) NULL,
    label varchar(100) NULL,
    is_default tinyint(1) NOT NULL DEFAULT 0
);
INSERT INTO address_book (id,user_id,consignee,gender,phone,province_name,city_name,district_name,detail,label,is_default) VALUES
(1,1,'李明',1,'13900000001','广东省','深圳市','南山区','幸福小区3栋502','家',1),
(2,2,'赵芳',2,'13900000002','广东省','深圳市','南山区','科技园A座1808','公司',1);
