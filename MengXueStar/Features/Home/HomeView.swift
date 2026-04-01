import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showLearning = false
    @State private var selectedCourse: Course?

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // 顶部问候区
                    topHeader

                    // 打卡火焰横幅
                    checkInBanner

                    // 今日课程
                    todayCourses

                    // 本周进度
                    weeklyProgress

                    // 勋章墙
                    badgeWall

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 20)
            }

            // 加载状态
            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("加载今日任务中...")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(32)
                .background(Color.textPrimary.opacity(0.8))
                .cornerRadius(20)
            }
        }
        .fullScreenCover(isPresented: $showLearning) {
            if let course = selectedCourse {
                LearningView(course: course, dailyTask: viewModel.dailyTask, viewModel: viewModel)
            }
        }
        .onAppear {
            if let child = appState.currentChild {
                viewModel.loadData(childId: child.id, grade: child.grade)
            }
        }
    }

    // MARK: - Top Header
    private var topHeader: some View {
        HStack(spacing: 12) {
            // 吉祥物
            if let avatar = appState.currentChild?.avatar {
                Text(avatar.emoji)
                    .font(.system(size: 44))
                    .frame(width: 64, height: 64)
                    .background(Color(hex: avatar.color).opacity(0.2))
                    .cornerRadius(20)
            } else {
                Text("🦊")
                    .font(.system(size: 44))
                    .frame(width: 64, height: 64)
                    .background(Color.brandOrange.opacity(0.2))
                    .cornerRadius(20)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)

                Text(appState.currentChild?.name ?? "小朋友")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.textPrimary)
                    .textStroke(width: 0.5, color: Color(hex: "FF8C42"))
            }

            Spacer()

            // 积分显示
            VStack(alignment: .trailing, spacing: 2) {
                Text("⭐")
                    .font(.system(size: 16))
                Text("\(appState.currentChild?.totalPoints ?? 0)")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.brandOrange)
            }
            .frame(width: 56, height: 52)
            .background(Color.white)
            .cornerRadius(16)
            .cardShadow()
        }
        .padding(.top, 8)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "早上好 🌤️" }
        else if hour < 18 { return "下午好 ☀️" }
        else { return "晚上好 🌙" }
    }

    // MARK: - CheckIn Banner
    private var checkInBanner: some View {
        VStack(spacing: 0) {
            // 火焰打卡条
            HStack(spacing: 16) {
                // 火焰图标
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 56, height: 56)

                    VStack(spacing: -4) {
                        Text("🔥")
                            .font(.system(size: 28))
                        Text("🔥")
                            .font(.system(size: 18))
                            .offset(y: -18)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("今日打卡进度")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))

                    Text("\(viewModel.completedCourses)/\(viewModel.totalCourses) 科已完成")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                }

                Spacer()

                // 连续打卡天数
                VStack(spacing: 2) {
                    Text("\(appState.currentChild?.consecutiveDays ?? 0)")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                    Text("连续打卡")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(width: 70, height: 60)
                .background(Color.white.opacity(0.2))
                .cornerRadius(16)
            }
            .padding(20)
            .background(
                LinearGradient(colors: [Color(hex: "FF6B35"), Color(hex: "FF8C42")], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(24)
            .buttonShadow(color: Color(hex: "CC5520"), height: 6)

            // 进度条
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(colors: [.white, .white.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * viewModel.todayProgress, height: 12)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.todayProgress)
                }
            }
            .frame(height: 12)
            .padding(.horizontal, 20)
            .offset(y: -6)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }

    // MARK: - Today Courses
    private var todayCourses: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📚 今日课程")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.textPrimary)
                    .textStroke(width: 0.5, color: .brandOrange)

                Spacer()

                Text("约30分钟")
                    .font(.system(size: 13))
                    .foregroundColor(.textLight)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.brandOrange.opacity(0.1))
                    .cornerRadius(10)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(viewModel.dailyTask?.courses ?? []) { course in
                    CourseCard(course: course) {
                        selectedCourse = course
                        showLearning = true
                    }
                }
            }
        }
    }

    // MARK: - Weekly Progress
    private var weeklyProgress: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📅 本周打卡")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.textPrimary)

            HStack(spacing: 8) {
                ForEach(viewModel.weekDays, id: \.date) { day in
                    VStack(spacing: 6) {
                        Text(day.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.textLight)

                        Circle()
                            .fill(day.isCompleted ? Color.brandOrange : day.isToday ? Color.brandOrange.opacity(0.3) : Color.gray.opacity(0.15))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Group {
                                    if day.isCompleted {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(.white)
                                    } else if day.isToday {
                                        Circle()
                                            .fill(Color.brandOrange)
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            )

                        Text("\(day.dayNumber)")
                            .font(.system(size: 11))
                            .foregroundColor(.textLight)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow()
        }
    }

    // MARK: - Badge Wall
    private var badgeWall: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🏅 我的勋章")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.textPrimary)

                Spacer()

                NavigationLink(destination: BadgeListView(badges: viewModel.allBadges)) {
                    Text("查看全部 >")
                        .font(.system(size: 13))
                        .foregroundColor(.brandOrange)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.earnedBadges) { badge in
                        BadgeCard(badge: badge)
                    }

                    // 未获得空位
                    ForEach(0..<max(0, 5 - viewModel.earnedBadges.count), id: \.self) { _ in
                        VStack(spacing: 6) {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 52, height: 52)
                                .overlay(
                                    Image(systemName: "questionmark")
                                        .foregroundColor(.gray.opacity(0.3))
                                )
                            Text("???")
                                .font(.system(size: 11))
                                .foregroundColor(.textLight)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Badge List View
struct BadgeListView: View {
    let badges: [Badge]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(badges) { badge in
                    VStack(spacing: 8) {
                        Text(badge.iconEmoji)
                            .font(.system(size: 36))
                            .frame(width: 70, height: 70)
                            .background(badge.isEarned ? Color.brandYellow.opacity(0.2) : Color.gray.opacity(0.08))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(badge.isEarned ? Color.brandYellow : Color.clear, lineWidth: 2)
                            )

                        Text(badge.name)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(badge.isEarned ? .textPrimary : .textLight)

                        Text(badge.description)
                            .font(.system(size: 11))
                            .foregroundColor(.textLight)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(badge.isEarned ? 1 : 0.5)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .cardShadow()
                }
            }
            .padding()
        }
        .background(Color.bgPrimary.ignoresSafeArea())
        .navigationTitle("我的勋章")
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
