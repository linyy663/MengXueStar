import SwiftUI

struct LearningView: View {
    let course: Course
    let dailyTask: DailyTask?
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var totalAnswered = 0
    @State private var showCompletion = false
    @State private var isAnimating = false

    var currentQuestion: Question? {
        guard currentQuestionIndex < course.todayTasks.count else { return nil }
        return course.todayTasks[currentQuestionIndex]
    }

    var body: some View {
        ZStack {
            // 背景
            Color(hex: course.subject.color).opacity(0.08).ignoresSafeArea()

            VStack(spacing: 0) {
                // 顶部导航
                topNav

                // 进度条
                progressBar

                if let question = currentQuestion {
                    if showFeedback {
                        // 反馈动画
                        feedbackView(isCorrect: isCorrect, nextAction: {
                            advanceQuestion()
                        })
                    } else {
                        // 题目内容
                        questionContent(question: question)
                    }
                }

                Spacer()
            }

            // 完成弹窗
            if showCompletion {
                CompletionView(
                    score: score,
                    total: course.todayTasks.count,
                    stars: calculateStars(),
                    course: course,
                    onDismiss: {
                        showCompletion = false
                        dismiss()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    // MARK: - Top Nav
    private var topNav: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .clipShape(Circle())
                    .cardShadow(radius: 4, y: 2)
            }

            Spacer()

            // 课程标题
            HStack(spacing: 6) {
                Text(course.subject.emoji)
                Text(course.subject.rawValue)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(Color(hex: course.subject.accentColorHex))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(20)
            .cardShadow(radius: 6, y: 3)

            Spacer()

            // 得分
            HStack(spacing: 4) {
                Text("⭐")
                Text("\(score)")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.brandOrange)
            }
            .frame(width: 60, height: 36)
            .background(Color.white)
            .cornerRadius(18)
            .cardShadow(radius: 4, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(colors: [Color(hex: course.subject.color), Color(hex: course.subject.accentColorHex)], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * CGFloat(currentQuestionIndex) / CGFloat(max(course.todayTasks.count, 1)), height: 8)
                        .animation(.spring(response: 0.4), value: currentQuestionIndex)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 20)

            Text("第 \(currentQuestionIndex + 1) / \(course.todayTasks.count) 题")
                .font(.system(size: 12))
                .foregroundColor(.textLight)
        }
        .padding(.top, 16)
    }

    // MARK: - Question Content
    private func questionContent(question: Question) -> some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 20)

            // 题目卡片
            VStack(spacing: 16) {
                // 题目类型标签
                Text(question.type.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(hex: course.subject.color))
                    .cornerRadius(10)

                // 题目内容
                Text(question.content)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)

                // 图片（如果有）
                if question.imageURL != nil || question.content.contains("🍎") || question.content.contains("🌞") || question.content.contains("🐱") || question.content.contains("⛰️") {
                    Text(question.content.filter { !$0.isASCII })
                        .font(.system(size: 48))
                        .padding(.vertical, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white)
            .cornerRadius(28)
            .cardShadow()
            .padding(.horizontal, 20)

            // 选项
            VStack(spacing: 14) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    AnswerOptionButton(
                        option: option,
                        index: index,
                        isSelected: selectedAnswer == option,
                        subjectColor: Color(hex: course.subject.color),
                        action: {
                            selectAnswer(option)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding(.top, 8)
    }

    // MARK: - Feedback View
    private func feedbackView(isCorrect: Bool, nextAction: @escaping () -> Void) -> some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 60)

            // 动画效果
            ZStack {
                Circle()
                    .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6).repeatForever(autoreverses: true), value: isAnimating)

                Circle()
                    .fill(isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7).repeatForever(autoreverses: true), value: isAnimating)

                Text(isCorrect ? "✅" : "❌")
                    .font(.system(size: 72))
            }
            .onAppear { isAnimating = true }

            Text(isCorrect ? "太棒了！答对啦！🎉" : "没关系，再想想~")
                .font(.system(size: 26, weight: .black))
                .foregroundColor(isCorrect ? .green : .textPrimary)
                .textStroke(width: isCorrect ? 1.5 : 0, color: .white)

            if !isCorrect, let question = currentQuestion {
                Text("正确答案：\(question.correctAnswer)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
            }

            Button(action: nextAction) {
                Text(currentQuestionIndex >= course.todayTasks.count - 1 ? "查看成绩 🏆" : "下一题 ▶️")
                    .font(.system(size: 16, weight: .black))
                    .textStroke(width: 1, color: .white)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(colors: [Color(hex: course.subject.color), Color(hex: course.subject.accentColorHex)], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(25)
                    .buttonShadow(color: Color(hex: course.subject.accentColorHex), height: 5)
            }
            .padding(.top, 10)

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // auto-advance
            }
        }
    }

    // MARK: - Actions
    private func selectAnswer(_ answer: String) {
        guard !showFeedback else { return }
        selectedAnswer = answer

        if let question = currentQuestion {
            let correct = answer == question.correctAnswer
            isCorrect = correct
            totalAnswered += 1
            if correct {
                score += question.points
            }
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showFeedback = true
        }
    }

    private func advanceQuestion() {
        if currentQuestionIndex >= course.todayTasks.count - 1 {
            withAnimation {
                showCompletion = true
            }
        } else {
            selectedAnswer = nil
            showFeedback = false
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
            }
        }
    }

    private func calculateStars() -> Int {
        let ratio = Double(score) / Double(max(course.todayTasks.count * 10, 1))
        if ratio >= 0.9 { return 3 }
        else if ratio >= 0.6 { return 2 }
        else { return 1 }
    }
}

// MARK: - Answer Option Button
struct AnswerOptionButton: View {
    let option: String
    let index: Int
    let isSelected: Bool
    let subjectColor: Color
    let action: () -> Void

    @State private var isPressed = false

    private let letters = ["A", "B", "C", "D"]

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(letters[safe: index] ?? "")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(isSelected ? .white : subjectColor)
                    .frame(width: 36, height: 36)
                    .background(isSelected ? subjectColor : subjectColor.opacity(0.1))
                    .cornerRadius(10)

                Text(option)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? subjectColor : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.15), lineWidth: 1)
            )
            .buttonShadow(color: isSelected ? subjectColor.opacity(0.4) : .gray.opacity(0.15), height: isSelected ? 4 : 3)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .pressEffect(isPressed: isPressed)
        .disabled(isSelected)
    }
}

// MARK: - Safe Array Access
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
