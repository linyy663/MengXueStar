import SwiftUI

// MARK: - View Extensions
extension View {
    // 3D 立体按钮阴影
    func buttonShadow(color: Color = .brandOrange, height: CGFloat = 6) -> some View {
        self.shadow(color: color.opacity(0.4), radius: 0, x: 0, y: height)
    }

    // 卡通描边文字效果
    func cartoonTextStroke(lineWidth: CGFloat = 3, strokeColor: Color = .white) -> some View {
        self
            .foregroundColor(.white)
            .overlay(
                self
                    .foregroundColor(strokeColor)
                    .blendMode(.sourceAtop)
            )
            .overlay(
                self
                    .foregroundStyle(.white)
                    .blendMode(.destinationOut)
            )
    }

    // 卡片阴影
    func cardShadow(color: Color = .black.opacity(0.08), radius: CGFloat = 12, y: CGFloat = 6) -> some View {
        self.shadow(color: color, radius: radius, x: 0, y: y)
    }

    // 弹性动画
    func bouncyAnimation() -> some View {
        self.animation(.spring(response: 0.4, dampingFraction: 0.6), value: UUID())
    }

    // 按下效果
    func pressEffect(isPressed: Bool) -> some View {
        self
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    // 渐变背景
    func gradientBackground(from: Color, to: Color) -> some View {
        self.background(
            LinearGradient(colors: [from, to], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }

    // 主题背景
    func themeBackground() -> some View {
        self.background(Color.bgPrimary.ignoresSafeArea())
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
