# 依赖与代码生成规划

本文档用于约束本项目在不同阶段如何引入依赖，以及如何使用代码生成。

目标不是“尽量少装包”，而是避免：
- 在架构尚未稳定时引入过多系统复杂度
- 为了减少样板代码而牺牲协议适配能力
- 后期功能变多后依赖失控

## 一、总体原则

本项目当前优先解决的问题不是普通 JSON 接口开发，而是：
- Cookie Session 鉴权
- 表单请求
- 自定义编码
- HTML 页面载荷
- 多步骤流程编排

因此依赖和代码生成策略必须遵守：

1. 优先服务真实协议接入
2. 优先保证可调试性
3. 优先保证可测试性
4. 不为少写样板代码而提前引入整套生成体系

## 二、当前阶段必须引入的依赖

当前阶段指：
- 接真实登录接口
- 接真实题库流程接口
- 落地 Cookie Session
- 落地请求编码和 HTML 解析

### 运行时依赖

建议引入：

- `dio`
  统一 HTTP 客户端

- `cookie_jar`
  维护服务端 Session Cookie

- `dio_cookie_manager`
  将 Cookie 能力挂到 `Dio`

- `html`
  解析 HTML 页面与 HTML 片段

- `flutter_secure_storage`
  存敏感信息，例如登录凭据或安全相关本地状态

- `shared_preferences`
  存非敏感的轻量本地状态

- `path_provider`
  为本地持久化、测试 fixture 等提供目录能力

### 开发依赖

建议引入：

- `mocktail`
  用于测试中的 mock / fake

## 三、当前阶段暂缓引入的依赖

这些依赖不是永远不用，而是现在不急：

- `sentry_flutter`
  等开始真机调试、灰度、发布时再引入

- `supabase_flutter`
  只有当公告或实时订阅能力明确保留时再引入

- 本地数据库，例如 `drift`、`isar`
  当前阶段还不是离线优先，不应提前增加维护成本

## 四、当前阶段不建议启用代码生成

当前阶段不建议正式引入：
- `build_runner`
- `json_serializable`
- `freezed`

原因不是它们不好，而是当前最先要落地的模块是：
- `auth`
- `question_bank`
- `core/network`
- `core/session`
- `core/parsing`

这些位置的主要复杂度都在：
- 协议处理
- 编码处理
- 响应适配
- 多步骤编排

这些部分必须手写。

## 五、哪些地方必须手写

以下位置当前明确要求手写：

- `core/network/`
- `core/parsing/`
- `core/session/`
- `features/*/data/remote/`
- `features/*/data/repositories/`
- `app/router/`

原因：
- 调试成本高
- 协议不标准
- 自动生成对这类问题帮助有限
- 真实接口经常需要逐条校正

## 六、何时引入 `json_serializable`

只有满足以下条件时，才建议引入：

1. 已经跑通至少两个真实 feature
2. 某些 DTO 结构已经稳定
3. 手写映射开始显著重复
4. 不会降低可调试性

适用位置：
- `features/*/data/models/`

适用对象：
- 纯 DTO
- 字段映射对象
- 结构稳定的 JSON 响应模型

不适用对象：
- HTML 解析结果对象
- 复杂流程状态对象
- 远程数据源
- repository

## 七、何时引入 `freezed`

只有满足以下条件时，才建议引入：

1. 某个 feature 的状态对象已经明显复杂
2. 出现多个状态分支
3. `copyWith`、不可变建模、联合类型开始频繁出现

适用位置：
- 复杂状态对象
- 复杂 domain entity
- 明确存在联合状态需求的 application 层

不适用场景：
- 为了统一风格把所有类都改成 `freezed`
- 简单对象也强行生成

## 八、当前阶段明确不建议引入的生成方案

当前阶段不建议：

- `retrofit`
- `riverpod_generator`
- `auto_route`
- `injectable`

原因：
- 会掩盖真实协议复杂度
- 对当前核心问题帮助不大
- 增加新的系统复杂度
- 容易让项目在未稳定前进入“为工具服务”的状态

## 九、当前推荐执行顺序

建议按下面顺序推进：

1. 先补当前阶段必须依赖
2. 先手写真实 `auth`
3. 再手写真实 `question_bank`
4. 补协议层测试与流程测试
5. 等 DTO 稳定后，再评估 `json_serializable`
6. 等状态复杂后，再评估 `freezed`

## 十、结论

当前阶段的明确策略是：

- 该加的协议依赖现在就加
- 代码生成现在先不启用
- 真实 `auth` 和 `question_bank` 先坚持手写
- 等真实模块跑通后，再逐步引入 DTO 和状态对象生成

这不是保守，而是为了保证项目在真实业务复杂度下持续可控。
