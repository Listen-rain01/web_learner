# Supabase 接入与后台能力规划

本文档用于约束 `web_learner` 后续接入 Supabase 的方式，覆盖以下能力：

- 公告
- 账号同步
- 更新检查
- 管理员界面

目标不是一次性把所有能力做完，而是先定清楚边界、数据模型和实施顺序，后续按本文逐步落地，避免反复返工。

## 1. 目标与边界

本项目当前主业务仍然是对接老系统接口：

- 老系统登录
- Cookie Session
- 个人信息接口
- 题库、阅读、考试等业务接口

Supabase 在本项目中的定位不是“替代老系统认证”，而是作为：

- 内容发布平台
- 运营配置平台
- 云端账号镜像存储
- 后续管理员后台的数据来源

明确边界：

1. App 登录是否成功，只信老系统接口。
2. Supabase 不保存老系统密码、Cookie、SessionId、密码 MD5。
3. Supabase 中的账号数据是“镜像资料”，不是主认证源。
4. 公开内容和敏感写入必须分开设计。

## 2. 总体方案

采用两种接入方式，不把所有功能做成同一种 Supabase 用法。

### 2.1 公开读

适用于：

- 公告
- 更新配置

访问方式：

```text
Flutter App -> Supabase 表（只读）
```

特点：

- 结构简单
- 接入成本低
- 适合公开展示内容

### 2.2 受控写

适用于：

- 账号同步
- App 登录准入控制
- 后续管理员敏感操作

访问方式：

```text
Flutter App / 管理员端 -> Edge Function -> Supabase 表
```

特点：

- 写入逻辑集中
- 方便做字段清洗、脱敏、去重
- 避免客户端直接持有敏感写权限

## 3. 分阶段实施顺序

## 第一阶段：公告

只落地：

- Supabase 基础接入
- `announcements` 表
- App 公告读取与展示

不做：

- 账号同步
- 更新检查
- 管理员界面正式实现

### 第二阶段：账号同步

落地：

- `legacy_accounts` 表
- `sync-legacy-account` Edge Function
- `check-app-login-access` Edge Function

同步分两次进行：

1. 登录成功后，先同步基础账号数据
2. 个人信息接口成功后，再补同步完整资料

同时增加一层 App 自己的登录准入控制：

1. 用户输入身份证号
2. App 先检查该账号是否被禁用
3. 如果明确禁用，则不再请求老系统登录接口
4. 如果未命中禁用记录，则继续请求老系统登录接口
5. 登录成功后，再同步账号镜像数据

### 第三阶段：更新检查

落地：

- `app_release_policies` 表
- App 启动时版本检查

### 第四阶段：管理员界面

落地：

- 管理员认证
- 公告管理
- 更新配置管理
- 账号同步结果查看

## 4. 数据表规划

当前正式规划三张业务表：

1. `announcements`
2. `legacy_accounts`
3. `app_release_policies`

说明：

- 第一阶段只需要真正创建 `announcements`
- `legacy_accounts` 和 `app_release_policies` 先按本文保留设计
- 后续用到时再建

## 5. announcements 表设计

用途：

- App 公告列表
- App 公告详情
- 后续管理员后台发布和维护公告

### 字段清单

| 字段名 | 类型建议 | 说明 |
| --- | --- | --- |
| `id` | `uuid` | 公告主键，唯一标识一条公告 |
| `title` | `text` | 公告标题 |
| `content` | `text` | 公告正文 |
| `is_published` | `boolean` | 是否发布，只有已发布公告才展示给 App |
| `is_pinned` | `boolean` | 是否置顶，置顶公告优先展示 |
| `starts_at` | `timestamptz` | 生效开始时间，可空；为空表示立即生效 |
| `ends_at` | `timestamptz` | 生效结束时间，可空；为空表示长期有效 |
| `created_at` | `timestamptz` | 创建时间 |
| `updated_at` | `timestamptz` | 最后更新时间 |

### 当前明确不纳入的字段

以下字段当前阶段不建，后续确有需要再补：

- `summary`
- `audience`
- `sort_order`
- `published_at`
- `created_by`
- `updated_by`

原因：

- 当前第一版公告能力不需要
- 会增加后台设计复杂度
- 后续加字段的成本低于现在过度设计的成本

## 6. legacy_accounts 表设计

用途：

- 同步老系统登录成功后的账号基础信息
- 同步个人信息接口返回的补充资料
- 作为管理员后台查看的账号镜像表

注意：

- 这不是登录态表
- 这不是权限表
- 这不是认证真相源

### 字段清单

| 字段名 | 类型建议 | 说明 |
| --- | --- | --- |
| `id` | `uuid` | 表主键 |
| `legacy_pid` | `text` | 老系统用户唯一标识，建议唯一约束 |
| `id_card_hash` | `text` | 身份证号标准化后计算得到的哈希值，用于登录前准入检查，不存明文身份证号 |
| `auth_user_name` | `text` | 登录成功时拿到的用户名 |
| `masked_id_card` | `text` | 脱敏身份证号，可空，例如 `610524********1251` |
| `person_number` | `text` | 工号，可空 |
| `department_id` | `text` | 部门 ID，可空 |
| `unit_name` | `text` | 工作单位名称，可空 |
| `app_login_enabled` | `boolean` | 是否允许登录本 App，默认 `true` |
| `app_login_disabled_reason` | `text` | 被禁用时的原因说明，可空 |
| `created_at` | `timestamptz` | 创建时间 |
| `updated_at` | `timestamptz` | 最后更新时间 |

### 当前明确不纳入的字段

以下字段当前阶段不建：

- `phone_masked`
- `address_masked`
- `avatar_path`
- `qr_photo_path`
- `allow_change_curriculum_vitae`
- `source`

原因：

- 当前不是账号同步的核心目标
- 会加重同步逻辑
- 也不是管理员后台第一版必需信息

### 同步规则

### 登录前准入检查规则

推荐策略：

1. 先检查该账号是否命中禁用规则
2. 如果明确命中禁用，则直接禁止登录本 App
3. 如果未命中任何记录，则默认允许继续请求老系统登录接口
4. 第一次登录成功后，再把账号同步进 `legacy_accounts`
5. 后续管理员可基于同步后的账号执行禁用

这意味着：

- 第一次登录的账号，不会因为 Supabase 中没有记录而被拦截
- 只有明确被管理员禁用的账号，才会在登录前被拦住

登录前检查所依赖的识别键为：

- `id_card_hash`

即：

1. 对输入的身份证号做标准化
2. 计算哈希
3. 根据哈希检查 `app_login_enabled`

说明：

- 第一阶段不单独拆准入控制表
- 当前准入控制字段直接放在 `legacy_accounts`
- 若后续出现“需要提前封禁从未登录过 App 的账号”这一强需求，再单独升级为独立准入规则表

#### 第一次同步：登录成功后

数据来源：

- 标准化后的身份证号哈希
- `pid`
- `userName`

写入字段：

- `id_card_hash`
- `legacy_pid`
- `auth_user_name`
- `app_login_enabled = true`

#### 第二次同步：个人信息接口成功后

数据来源：

- 个人信息页基础资料

补写字段：

- `masked_id_card`
- `person_number`
- `department_id`
- `unit_name`

### 严禁同步的字段

以下内容禁止写入 Supabase：

- 明文密码
- Cookie
- `ASP.NET_SessionId`
- `xxidpwd`
- 登录响应中的密码 MD5
- 完整身份证号

说明：

- 登录前准入检查可以使用身份证号哈希
- 但禁止保存完整身份证号明文

## 7. app_release_policies 表设计

用途：

- App 启动时检查更新
- 管理员后台维护版本策略

说明：

- 当前阶段暂不创建
- 后续做更新能力时按本节执行

### 字段清单

| 字段名 | 类型建议 | 说明 |
| --- | --- | --- |
| `id` | `uuid` | 主键 |
| `latest_version` | `text` | 最新版本号 |
| `force_update` | `boolean` | 是否强制更新 |
| `download_url` | `text` | 下载地址 |
| `changelog` | `text` | 更新说明 |
| `created_at` | `timestamptz` | 创建时间 |
| `updated_at` | `timestamptz` | 最后更新时间 |

### 当前明确不纳入的字段

- `channel`
- `store_url`
- `starts_at`
- `platform`
- `created_by`
- `updated_by`

原因同上：第一版不需要。

## 8. 管理员端规划

管理员端后续职责：

- 管理公告
- 管理更新配置
- 查看账号同步结果

第一版管理员端不需要一次做全，只要保证本文的数据结构能承接后续页面即可。

后续管理员端建议拆为：

1. 公告管理页
2. 更新配置页
3. 账号同步查看页

当前阶段暂不强制创建管理员相关表，但后续管理员认证建议单独设计，不和老系统登录混用。

## 9. 权限与访问约束

### announcements

App 可直接读。

约束：

- 只读取 `is_published = true` 的数据
- 当前时间必须处于生效区间内

### legacy_accounts

App 不直接写表。

必须通过 `Edge Function` 写入。

原因：

- 方便做字段脱敏
- 方便统一 `upsert`
- 避免客户端直接获得写表权限

登录前准入检查也建议通过 `Edge Function` 完成，而不是让客户端直接查表。

推荐函数：

- `check-app-login-access`
- `sync-legacy-account`

### app_release_policies

App 可直接读。

只读取当前已发布的版本策略。

## 10. 目录与代码落地建议

### 当前阶段

只先落地公告 feature。

建议目录：

```text
lib/
  core/
    config/
    supabase/
  features/
    announcement/
      application/
      data/
        models/
        remote/
        repositories/
      domain/
        entities/
        repositories/
      presentation/
```

说明：

- `core/supabase/` 只放 Supabase 初始化和基础 Provider
- 不把公告业务逻辑塞进 `core`
- 账号同步以后单独做 `features/account_sync/`
- 更新检查以后单独做 `features/app_update/`

## 11. 当前执行决策

当前确认按以下顺序实施：

1. 先接入 Supabase
2. 先创建 `announcements`
3. 先完成 App 公告读取与展示
4. `legacy_accounts` 暂不立即实现，但后续按本文字段执行
5. 账号同步落地时，同时接入登录前准入检查
6. 登录前准入检查采用推荐策略：查到禁用才拦，查无记录默认允许
7. `app_release_policies` 暂不立即实现，但后续按本文字段执行

## 12. 最终结论

本项目 Supabase 方案的最终结论如下：

1. 公告、更新属于公开读取能力，适合客户端直读。
2. 账号同步属于受控写入能力，必须通过 `Edge Function` 写入。
3. 当前只先做公告，先建 `announcements`。
4. 账号同步落地时，采用登录前准入检查 + 登录后两次补充式同步。
5. 登录前准入检查的推荐策略是：命中禁用则拦截，查无记录默认允许，保证第一次登录不受影响。
6. 账号同步和更新能力按本文预留结构，后续分阶段接入。
7. 管理员界面以后按本文表结构继续扩展，不另起一套模型。

## 13. Realtime 使用策略

本项目后续会持续使用 Supabase，但不把“使用 Supabase”和“默认开启 Realtime”等同处理。

Realtime 在本项目中的定位是：

- 局部增强能力
- 只用于确有必要的实时感知场景
- 不作为所有 Supabase 功能的默认实现方式

### 13.1 默认规则

默认约束如下：

1. 所有新接入的 Supabase 功能，先按普通读写方案设计。
2. 未经过单独评审的模块，不默认开启 Realtime。
3. 不允许为了“以后可能会用到”而提前给所有表统一开启 Realtime。
4. 客户端不默认常驻订阅所有业务表变化。

说明：

- Supabase 是本项目的数据与配置平台
- Realtime 只是其中一项可选能力
- 只有当业务明确需要“后台改动后客户端尽快感知”时，才进入 Realtime 方案评估

### 13.2 当前明确不开 Realtime 的场景

以下能力当前明确按普通读写实现，不开启 Realtime：

- 登录页公告读取
- 账号首次同步
- 登录成功后资料补充同步
- App 版本更新配置读取
- 大部分管理员后台的新增、编辑、删除操作

原因：

- 这些场景本质上是“进入页面读一次”或“保存时写一次”
- 不需要客户端长期持有实时连接
- 先用普通读写可以降低复杂度、调试成本和连接成本

### 13.3 允许局部开启 Realtime 的候选场景

以下场景可以作为后续局部开启 Realtime 的候选：

- 管理员禁用账号后，已登录客户端需要尽快感知
- 管理员发布紧急公告后，已打开登录页的客户端希望尽快刷新
- 管理员后台存在多端协作，需要列表联动刷新

这类场景的共同特征是：

- 后台改动发生后
- 客户端确实需要在较短时间内自动感知
- 轮询或重新进入页面的体验明显不足

只有符合以上特征，才值得引入 Realtime。

### 13.4 推荐接入顺序

Realtime 的推荐接入顺序如下：

1. 第一阶段：全部先按普通 Supabase 读写落地
2. 第二阶段：只挑单一场景试点，例如“账号禁用状态”或“紧急公告”
3. 第三阶段：验证稳定性、权限模型、消息范围后，再考虑扩展到其他局部场景

明确禁止：

- 一开始就让普通用户端订阅所有业务表
- 在未验证权限和消息边界前，把管理员端和用户端都做成全量实时

### 13.5 选型约束

如果后续确实需要做数据库变化实时订阅，优先遵守以下约束：

1. 优先评估更适合生产扩展的实时方案。
2. 不默认对所有表直接使用全量数据库变化订阅。
3. Realtime 的订阅范围必须尽量收敛到具体业务，而不是整个 schema。
4. 必须先明确权限边界，再决定客户端是否可以直接订阅。

### 13.6 当前项目结论

截至本文版本，当前项目对 Realtime 的正式结论是：

1. Supabase 后续功能可以继续接入。
2. 但默认只接入普通读写能力，不默认开启 Realtime。
3. 公告、账号同步、更新配置当前都不要求 Realtime。
4. Realtime 只作为后续账号禁用、紧急公告、管理员联动等场景的局部增强选项。
