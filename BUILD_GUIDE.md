# 萌学星球 - Codemagic 云打包指南

> 由于 Windows 环境无法直接编译 iOS，本项目通过 **Codemagic** 云编译服务自动构建 IPA 并发布到 TestFlight。

---

## 📋 打包前准备清单

| 项目 | 状态 | 说明 |
|------|------|------|
| Bundle ID | ✅ `com.lunar.study` | 已配置 |
| 证书 | ✅ `ios_distribution20251031.p12` | 已放入 `ios/Signing/` |
| 描述文件 | ✅ `study0401.mobileprovision` | 已放入 `ios/Signing/` |
| 证书密码 | ✅ `zhuyue123` | 见下方环境变量 |
| GitHub 仓库 | ⏳ 待创建 | 你需要创建 |
| App Store Connect API Key | ⏳ 待创建 | 用于 TestFlight 发布 |
| Codemagic 账号 | ⏳ 待注册 | 免费使用 |

---

## 🚀 第一步：推送代码到 GitHub

### 1.1 在 GitHub 创建仓库

1. 打开 [github.com](https://github.com) 登录
2. 点击右上角 **+** → **New repository**
3. 填写：
   - Repository name: `MengXueStar`
   - Private: ✅
   - 不需要勾选 README（本地已有代码）

### 1.2 本地初始化并推送

打开 **PowerShell**，依次执行：

```powershell
cd "c:\Users\linyy\WorkBuddy\20260401133759\MengXueStar"

# 初始化 Git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: 萌学星球 iOS App"

# 添加远程仓库（替换 YOUR_USERNAME 为你的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/MengXueStar.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

> ⚠️ 如果提示 `git: command not found`，先安装 Git：https://git-scm.com/download/win

---

## 🔑 第二步：创建 App Store Connect API Key

这是发布到 TestFlight 的必需凭证。

### 2.1 登录 App Store Connect

1. 打开 https://appstoreconnect.apple.com
2. 登录你的 Apple 开发者账号

### 2.2 创建 API Key

1. 点击 **用户和访问** (Users and Access)
2. 点击 **密钥** (Keys) 标签
3. 点击 **+** 创建新密钥
4. 填写：
   - 名称：`MengXueStar CI/CD`
   - 访问级别：**App Store Connect 用户**
4. 点击 **生成**
5. **下载 .p8 文件**（只可下载一次，妥善保存！）
6. 记录 **Issuer ID** 和 **Key ID**

```
Issuer ID:  xxx-xxx-xxx-xxx        ← 在密钥页面顶部显示
Key ID:     XXXXXXXXXX             ← 密钥名称下方
```

### 2.3 获取 App ID

1. 在 App Store Connect 点击 **我的 App** → **新建 App**
2. 填写：
   - 平台：**iOS**
   - 名称：**萌学星球**
   - 语言：**简体中文**
   - Bundle ID：选择 `com.lunar.study`
   - SKU：可以填 `mengxue_star_001`
3. 点击 **创建**

创建后，在 App 信息页面找到 **Apple ID**（是一串数字，如 `123456789`），记录下来。

---

## ⚙️ 第三步：配置 Codemagic

### 3.1 注册 Codemagic

1. 打开 https://codemagic.io
2. 点击 **Sign up** → 用 GitHub 账号登录（最方便）
3. 授权 Codemagic 访问你的 GitHub 仓库

### 3.2 添加 App

1. 在 Codemagic 面板点击 **Add application**
2. 选择：
   - **GitHub** 作为代码来源
   - 仓库选择 `YOUR_USERNAME/MengXueStar`
   - 项目类型：**Other**
3. 点击 **Next**

### 3.3 配置环境变量

在 Codemagic 左侧菜单点击 **Environment variables**，添加以下变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `BUNDLE_ID` | `com.lunar.study` | Bundle ID |
| `APP_ID` | `123456789` | 你的 App Store Connect Apple ID |
| `CERTIFICATE_CONTENT` | (Base64字符串) | 见下方获取方式 |
| `CERTIFICATE_PASSWORD` | `zhuyue123` | 证书密码 |
| `PROVISIONING_PROFILE_CONTENT` | (Base64字符串) | 见下方获取方式 |
| `APP_STORE_CONNECT_KEY` | (Base64字符串) | App Store Connect API Key .p8 |
| `APP_STORE_ISSUER_ID` | `xxx-xxx-xxx` | 你的 Issuer ID |
| `APP_STORE_KEY_ID` | `XXXXXXXXXX` | 你的 Key ID |

#### 获取 CERTIFICATE_CONTENT（Base64）：

在 PowerShell 执行：
```powershell
$bytes = [System.IO.File]::ReadAllBytes("D:\Desktop\study\ios_distribution20251031.p12")
$b64 = [Convert]::ToBase64String($bytes)
$b64 | Set-Clipboard
```
然后在 Codemagic 粘贴。

#### 获取 PROVISIONING_PROFILE_CONTENT（Base64）：

在 PowerShell 执行：
```powershell
$bytes = [System.IO.File]::ReadAllBytes("D:\Desktop\study\study0401.mobileprovision")
$b64 = [Convert]::ToBase64String($bytes)
$b64 | Set-Clipboard
```
然后在 Codemagic 粘贴。

#### 获取 APP_STORE_CONNECT_KEY（Base64）：

下载的 `.p8` 文件，同样转 Base64：
```powershell
$bytes = [System.IO.File]::ReadAllBytes("path\to\AuthKey_XXXXXXXXXX.p8")
$b64 = [Convert]::ToBase64String($bytes)
$b64 | Set-Clipboard
```

### 3.4 上传签名证书（替代方案）

如果上面的环境变量方式不工作，可以：

1. 在 Codemagic 左侧点击 **Teams** → **Certificates**
2. 点击 **Upload certificate**
3. 上传 `D:\Desktop\study\ios_distribution20251031.p12`
4. 输入密码：`zhuyue123`

同时上传描述文件：
1. 点击 **Profiles**
2. 上传 `D:\Desktop\study\study0401.mobileprovision`

### 3.5 启动构建

1. 确认 `codemagic.yaml` 配置文件已识别
2. 点击右侧 **Start new build** 绿色按钮
3. 选择 `ios-testflight` 工作流
4. 构建会自动开始（约 15-20 分钟）

---

## 📱 第四步：在 TestFlight 添加测试员

构建成功后（状态变为 ✅）：

1. 在 Codemagic 构建详情页面，点击 **Publish** 标签
2. 点击 **Distribute to TestFlight**
3. 在 App Store Connect 添加测试员：
   - 进入 **App Store Connect** → **我的 App** → **萌学星球**
   - 点击 **TestFlight** 标签
   - 点击 **测试员** → **内部测试**
   - 添加你的 Apple ID 邮箱或内部测试人员

4. 测试员会收到 TestFlight 邀请邮件
5. 在 iPhone 上打开 TestFlight → 接受邀请 → 安装 App

---

## 🐛 常见问题

### Q1: 构建失败 "No profiles for 'com.lunar.study' were found"

**原因**：描述文件不匹配 Bundle ID
**解决**：检查 `study0401.mobileprovision` 是否是为 `com.lunar.study` 创建的。如果描述文件是为其他 Bundle ID 创建的，需要重新创建一个新的描述文件。

### Q2: 构建失败 "Certificate chain trust failed"

**原因**：证书不受信任或已过期
**解决**：检查证书有效期，重新生成或从 Apple Developer 下载新的证书。

### Q3: "Export failed: No matching provisioning profiles found"

**原因**：描述文件未正确关联证书
**解决**：在 Apple Developer 下载最新的描述文件，确保它关联了正确的证书。

### Q4: Codemagic 找不到 Xcode 项目

**原因**：`project.yml` 需要先生成 `.xcodeproj`
**解决**：在 `codemagic.yaml` 的 `scripts` 部分添加 `xcodegen generate` 命令（已配置）

---

## 📞 获取帮助

如果遇到问题，请提供：
1. Codemagic 构建日志（错误信息截图）
2. 证书和描述文件的截图（隐藏敏感信息）
3. App Store Connect 的 App ID
