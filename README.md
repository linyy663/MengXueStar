# 萌学星球 (MengXueStar) - iOS 开发文档

> 幼小衔接打卡学习 App，基于 SwiftUI + 腾讯云CloudBase

---

## 📁 项目结构

```
MengXueStar/
├── MengXueStar/              # SwiftUI 源码
│   ├── App/                  # App入口、状态管理
│   ├── Core/                 # 核心配置、网络、存储、扩展
│   ├── Models/               # 数据模型
│   ├── Features/             # 功能模块
│   │   ├── Login/            # 登录（手机号+验证码）
│   │   ├── Home/             # 首页（今日课程、打卡）
│   │   ├── Courses/          # 课程列表
│   │   ├── Learning/         # 学习/答题流程
│   │   ├── Profile/          # 个人中心
│   │   └── ParentControl/    # 家长控制
│   ├── Components/           # 可复用UI组件
│   ├── Navigation/           # 导航
│   └── Resources/            # 资源（Info.plist, Assets）
├── cloudbase/                 # CloudBase后端
├── codemagic.yaml            # CI/CD配置
├── project.yml              # XcodeGen配置
└── README.md
```

---

## 🚀 本地开发

### 环境要求
- Flutter SDK 3.x（需要 iOS 开发）
- Xcode 15+
- CocoaPods（`sudo gem install cocoapods`）
- XcodeGen（`brew install xcodegen`）

### 步骤

```bash
# 1. 进入项目目录
cd MengXueStar

# 2. 安装依赖
flutter pub get

# 3. 生成 Xcode 项目（Flutter项目需此步）
flutter pub run xcodegen generate

# 4. 安装 iOS 依赖（如果使用Flutter）
cd ios && pod install && cd ..

# 5. 打开 Xcode
open MengXueStar.xcworkspace
```

### 注意事项
> ⚠️ 当前项目为 **SwiftUI 纯原生 iOS 项目**，使用 XcodeGen 管理。
> 如果使用 Flutter，请先执行 `flutter create` 重建项目。

### Xcode 直接打开
```bash
# 进入项目目录后
open MengXueStar.xcodeproj
# 或
open MengXueStar.xcworkspace
```

---

## 🔧 打包 IPA（供 TestFlight）

### 方式一：Codemagic 云编译（推荐）

1. 将代码推送至 GitHub/GitLab
2. 在 [codemagic.io](https://codemagic.io) 关联仓库
3. 在 Codemagic 配置环境变量：
   - `APP_STORE_CONNECT_API_KEY`（App Store Connect API Key）
   - `BUNDLE_ID`（你的 App Bundle ID）
   - `APP_ID`（App Store Connect App ID）
4. 点击 "Start new build"

### 方式二：本地 Xcode 打包

1. 打开 `MengXueStar.xcworkspace`
2. 选择 **Release** 配置
3. 选择你的签名证书（Distribution）
4. Product → Archive → Export → Save for Ad Hoc Deployment
5. 生成 `.ipa` 文件

### 📦 打包时需要的配置

请提供以下信息，我将更新配置：
- **Bundle ID**：如 `com.yourcompany.mengxue`
- **Distribution 证书**：.p12 文件 + 密码
- **Provisioning Profile**：.mobileprovision 文件
- **App Store Connect API Key**：用于 TestFlight 发布

---

## ☁️ 腾讯云CloudBase 后端配置

### 1. 开通服务
- 访问 [腾讯云CloudBase](https://cloud.tencent.com/product/tcb)
- 创建环境，获取 **环境 ID**

### 2. 配置 SMS 短信服务
- 开通腾讯云短信服务
- 创建签名和模板
- 在 CloudBase 云函数 `sendSMS/index.js` 中填入 SecretId/SecretKey

### 3. 创建云函数
在 CloudBase 控制台创建以下云函数：
- `sendSMS` - 发送验证码
- `verifySMS` - 验证验证码
- `login` - 登录/注册
- `getDailyTasks` - 获取每日任务（调用 LLM API 生成）
- `submitAnswer` - 提交答题结果
- `checkIn` - 打卡
- `getParentSettings` - 获取家长设置
- `updateParentSettings` - 更新家长设置

### 4. LLM API 集成
在 `getDailyTasks` 云函数中接入：
- 腾讯混元 / 百度文心 / OpenAI 等
- 根据孩子年级和历史进度，动态生成当日练习题

---

## 📱 App Store 上架清单

### 审核前必查项
- [ ] 隐私政策页面（儿童隐私专项）
- [ ] 家长控制功能完整可用
- [ ] 无外部链接、无社交功能
- [ ] 年龄分级设为 "4+"
- [ ] App Store 截图（5.5寸 + iPad）
- [ ] App 描述和关键词优化
- [ ] 内购测试（沙盒账号）

### 特殊要求（儿童类 App）
- 符合 COPPA 合规要求
- 家长验证机制
- 无广告/无内购引导
- 内容安全过滤

---

## 🛠️ 常用命令

```bash
# XcodeGen 生成项目
xcodegen generate

# iOS 构建
xcodebuild -workspace MengXueStar.xcworkspace \
  -scheme MengXueStar \
  -configuration Release \
  -archive

# CocoaPods 更新
pod install --repo-update
pod update
```

---

## 📞 支持

如有问题，请联系开发者。
