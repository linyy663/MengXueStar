import SwiftUI

struct ParentControlView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ParentControlViewModel()
    @State private var showSaveSuccess = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // 家长验证入口
                        parentGuardCard

                        // 时间控制
                        timeControlSection

                        // 科目控制
                        subjectControlSection

                        // 通知设置
                        notificationSection

                        // 保存按钮
                        saveButton

                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("家长中心")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let child = appState.currentChild {
                    viewModel.loadSettings(from: child.parentControl)
                }
            }
            .alert("保存成功", isPresented: $showSaveSuccess) {
                Button("好的", role: .cancel) {}
            }
        }
    }

    // MARK: - Parent Guard Card
    private var parentGuardCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.brandPurple.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.brandPurple)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("家长守护模式")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(.textPrimary)

                Text("家长验证后可进入设置，保护孩子学习体验")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(20)
        .cardShadow()
    }

    // MARK: - Time Control Section
    private var timeControlSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("⏰ 时间控制")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            VStack(spacing: 16) {
                // 每日时长限制
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("每日学习时长上限")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Spacer()

                        Toggle("", isOn: $viewModel.isTimeLimitEnabled)
                            .labelsHidden()
                            .tint(.brandOrange)
                    }

                    if viewModel.isTimeLimitEnabled {
                        VStack(spacing: 8) {
                            Slider(value: $viewModel.dailyTimeLimit, in: 15...120, step: 5)
                                .tint(.brandOrange)

                            HStack {
                                Text("15分钟")
                                    .font(.system(size: 11))
                                    .foregroundColor(.textLight)
                                Spacer()
                                Text("\(Int(viewModel.dailyTimeLimit)) 分钟")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.brandOrange)
                                Spacer()
                                Text("120分钟")
                                    .font(.system(size: 11))
                                    .foregroundColor(.textLight)
                            }
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isTimeLimitEnabled)
                    }
                }

                Divider()

                // 时间段限制
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("可用时间段")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Spacer()

                        Toggle("", isOn: $viewModel.isTimeRangeEnabled)
                            .labelsHidden()
                            .tint(.brandOrange)
                    }

                    if viewModel.isTimeRangeEnabled {
                        HStack(spacing: 12) {
                            timePicker(label: "开始", selection: $viewModel.startTime)
                            Text("至")
                                .font(.system(size: 14))
                                .foregroundColor(.textLight)
                            timePicker(label: "结束", selection: $viewModel.endTime)
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isTimeRangeEnabled)
                    }
                }
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow()
        }
    }

    // MARK: - Subject Control Section
    private var subjectControlSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📚 科目控制")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            VStack(spacing: 12) {
                ForEach(Subject.allCases, id: \.self) { subject in
                    subjectToggleRow(subject: subject)
                }
            }
        }
    }

    private func subjectToggleRow(subject: Subject) -> some View {
        HStack(spacing: 12) {
            Text(subject.emoji)
                .font(.system(size: 24))
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(subject.rawValue)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text(subject.description)
                    .font(.system(size: 12))
                    .foregroundColor(.textLight)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { viewModel.isSubjectEnabled(subject) },
                set: { viewModel.toggleSubject(subject, enabled: $0) }
            ))
            .labelsHidden()
            .tint(.brandOrange)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .cardShadow(radius: 6, y: 3)
    }

    // MARK: - Notification Section
    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🔔 通知设置")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            VStack(spacing: 0) {
                notificationRow(title: "每日学习提醒", subtitle: "定时推送学习提醒", isOn: $viewModel.isNotificationEnabled, color: .brandOrange)
                Divider().padding(.leading, 16)
                notificationRow(title: "学习报告推送", subtitle: "每日/每周学习数据报告", isOn: $viewModel.isReportEnabled, color: .brandBlue)
            }
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow()
        }
    }

    private func notificationRow(title: String, subtitle: String, isOn: Binding<Bool>, color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "bell.fill")
                        .font(.system(size: 14))
                        .foregroundColor(color)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textLight)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.brandOrange)
        }
        .padding(14)
    }

    // MARK: - Time Picker
    private func timePicker(label: String, selection: Binding<String>) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textLight)

            HStack(spacing: 4) {
                Text(selection.wrappedValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.brandOrange)

                Menu {
                    ForEach(["07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00"], id: \.self) { time in
                        Button(time) {
                            selection.wrappedValue = time
                        }
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.brandOrange)
                }
            }
            .frame(minWidth: 80)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.brandOrange.opacity(0.1))
            .cornerRadius(10)
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            viewModel.saveSettings { success in
                if success {
                    showSaveSuccess = true
                    if let child = appState.currentChild {
                        appState.updateChild(
                            ChildProfile(
                                id: child.id,
                                name: child.name,
                                avatar: child.avatar,
                                age: child.age,
                                grade: child.grade,
                                totalPoints: child.totalPoints,
                                consecutiveDays: child.consecutiveDays,
                                badges: child.badges,
                                checkInRecords: child.checkInRecords,
                                parentControl: viewModel.buildParentControl()
                            )
                        )
                    }
                }
            }
        }) {
            HStack {
                if viewModel.isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("💾 保存设置")
                        .font(.system(size: 16, weight: .black))
                        .textStroke(width: 1.2, color: .white)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                LinearGradient(colors: [Color(hex: "FF8C42"), Color(hex: "FF6B35")], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(27)
            .buttonShadow(color: Color(hex: "CC5520"), height: 5)
        }
        .disabled(viewModel.isSaving)
    }
}
