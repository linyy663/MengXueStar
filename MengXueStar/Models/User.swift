import Foundation

// MARK: - User
struct User: Codable, Identifiable {
    let id: String
    let phone: String
    let nickname: String?
    var children: [ChildProfile]
    var createdAt: Date

    init(id: String = UUID().uuidString, phone: String, nickname: String? = nil, children: [ChildProfile] = [], createdAt: Date = Date()) {
        self.id = id
        self.phone = phone
        self.nickname = nickname
        self.children = children
        self.createdAt = createdAt
    }
}

// MARK: - ChildProfile
struct ChildProfile: Codable, Identifiable {
    let id: String
    var name: String
    var avatar: ChildAvatar
    var age: Int
    var grade: Grade
    var totalPoints: Int
    var consecutiveDays: Int
    var badges: [Badge]
    var checkInRecords: [CheckInRecord]
    var parentControl: ParentControl

    init(id: String = UUID().uuidString,
         name: String,
         avatar: ChildAvatar = .fox,
         age: Int,
         grade: Grade,
         totalPoints: Int = 0,
         consecutiveDays: Int = 0,
         badges: [Badge] = [],
         checkInRecords: [CheckInRecord] = [],
         parentControl: ParentControl = ParentControl()) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.age = age
        self.grade = grade
        self.totalPoints = totalPoints
        self.consecutiveDays = consecutiveDays
        self.badges = badges
        self.checkInRecords = checkInRecords
        self.parentControl = parentControl
    }
}

enum ChildAvatar: String, Codable, CaseIterable {
    case fox = "fox"
    case rabbit = "rabbit"
    case panda = "panda"
    case cat = "cat"

    var emoji: String {
        switch self {
        case .fox: return "🦊"
        case .rabbit: return "🐰"
        case .panda: return "🐼"
        case .cat: return "🐱"
        }
    }

    var color: String {
        switch self {
        case .fox: return "FF8C42"
        case .rabbit: return "FFB3C6"
        case .panda: return "4A4A4A"
        case .cat: return "FFA07A"
        }
    }
}

enum Grade: String, Codable, CaseIterable {
    case kindergarten = "幼儿园小班"
    case middle = "幼儿园中班"
    case large = "幼儿园大班"
    case `default` = "一年级"

    var sortOrder: Int {
        switch self {
        case .kindergarten: return 0
        case .middle: return 1
        case .large: return 2
        case .default: return 3
        }
    }
}
