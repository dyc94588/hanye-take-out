# 寒页外卖 · 全栈点餐系统（Spring Boot 3 + Vue 3 + uni-app）

一个完整的外卖点餐业务系统，包含**后台管理端**、**微信小程序用户端**与**服务端 API** 三部分，覆盖从菜品/套餐管理、购物车、下单支付到订单流转、营业数据统计的完整链路。

> 本项目为个人学习实践项目，基于黑马程序员《苍穹外卖》课程体系与「寒页外卖」开源升级版进行本地部署、联调与二次调整，用于实践 Spring Boot 3 全栈开发与小程序端到端打通。原项目与技术出处见文末「致谢」。

---

## 技术栈

**服务端**

| 类别 | 选型 |
|---|---|
| 语言 / 运行时 | Java 17 |
| 框架 | Spring Boot 3.2.5、Spring MVC、Spring AOP |
| 持久层 | MyBatis、PageHelper 分页、MySQL 8 |
| 缓存 / 消息 | Redis（店铺营业状态、购物车、菜品缓存） |
| 实时通信 | WebSocket（来单提醒、客户催单） |
| 鉴权 | JWT Token（管理端 / 用户端双拦截器） |
| 第三方能力 | 阿里云 OSS 文件上传、微信支付 SDK、Apache POI（报表导出） |

**后台管理端**

`Vue 3` + `TypeScript` + `Vite` + `Element Plus` + `Pinia` + `Vue Router` + `ECharts` + `Axios`

**用户端（小程序）**

`uni-app` + `TypeScript` + `Vite` + `Pinia`

---

## 功能模块

### 管理端（Web）

- **员工管理**：账号登录、新增/编辑/禁用、分页查询
- **分类管理**：菜品与套餐分类的增删改查、类型区分
- **菜品管理**：菜品新增（含口味配置）、起售/停售、批量删除、按分类与名称检索、图片上传（OSS）
- **套餐管理**：套餐组合配置、起售/停售、价格与菜品明细维护
- **订单管理**：订单搜索、各状态流转（待接单 → 待派送 → 派送中 → 已完成）、接单/拒单/取消
- **数据统计**：营业额统计、用户统计、订单统计、销量 Top10，ECharts 可视化 + Excel 报表导出
- **来单提醒**：WebSocket 实时推送新订单语音提醒
- **店铺状态**：营业/打烊一键切换，Redis 存储状态

### 用户端（小程序）

- 微信授权登录、JWT 身份校验
- 首页店铺信息与营业状态展示
- 菜品分类浏览、菜品详情与口味选择
- 购物车增删改（Redis 存储，支持加减份数、清空）
- 收货地址管理（新增/编辑/删除/默认地址）
- 下单流程：提交订单 → 微信支付 → 支付成功页
- 历史订单、订单详情、再来一单、取消订单、催单

---

## 目录结构

```
hanye-take-out/
├── hanye-take-out-springboot3/          # 服务端（Maven 多模块）
│   ├── common/                          # 通用层：常量、异常、结果封装、工具类、上下文
│   ├── pojo/                            # 实体、DTO、VO
│   └── server/                          # 业务层
│       └── src/main/java/fun/cyhgraph/
│           ├── controller/admin/        # 管理端接口
│           ├── controller/user/         # 用户端接口
│           ├── service/                 # 业务实现
│           ├── mapper/                  # MyBatis 映射
│           ├── interceptor/             # JWT 拦截器
│           ├── aspect/                  # 公共字段自动填充
│           ├── config/                  # Redis / WebMvc / WebSocket 配置
│           └── websocket/               # 来单提醒、催单
├── hanye-take-out-vue3/                 # 后台管理端
├── hanye-take-out-uniapp/               # 用户端小程序
└── hanye-take-out.sql                   # 数据库脚本（建库建表 + 初始数据）
```

---

## 本地运行

### 1. 准备环境

- JDK 17、Maven 3.8+
- MySQL 8.0、Redis 7
- Node.js 18+、微信开发者工具（运行小程序端）

### 2. 初始化数据库与配置

```bash
mysql -u root -p < hanye-take-out.sql
```

复制配置模板并填入本地真实值（**仓库只保留模板，真实配置已被 .gitignore 忽略**）：

```bash
cd hanye-take-out-springboot3/server/src/main/resources
cp application-dev.example.yml application-dev.yml
# 编辑 application-dev.yml，填入 MySQL / Redis 账号密码、微信 appid 与 secret 等
```

百度地图 AK 在 `application.yml` 的 `hanye.baidu.ak` 处填写自己的值。

### 3. 启动服务端

```bash
cd hanye-take-out-springboot3
mvn clean install -DskipTests
mvn -pl server spring-boot:run
```

默认端口 `8080`。

### 4. 启动后台管理端

```bash
cd hanye-take-out-vue3
npm install
npm run dev
```

### 5. 启动用户端小程序

```bash
cd hanye-take-out-uniapp
npm install
npm run dev:mp-weixin
```

用微信开发者工具导入 `dist/dev/mp-weixin` 目录即可预览；如请求跨域或域名校验报错，开发阶段勾选「不校验合法域名」。

---

## 实现要点

1. **公共字段自动填充**：自定义 `@AutoFill` 注解 + AOP 切面，统一处理 `create_time`、`update_time`、`create_user`、`update_user`，避免重复代码。
2. **双端鉴权隔离**：管理端与用户端各自独立的 JWT 拦截器与 Token 载荷，互不影响。
3. **Redis 的三处应用**：店铺营业状态（单值缓存）、用户购物车（Hash 结构按用户维度存储）、菜品/套餐缓存（提升读性能）。
4. **WebSocket 实时提醒**：管理端建立长连接接收新订单语音提醒，用户端可发起催单消息推送到后台。
5. **报表统计**：MyBatis 聚合查询 + POI 导出 Excel，前端用 ECharts 渲染营业额、订单量、销量排名。
6. **统一响应与异常处理**：`Result<T>` 统一返回结构 + `GlobalExceptionHandler` 全局异常捕获，业务异常与系统异常分级处理。

---

## 学习收获

- 打通了「小程序端 → 服务端 API → 数据库/缓存」的完整链路，理解了前后端分离架构下的鉴权、跨域与联调流程；
- 掌握 Spring Boot 3 的拦截器、AOP、WebSocket、Redis 集成等常用工程化能力；
- 通过 SQL 脚本还原与依赖升级（Spring Boot 2 → 3、JDK 8 → 17）实践了项目迁移中的兼容性问题排查；
- 形成「先跑通主流程、再逐模块对照接口验证」的排错习惯。

---

## 安全说明

本仓库不包含任何真实凭据：

- 数据库、Redis、微信 appid/secret、支付参数均放在本地 `application-dev.yml`（已 gitignore），仓库只提交 `application-dev.example.yml` 模板；
- 百度地图 AK 在 `application.yml` 中为占位符，需自行申请；
- 若你 fork 本项目，请勿把真实密码写进任何被跟踪的文件。

---

## 致谢

- 业务原型与课程体系：[黑马程序员《苍穹外卖》](https://www.itheima.com/)
- 升级版开源实现：寒页外卖（原作者 B 站演示：https://www.bilibili.com/video/BV1SM4m1U7eR）
- 本项目仅用于个人学习与技术交流，未用于任何商业用途；如有侵权请联系删除。
