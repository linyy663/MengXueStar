import SwiftUI

struct CourseListView: View {
    @State private var selectedSubject: Subject?

    private let subjects = Subject.allCases

    var body: some View {
        NavigationView {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // 标题
                        HStack {
                            Text("📚 全部课程")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Text("\(subjects.count)个科目")
                                .font(.system(size: 13))
                                .foregroundColor(.textLight)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // 科目网格
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(subjects, id: \.self) { subject in
                                SubjectGridCard(subject: subject)
                            }
                        }
                        .padding(.horizontal, 20)

                        // 学习报告入口
                        studyReportCard

                        Spacer().frame(height: 100)
                    }
                }
            }
            .navigationTitle("课程")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var studyReportCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 学习报告")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.textLight)
            }

            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("23")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.brandOrange)
                    Text("累计打卡")
                        .font(.system(size: 12))
                        .foregroundColor(.textLight)
                }
                .frame(maxWidth: .infinity)

                Divider().frame(height: 40)

                VStack(spacing: 4) {
                    Text("156")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.brandBlue)
                    Text("完成题目")
                        .font(.system(size: 12))
                        .foregroundColor(.textLight)
                }
                .frame(maxWidth: .infinity)

                Divider().frame(height: 40)

                VStack(spacing: 4) {
                    Text("890")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.brandGreen)
                    Text("获得积分")
                        .font(.system(size: 12))
                        .foregroundColor(.textLight)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .cardShadow()
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }
}

// MARK: - Subject Grid Card
struct SubjectGridCard: View {
    let subject: Subject

    var body: some View {
        VStack(spacing: 12) {
            // 顶部颜色块
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(colors: [Color(hex: subject.color), Color(hex: subject.accentColorHex)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(height: 90)
                .overlay(
                    VStack(spacing: 6) {
                        Text(subject.emoji)
                            .font(.system(size: 36))

                        Text("\(Int.random(in: 10...50))道题")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                )
                .shadow(color: Color(hex: subject.color).opacity(0.4), radius: 0, x: 0, y: 6)

            // 底部信息
            VStack(spacing: 4) {
                Text(subject.rawValue)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.textPrimary)

                Text(subject.description)
                    .font(.system(size: 11))
                    .foregroundColor(.textLight)
                    .lineLimit(1)

                // 进度条
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 5)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: subject.color))
                            .frame(width: geo.size.width * CGFloat.random(in: 0.3...0.9), height: 5)
                    }
                }
                .frame(height: 5)
                .padding(.top, 4)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(20)
        .cardShadow()
    }
}
