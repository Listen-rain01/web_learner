# web_learner

这是一个面向学习与考试平台的 Flutter 客户端骨架，目标是承接一类“非标准 Web 接口”后端，而不是普通 REST API。

当前仓库的结构是围绕本地 `docs/` 接口文档设计的，重点适配以下特征：
- 基于 Cookie Session 的登录与鉴权
- `application/x-www-form-urlencoded` 表单请求
- 自定义请求编码
- HTML 页面载荷与页面入口接口
- 题库选择这类多步骤业务流程

当前代码还不是完整产品，而是一套可运行、可扩展、后续不需要推倒重来的工业化骨架。

## 当前状态

已完成：
- `app / core / features` 三层骨架
- 基于 Riverpod 的应用装配
- 基于 GoRouter 的登录态路由与壳层导航
- `auth`、`home`、`profile`、`question_bank`、`reading`、`checkin`、`daily_points`、`exam_core`、`mobile_exam`、`mock_exam` 等首批模块占位
- 支持混合子层节点的题库流程建模，不把子层强行简化成“只有年份”
- 基础测试骨架

尚未完成：
- 真实登录接口接入
- Cookie Session 持久化
- 请求编码器与 HTML 解析链路
- 真实题库选择流程
- 阅读学习、积分、签到、个人信息、手机考试、模拟考试的正式业务实现

## 目录结构

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
    theme/
  core/
    config/
    di/
    errors/
    logging/
    network/
    session/
    storage/
  features/
    auth/
    checkin/
    daily_points/
    exam_core/
    home/
    mobile_exam/
    mock_exam/
    profile/
    question_bank/
    reading/
    shell/
```

## 分层约定

`app`
- 负责应用装配
- 负责路由、主题、启动入口
- 不负责具体业务接口

`core`
- 负责跨模块复用能力
- 适合放环境配置、日志、网络、编码、解析、存储、异常等基础设施
- 不应该吸收某个 feature 独有的业务流程

`features`
- 每个业务模块独立维护自己的领域、应用层和表现层
- feature 自己的接口适配逻辑应放在各自模块内，不应堆进 `core`

## 当前路由

当前已经接好的页面流转：
- `/login`
- 壳层路由下的：
  - `/home`
  - `/question-bank`
  - `/profile`

路由已经具备基础登录态控制能力：
- 未登录时只能进入登录页
- 登录后会自动进入主工作区

## 题库模块建模方向

根据本地接口文档，真实题库流程更接近：

```text
单位 -> 一级分类 -> 子层节点 -> 题库列表 -> 保存当前题库
```

这里最关键的一点是：子层节点不能默认假设成“只有年份”。

当前骨架已经支持三类节点：
- 分支节点
- 年份节点
- 混合节点

这样做的目的，是为了适配文档里提到的真实情况：
- 有时返回年份
- 有时返回中间分类
- 有时两者混合返回

如果一开始就把子层写死成“年份列表”，后面接真实接口时会被迫重构。

## 测试

当前测试基线覆盖：
- 领域建模的基本假设
- `auth` 仓储的最小行为
- 应用启动与登录页烟雾测试

运行方式：

```bash
flutter analyze
flutter test
```

## 推荐的下一步

1. 把当前 `mock auth repository` 替换成真实登录接口实现
2. 在 `core` 中补齐请求编码、会话持久化、协议适配抽象
3. 按接口文档完成完整题库选择流程
4. 为每份真实接口文档补 fixture 测试、解析测试、仓储流程测试

## 说明

- `docs/` 目录已经在当前仓库中忽略，不会托管到 Git。
- 你本地旧项目 `E:\web_learner` 仍然可以作为参考，但当前仓库已经是后续继续开发的干净骨架。
