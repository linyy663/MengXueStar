import Foundation

// MARK: - Course
struct Course: Codable, Identifiable {
    let id: String
    let subject: Subject
    var title: String
    var description: String
    var iconEmoji: String
    var progress: Double
    var todayTasks: [Question]

    init(id: String = UUID().uuidString, subject: Subject, title: String, description: String, progress: Double = 0, todayTasks: [Question] = []) {
        self.id = id
        self.subject = subject
        self.title = title
        self.description = description
        self.iconEmoji = subject.emoji
        self.progress = progress
        self.todayTasks = todayTasks
    }
}

// MARK: - Subject
enum Subject: String, Codable, CaseIterable {
    case chinese = "语文"
    case math = "数学"
    case english = "英语"
    case thinking = "思维"
    case writing = "写字"

    var emoji: String {
        switch self {
        case .chinese: return "📖"
        case .math: return "🔢"
        case .english: return "🔤"
        case .thinking: return "🧩"
        case .writing: return "✏️"
        }
    }

    var color: String {
        switch self {
        case .chinese: return "FF6B6B"
        case .math: return "4ECDC4"
        case .english: return "FFE66D"
        case .thinking: return "C7B8FF"
        case .writing: return "FF8C42"
        }
    }

    var accentColorHex: String {
        switch self {
        case .chinese: return "E84545"
        case .math: return "3DAAA0"
        case .english: return "E6C84A"
        case .thinking: return "A894F5"
        case .writing: return "D97030"
        }
    }

    var description: String {
        switch self {
        case .chinese: return "识字/拼音/看图说话"
        case .math: return "数数/口算/图形认知"
        case .english: return "字母/单词/简单对话"
        case .thinking: return "逻辑/观察/记忆力"
        case .writing: return "笔画/控笔/汉字描红"
        }
    }
}

// MARK: - DailyTask
struct DailyTask: Codable, Identifiable {
    let id: String
    let date: Date
    let courses: [Course]
    let totalMinutes: Int

    var isCompleted: Bool {
        courses.allSatisfy { $0.progress >= 1.0 }
    }

    var completedCourses: Int {
        courses.filter { $0.progress >= 1.0 }.count
    }
}
