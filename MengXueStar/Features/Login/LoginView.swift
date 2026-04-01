import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showChildSetup = false

    var body: some View {
        ZStack {
            // 背景
            Color.bgPrimary.ignoresSafeArea()

            // 装饰元素
            FloatingDecorations()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)

                    // Logo区域
                    logoSection

                    Spacer().frame(height: 40)

                    // 手机号输入
                    phoneInputSection

                    // 验证码输入
                    codeInputSection

                    // 登录按钮
                    loginButton

                    Spacer().frame(height: 20)

                    // 提示文字
                    hintText

                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 32)
            }
        }
        .sheet(isPresented: $showChildSetup) {
            ChildSetupView(viewModel: viewModel, appState: appState)
        }
        .alert("提示", isPresented: $viewModel.showAlert) {
            Button("好的", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    // MARK: - Logo
    private var logoSection: some View {
        VStack(spacing: 16) {
            // 吉祥物小狐狸
            ZStack {
                Circle()
                    .fill(Color.brandOrange.opacity(0.15))
                    .frame(width: 120, height: 120)

                Text("🦊")
                    .font(.system(size: 60))
                    .scaleEffect(viewModel.foxScale)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.foxScale)
            }
            .onAppear { viewModel.foxScale = 1.1 }

            // App名称
            Text("萌学星球")
                .font(.system(size: 40, weight: .black))
                .foregroundStyle(
                    Text("萌学星球")
                        .foregroundStyle(Color.brandOrange)
                        .overlay(
                            Text("萌学星球")
                                .foregroundStyle(Color.white)
                                .blendMode(.sourceAtop)
                        )
                )
                .overlay(
                    Text("萌学星球")
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(.white)
                        .blendMode(.destinationOut)
                )
                .background(
                    Text("萌学星球")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(Color(hex: "CC6B10"))
                )

            Text("每天30分钟 · 轻松幼小衔接")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textSecondary)
        }
    }

    // MARK: - Phone Input
    private var phoneInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("手机号")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textSecondary)

            HStack(spacing: 12) {
                Text("🇨🇳 +86")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)

                TextField("请输入手机号", text: $viewModel.phone)
                    .font(.system(size: 18))
                    .keyboardType(.phonePad)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .buttonShadow(color: .gray.opacity(0.2), height: 4)
        }
    }

    // MARK: - Code Input
    private var codeInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("验证码")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textSecondary)

            HStack(spacing: 12) {
                TextField("请输入验证码", text: $viewModel.code)
                    .font(.system(size: 18))
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.textPrimary)

                Button(action: { viewModel.sendCode() }) {
                    Text(viewModel.codeCountdown > 0 ? "\(viewModel.codeCountdown)s" : "获取验证码")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 110, height: 40)
                        .background(viewModel.codeCountdown > 0 ? Color.gray.opacity(0.3) : Color.brandOrange)
                        .cornerRadius(12)
                }
                .disabled(viewModel.codeCountdown > 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .buttonShadow(color: .gray.opacity(0.2), height: 4)
        }
        .padding(.top, 16)
    }

    // MARK: - Login Button
    private var loginButton: some View {
        Button(action: {
            viewModel.login { success in
                if success {
                    showChildSetup = true
                }
            }
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("登录 / 注册")
                        .font(.system(size: 18, weight: .black))
                        .textStroke(width: 1.5, color: .white)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(colors: [Color(hex: "FF9A42"), Color(hex: "FF8C42")], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(28)
            .overlay(
                LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .top, endPoint: .center)
                    .frame(height: 30)
                    .cornerRadius(28)
                    .offset(y: -28)
            )
            .buttonShadow(color: Color(hex: "D97030"), height: 6)
            .scaleEffect(viewModel.isLoading ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: viewModel.isLoading)
        }
        .disabled(viewModel.isLoading || !viewModel.canLogin)
        .opacity(viewModel.canLogin ? 1 : 0.6)
        .padding(.top, 32)
    }

    // MARK: - Hint
    private var hintText: some View {
        Text("登录即表示同意《用户协议》和《儿童隐私政策》")
            .font(.system(size: 11))
            .foregroundColor(.textLight)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Floating Decorations
struct FloatingDecorations: View {
    var body: some View {
        ZStack {
            // 背景装饰圆
            ForEach(0..<6) { i in
                Circle()
                    .fill(Color.brandOrange.opacity(0.06))
                    .frame(width: CGFloat(80 + i * 40), height: CGFloat(80 + i * 40))
                    .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -300...300))
            }

            // 云朵
            ForEach(0..<3) { i in
                CloudShape()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: CGFloat(60 + i * 20), height: CGFloat(30 + i * 10))
                    .offset(x: CGFloat([-120, 100, -80][i]), y: CGFloat([-250, -200, 300][i]))
            }

            // 星星
            ForEach(0..<5) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: CGFloat([12, 8, 16, 10, 14][i])))
                    .foregroundColor(Color.brandYellow)
                    .offset(x: CGFloat([-100, 130, -80, 110, -130][i]), y: CGFloat([200, -220, 250, -180, 280][i]))
                    .opacity(0.5)
                    .animation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: i)
            }
        }
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: 0, y: rect.height * 0.4, width: rect.width * 0.4, height: rect.height * 0.6))
        path.addEllipse(in: CGRect(x: rect.width * 0.2, y: 0, width: rect.width * 0.5, height: rect.height * 0.7))
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.height * 0.3, width: rect.width * 0.4, height: rect.height * 0.6))
        return path
    }
}

// MARK: - Child Setup Sheet
struct ChildSetupView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var childName = ""
    @State private var childAge = 5
    @State private var selectedGrade: Grade = .large
    @State private var selectedAvatar: ChildAvatar = .fox

    var body: some View {
        NavigationView {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // 欢迎语
                        Text("👋 欢迎加入萌学星球！")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(.brandOrange)
                            .padding(.top, 20)

                        // 孩子信息卡片
                        VStack(spacing: 20) {
                            // 名字
                            inputField(title: "孩子姓名", text: $childName, placeholder: "请输入孩子姓名")

                            // 年龄
                            VStack(alignment: .leading, spacing: 8) {
                                Text("孩子年龄")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: 12) {
                                    ForEach(4...7, id: \.self) { age in
                                        Button(action: { childAge = age }) {
                                            Text("\(age)岁")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(childAge == age ? .white : .textPrimary)
                                                .frame(width: 60, height: 44)
                                                .background(childAge == age ? Color.brandOrange : Color.white)
                                                .cornerRadius(12)
                                                .buttonShadow(height: 3)
                                        }
                                    }
                                }
                            }

                            // 年级
                            VStack(alignment: .leading, spacing: 8) {
                                Text("当前年级")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textSecondary)

                                VStack(spacing: 8) {
                                    ForEach(Grade.allCases, id: \.self) { grade in
                                        Button(action: { selectedGrade = grade }) {
                                            HStack {
                                                Text(grade.rawValue)
                                                    .font(.system(size: 15, weight: .semibold))
                                                Spacer()
                                                if selectedGrade == grade {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.brandOrange)
                                                }
                                            }
                                            .foregroundColor(.textPrimary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedGrade == grade ? Color.brandOrange : Color.gray.opacity(0.2), lineWidth: selectedGrade == grade ? 2 : 1)
                                            )
                                        }
                                    }
                                }
                            }

                            // 头像选择
                            VStack(alignment: .leading, spacing: 8) {
                                Text("选择小搭档")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textSecondary)

                                HStack(spacing: 16) {
                                    ForEach(ChildAvatar.allCases, id: \.self) { avatar in
                                        Button(action: { selectedAvatar = avatar }) {
                                            Text(avatar.emoji)
                                                .font(.system(size: 40))
                                                .frame(width: 64, height: 64)
                                                .background(selectedAvatar == avatar ? Color(hex: avatar.color).opacity(0.2) : Color.white)
                                                .cornerRadius(16)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(selectedAvatar == avatar ? Color(hex: avatar.color) : Color.clear, lineWidth: 3)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(24)
                        .cardShadow()

                        // 开始按钮
                        Button(action: {
                            let child = ChildProfile(
                                name: childName,
                                avatar: selectedAvatar,
                                age: childAge,
                                grade: selectedGrade
                            )
                            if let user = viewModel.loggedInUser {
                                appState.login(user: user, child: child)
                            }
                            dismiss()
                        }) {
                            Text("开始学习 🦊")
                                .font(.system(size: 18, weight: .black))
                                .textStroke(width: 1.5, color: .white)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(LinearGradient(colors: [Color(hex: "FF9A42"), Color(hex: "FF8C42")], startPoint: .top, endPoint: .bottom))
                                .cornerRadius(28)
                                .buttonShadow()
                        }
                        .disabled(childName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity(childName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func inputField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textSecondary)

            TextField(placeholder, text: text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.bgPrimary)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}
