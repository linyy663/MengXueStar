import SwiftUI

struct CompletionView: View {
    let score: Int
    let total: Int
    let stars: Int
    let course: Course
    let onDismiss: () -> Void

    @State private var showConfetti = false
    @State private var starScales: [CGFloat] = [0, 0, 0]
    @State private var cardScale: CGFloat = 0.5
    @State private var showCard = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            // 彩带动画
            if showConfetti {
                ConfettiView()
            }

            VStack(spacing: 24) {
                Spacer()

                // 星星评价
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { i in
                        Text(i < stars ? "⭐" : "☆")
                            .font(.system(size: 52))
                            .scaleEffect(starScales[i])
                            .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(Double(i) * 0.2), value: starScales[i])
                    }
                }

                // 标题
                VStack(spacing: 8) {
                    Text(stars == 3 ? "太棒啦！" : stars == 2 ? "很优秀！🌟" : "加油！💪")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                        .textStroke(width: 2, color: course.subject.color)

                    Text(course.subject.rawValue + "学习完成！")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }

                // 成绩卡片
                HStack(spacing: 20) {
                    scoreItem(value: "\(score)", label: "获得积分", emoji: "⭐", color: .brandYellow)
                    scoreItem(value: "\(stars * 20)", label: "经验值", emoji: "📚", color: .brandBlue)
                    scoreItem(value: "\(stars * 5)", label: "连续打卡", emoji: "🔥", color: .brandOrange)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(24)
                .cardShadow()

                // 鼓励语
                Text(encouragementText)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // 按钮
                VStack(spacing: 12) {
                    Button(action: onDismiss) {
                        Text("返回首页 🏠")
                            .font(.system(size: 16, weight: .black))
                            .textStroke(width: 1.2, color: .white)
                            .foregroundColor(.white)
                            .frame(width: 220, height: 50)
                            .background(LinearGradient(colors: [Color(hex: course.subject.color), Color(hex: course.subject.accentColorHex)], startPoint: .top, endPoint: .bottom))
                            .cornerRadius(25)
                            .buttonShadow(color: Color(hex: course.subject.accentColorHex), height: 5)
                    }

                    Button(action: onDismiss) {
                        Text("再学一科 📚")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                Spacer()
            }
            .scaleEffect(cardScale)
        }
        .onAppear {
            animateIn()
        }
    }

    private func scoreItem(value: String, label: String, emoji: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 24))
            Text(value)
                .font(.system(size: 22, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textLight)
        }
    }

    private var encouragementText: String {
        if stars == 3 { return "🎊 全对！你是最棒的！\n继续坚持，每天进步一点点！" }
        else if stars == 2 { return "🌟 做得很好！\n再仔细一点，就能全对了哦~" }
        else { return "💪 加油！\n多练习几次，你一定能做得更好！" }
    }

    private func animateIn() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            cardScale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showConfetti = true
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    starScales[i] = 1.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        starScales[i] = 1.0
                    }
                }
            }
        }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confetti) { piece in
                    Text(piece.emoji)
                        .font(.system(size: piece.size))
                        .position(piece.position)
                        .opacity(piece.opacity)
                }
            }
            .onAppear {
                generateConfetti(in: geo.size)
                animateConfetti(in: geo.size)
            }
        }
    }

    private func generateConfetti(in size: CGSize) {
        let emojis = ["🎉", "🎊", "⭐", "🌟", "💫", "✨", "🎈", "🌈", "🎁", "🏆"]
        confetti = (0..<30).map { _ in
            ConfettiPiece(
                emoji: emojis.randomElement() ?? "🎉",
                position: CGPoint(x: CGFloat.random(in: 0...size.width), y: -20),
                size: CGFloat.random(in: 18...30),
                opacity: 1
            )
        }
    }

    private func animateConfetti(in size: CGSize) {
        for i in confetti.indices {
            let delay = Double.random(in: 0...0.5)
            let duration = Double.random(in: 2...3.5)

            withAnimation(.easeOut(duration: duration).delay(delay)) {
                confetti[i].position = CGPoint(
                    x: confetti[i].position.x + CGFloat.random(in: -100...100),
                    y: size.height + 50
                )
                confetti[i].opacity = 0
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var emoji: String
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
}
