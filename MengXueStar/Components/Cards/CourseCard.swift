import SwiftUI

struct CourseCard: View {
    let course: Course
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // 顶部颜色块
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(colors: [Color(hex: course.subject.color), Color(hex: course.subject.accentColorHex)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(height: 80)
                        .overlay(
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(course.subject.emoji)
                                        .font(.system(size: 32))
                                    Spacer()
                                    if course.progress >= 1.0 {
                                        Text("✅")
                                            .font(.system(size: 20))
                                            .padding(6)
                                            .background(Color.white.opacity(0.3))
                                            .clipShape(Circle())
                                    }
                                }
                                Spacer()
                                Text(course.subject.rawValue)
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.white)
                            }
                            .padding(12)
                        )
                }

                // 底部进度
                VStack(spacing: 8) {
                    HStack {
                        Text(course.progress >= 1.0 ? "已完成" : "去学习")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(course.progress >= 1.0 ? .green : Color(hex: course.subject.color))

                        Spacer()

                        Text("\(Int(course.progress * 100))%")
                            .font(.system(size: 12))
                            .foregroundColor(.textLight)
                    }

                    // 进度条
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 5)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: course.subject.color))
                                .frame(width: geo.size.width * course.progress, height: 5)
                                .animation(.spring(response: 0.5), value: course.progress)
                        }
                    }
                    .frame(height: 5)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: course.subject.color).opacity(course.progress >= 1.0 ? 0 : 0.2), lineWidth: 1)
            )
            .buttonShadow(color: Color(hex: course.subject.color).opacity(0.2), height: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simulatePress(isPressed: $isPressed)
    }
}

// MARK: - Simulate Press Modifier
extension View {
    func simulatePress(isPressed: Binding<Bool>) -> some View {
        self.onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            isPressed.wrappedValue = pressing
        }, perform: {})
    }
}

struct BadgeCard: View {
    let badge: Badge

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isEarned ? Color.brandYellow.opacity(0.2) : Color.gray.opacity(0.08))
                    .frame(width: 60, height: 60)

                Text(badge.iconEmoji)
                    .font(.system(size: 30))

                if !badge.isEarned {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                }
            }

            Text(badge.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(badge.isEarned ? .textPrimary : .textLight)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}
