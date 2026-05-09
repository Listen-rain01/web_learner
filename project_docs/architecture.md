# 架构约束

本文档定义 `web_learner` 的基础架构边界。后续新增功能、接口接入、代码生成和测试补充，都应以本文档为第一参考。

## 目标

本项目不是普通 REST 客户端，而是面向一类带有以下特征的业务系统：
- Cookie Session 鉴权
- 表单提交
- 自定义请求编码
- HTML 页面入口或 HTML 载荷
- 多步骤业务流程

因此，项目结构必须优先服务于：
- 协议适配
- 流程编排
- 分层清晰
- 后期可扩展

## 顶层结构

```text
lib/
  app/
  core/
  features/
```

### `app`

职责：
- 应用启动
- Provider 装配入口
- 路由
- 主题

禁止：
- 直接实现业务接口
- 直接写 HTML 解析逻辑
- 直接写某个 feature 的业务流程

### `core`

职责：
- 跨 feature 复用的底层能力
- 环境配置
- 日志
- 异常模型
- 网络客户端抽象
- 请求编码
- 会话管理
- HTML 解析基础能力
- 本地存储契约

禁止：
- 放置某个 feature 独有的业务逻辑
- 放置某个 feature 专用的页面状态
- 堆积题库、阅读、考试等模块的业务流程

### `features`

职责：
- 按业务域拆分模块
- 每个模块独立维护自己的业务抽象、流程状态、页面

推荐模块：
- `auth`
- `home`
- `profile`
- `checkin`
- `daily_points`
- `reading`
- `question_bank`
- `exam_core`
- `mobile_exam`
- `mock_exam`

## 依赖方向

必须遵守：

```text
presentation -> application -> domain
data -> domain
app -> core + features
features -> core
```

禁止：
- `presentation -> data/remote`
- `presentation -> Dio`
- `presentation -> HTML parser`
- `domain -> Flutter`
- `domain -> Dio`
- `core -> feature`

## 关键约束

1. 页面层不允许直接发请求。
2. 复杂业务流程必须经过 application 或 repository 编排。
3. HTML 解析只能出现在 `core/parsing` 或 feature 内的 `data/remote`。
4. `core` 只提供通用能力，不能成为“业务垃圾场”。
5. 任何真实接口接入前，应先确认它属于哪个 feature。

## 题库模块特殊说明

题库流程必须按真实业务建模，而不是按页面表象建模。

当前默认流程应理解为：

```text
单位 -> 一级分类 -> 子层节点 -> 题库列表 -> 保存当前题库
```

其中“子层节点”不能被写死为“只有年份”，必须允许：
- 年份节点
- 中间分类节点
- 混合节点

## 新增功能时的最低要求

新增一个 feature 时，至少要完成：
- 目录骨架
- 领域对象
- repository 抽象
- 流程状态定义
- 页面占位或入口页

如果要接入真实接口，还必须同时补：
- 接口接入规则说明
- 最少一层测试
