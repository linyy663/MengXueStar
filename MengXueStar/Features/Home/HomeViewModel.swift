import Foundation
import Combine

struct WeekDay: Identifiable {
    let id = UUID()
    let date: Date
    let name: String
    let dayNumber: String
    let isCompleted: Bool
    let isToday: Bool
}

class HomeViewModel: ObservableObject {
    @Published var dailyTask: DailyTask?
    @Published var isLoading = false
    @Published var earnedBadges: [Badge] = []
    @Published var weekDays: [WeekDay] = []

    private let cloudBase = CloudBaseService.shared

    var completedCourses: Int {
        dailyTask?.completedCourses ?? 0
    }

    var totalCourses: Int {
        dailyTask?.courses.count ?? 5
    }

    var todayProgress: Double {
        guard totalCourses > 0 else { return 0 }
        return Double(completedCourses) / Double(totalCourses)
    }

    var allBadges: [Badge] {
        Badge.defaultBadges
    }

    func loadData(childId: String, grade: Grade) {
        isLoading = true
        Task { @MainActor in
            do {
                dailyTask = try await cloudBase.getDailyTasks(childId: childId, grade: grade)
                earnedBadges = allBadges.filter { badge in
                    badge.isEarned
                }
                generateWeekDays()
            } catch {
                print("加载失败: \(error)")
            }
            isLoading = false
        }
    }

    func refreshDailyTasks(childId: String, grade: Grade) {
        loadData(childId: childId, grade: grade)
    }

    private func generateWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        let todayWeekday = calendar.component(.weekday, from: today)

        weekDays = (1...7).map { dayOffset -> WeekDay in
            let diff = dayOffset - todayWeekday
            let date = calendar.date(byAdding: .day, value: diff, to: today) ?? today
            let isCompleted = diff < 0 && Bool.random() // Mock: 过去的日子随机完成
            let isToday = diff == 0

            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let name = isToday ? "今天" : formatter.string(from: date).prefix(1).description

            return WeekDay(
                date: date,
                name: name,
                dayNumber: "\(calendar.component(.day, from: date))",
                isCompleted: isCompleted,
                isToday: isToday
            )
        }
    }
}

// MARK: - Default Badges
extension Badge {
    static let defaultBadges: [Badge] = [
        Badge(id: "1", name: "初次打卡", description: "完成第一次学习", iconEmoji: "🌟", type: .checkIn, earnedAt: nil),
        Badge(id: "2", name: "7天连续", description: "连续打卡7天", iconEmoji: "🔥", type: .checkIn, earnedAt: nil),
        Badge(id: "3", name: "30天坚持", description: "连续打卡30天", iconEmoji: "💎", type: .checkIn, earnedAt: nil),
        Badge(id: "4", name: "语文达人", description: "完成50道语文题", iconEmoji: "📖", type: .subject, earnedAt: nil),
        Badge(id: "5", name: "数学小能手", description: "完成50道数学题", iconEmoji: "🧮", type: .subject, earnedAt: nil),
        Badge(id: "6", name: "英语小达人", description: "完成50道英语题", iconEmoji: "🔤", type: .subject, earnedAt: nil),
        Badge(id: "7", name: "全能小冠军", description: "完成所有科目学习", iconEmoji: "🏆", type: .special, earnedAt: nil),
    ]
}
