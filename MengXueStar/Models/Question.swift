import Foundation

// MARK: - Question
struct Question: Codable, Identifiable {
    let id: String
    let subject: Subject
    let type: QuestionType
    let content: String
    let audioURL: String?
    let imageURL: String?
    let options: [String]
    let correctAnswer: String
    var points: Int
    var explanation: String?

    var answeredCorrectly: Bool?
    var userAnswer: String?

    init(id: String = UUID().uuidString,
         subject: Subject,
         type: QuestionType,
         content: String,
         audioURL: String? = nil,
         imageURL: String? = nil,
         options: [String] = [],
         correctAnswer: String,
         points: Int = 10,
         explanation: String? = nil) {
        self.id = id
        self.subject = subject
        self.type = type
        self.content = content
        self.audioURL = audioURL
        self.imageURL = imageURL
        self.options = options
        self.correctAnswer = correctAnswer
        self.points = points
        self.explanation = explanation
    }

    mutating func answer(_ answer: String) {
        self.userAnswer = answer
        self.answeredCorrectly = answer == correctAnswer
    }
}

// MARK: - QuestionType
enum QuestionType: String, Codable {
    case choice = "选择题"
    case fillBlank = "填空题"
    case audio = "听力题"
    case image = "图片题"
    case drawing = "描红题"
}

// MARK: - CheckInRecord
struct CheckInRecord: Codable, Identifiable {
    let id: String
    let date: Date
    let completedCourses: Int
    let totalCourses: Int
    let pointsEarned: Int
    var stars: Int

    var isCompleted: Bool {
        completedCourses == totalCourses
    }
}

// MARK: - Badge
struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let iconEmoji: String
    let type: BadgeType
    let earnedAt: Date?

    var isEarned: Bool {
        earnedAt != nil
    }

    init(id: String = UUID().uuidString, name: String, description: String, iconEmoji: String, type: BadgeType, earnedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.iconEmoji = iconEmoji
        self.type = type
        self.earnedAt = earnedAt
    }
}

enum BadgeType: String, Codable {
    case checkIn = "打卡勋章"
    case subject = "科目勋章"
    case special = "特殊勋章"
}

// MARK: - ParentControl
struct ParentControl: Codable {
    var dailyTimeLimitMinutes: Int
    var allowedTimeStart: String
    var allowedTimeEnd: String
    var isTimeLimitEnabled: Bool
    var isTimeRangeEnabled: Bool
    var subjectsEnabled: [Subject]
    var isNotificationsEnabled: Bool

    init(dailyTimeLimitMinutes: Int = 60,
         allowedTimeStart: String = "07:00",
         allowedTimeEnd: String = "21:00",
         isTimeLimitEnabled: Bool = false,
         isTimeRangeEnabled: Bool = false,
         subjectsEnabled: [Subject] = Subject.allCases,
         isNotificationsEnabled: Bool = true) {
        self.dailyTimeLimitMinutes = dailyTimeLimitMinutes
        self.allowedTimeStart = allowedTimeStart
        self.allowedTimeEnd = allowedTimeEnd
        self.isTimeLimitEnabled = isTimeLimitEnabled
        self.isTimeRangeEnabled = isTimeRangeEnabled
        self.subjectsEnabled = subjectsEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
    }

    var timeRangeDescription: String {
        "\(allowedTimeStart) - \(allowedTimeEnd)"
    }
}
