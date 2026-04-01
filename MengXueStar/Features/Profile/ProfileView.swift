import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // 个人信息卡片
                        profileCard

                        // 成就统计
                        achievementStats

                        // 设置菜单
                        settingsMenu

                        // 登出按钮
                        logoutButton

                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.inline)
            .alert("确认退出登录？", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) {}
                Button("退出", role: .destructive) {
                    appState.logout()
                }
            }
        }
    }

    private var profileCard: some View {
        VStack(spacing: 16) {
            // 头像和名字
            if let child = appState.currentChild {
                HStack(spacing: 16) {
                    Text(child.avatar.emoji)
                        .font(.system(size: 56))
                        .frame(width: 80, height: 80)
                        .background(Color(hex: child.avatar.color).opacity(0.2))
                        .cornerRadius(24)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(child.name)
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.textPrimary)

                        HStack(spacing: 4) {
                            Text(child.grade.rawValue)
                            Text("·")
                            Text("\(child.age)岁")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)

                        HStack(spacing: 4) {
                            Text("⭐ \(child.totalPoints) 积分")
                            Text("·")
                            Text("🔥 \(child.consecutiveDays)天连续")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.brandOrange)
                    }

                    Spacer()
                }
            }

            // 进度条
            VStack(spacing: 6) {
                HStack {
                    Text("今日学习进度")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("3/5 科")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.brandOrange)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(colors: [.brandOrange, .brandYellow], startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(width: geo.size.width * 0.6, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .cardShadow()
    }

    private var achievementStats: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏆 成长成就")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statItem(emoji: "📅", value: "23", label: "打卡天数", color: .brandOrange)
                statItem(emoji: "📝", value: "156", label: "完成题目", color: .brandBlue)
                statItem(emoji: "⭐", value: "\(appState.currentChild?.totalPoints ?? 0)", label: "总积分", color: .brandYellow)
                statItem(emoji: "🏅", value: "\(appState.currentChild?.badges.count ?? 0)", label: "获得勋章", color: .brandPurple)
                statItem(emoji: "🔥", value: "\(appState.currentChild?.consecutiveDays ?? 0)", label: "最长连续", color: .brandRed)
                statItem(emoji: "⏱️", value: "15h", label: "累计学习", color: .brandGreen)
            }
        }
    }

    private func statItem(emoji: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.system(size: 24))

            Text(value)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(color)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(16)
        .cardShadow(radius: 6, y: 3)
    }

    private var settingsMenu: some View {
        VStack(spacing: 0) {
            settingsRow(emoji: "👶", title: "孩子信息", subtitle: "修改姓名、年级等", color: .brandPink)
            Divider().padding(.leading, 56)
            settingsRow(emoji: "🔔", title: "通知设置", subtitle: "学习提醒推送", color: .brandBlue)
            Divider().padding(.leading, 56)
            settingsRow(emoji: "📖", title: "学习记录", subtitle: "查看历史学习数据", color: .brandGreen)
            Divider().padding(.leading, 56)
            settingsRow(emoji: "💬", title: "意见反馈", subtitle: "联系我们", color: .brandOrange)
            Divider().padding(.leading, 56)
            settingsRow(emoji: "📜", title: "用户协议", subtitle: "查看相关条款", color: .textLight)
        }
        .background(Color.white)
        .cornerRadius(20)
        .cardShadow()
    }

    private func settingsRow(emoji: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Text(emoji)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textLight)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.textLight)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var logoutButton: some View {
        Button(action: { showLogoutAlert = true }) {
            Text("退出登录")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.brandRed)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.brandRed.opacity(0.1))
                .cornerRadius(16)
        }
    }
}
