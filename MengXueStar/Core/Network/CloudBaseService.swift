import Foundation

// MARK: - CloudBase Service
class CloudBaseService {
    static let shared = CloudBaseService()

    private let envId = AppConfig.cloudBaseEnvId

    private init() {}

    // MARK: - Send SMS
    func sendSMS(phone: String) async throws -> Bool {
        // 调用腾讯云CloudBase云函数发送短信
        // 实际调用: tcb.callFunction({ name: "sendSMS", data: { phone } })
        // 这里用本地Mock模拟
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 500_000_000)
            return true
        }
        return try await callFunction(name: "sendSMS", data: ["phone": phone])
    }

    // MARK: - Verify SMS Code
    func verifySMS(phone: String, code: String) async throws -> Bool {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 300_000_000)
            return code == "123456" || code.count == 6
        }
        return try await callFunction(name: "verifySMS", data: ["phone": phone, "code": code])
    }

    // MARK: - Login
    func login(phone: String, childName: String, childAge: Int, grade: Grade) async throws -> (User, ChildProfile) {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 500_000_000)
            let user = User(phone: phone, nickname: "家长用户")
            let child = ChildProfile(name: childName, age: childAge, grade: grade)
            return (user, child)
        }
        return try await callFunction(name: "login", data: [
            "phone": phone,
            "childName": childName,
            "childAge": childAge,
            "grade": grade.rawValue
        ])
    }

    // MARK: - Get Daily Tasks (AI Generated)
    func getDailyTasks(childId: String, grade: Grade) async throws -> DailyTask {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 800_000_000)
            return MockDataGenerator.generateDailyTask(grade: grade)
        }
        return try await callFunction(name: "getDailyTasks", data: [
            "childId": childId,
            "grade": grade.rawValue,
            "date": ISO8601DateFormatter().string(from: Date())
        ])
    }

    // MARK: - Submit Answer
    func submitAnswer(questionId: String, answer: String, isCorrect: Bool, childId: String) async throws -> Int {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 200_000_000)
            return isCorrect ? AppConfig.Study.pointsPerCorrectAnswer : 0
        }
        return try await callFunction(name: "submitAnswer", data: [
            "questionId": questionId,
            "answer": answer,
            "isCorrect": isCorrect,
            "childId": childId
        ])
    }

    // MARK: - Check In
    func checkIn(childId: String, date: Date, pointsEarned: Int, stars: Int) async throws -> CheckInRecord {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 300_000_000)
            return CheckInRecord(id: UUID().uuidString, date: date, completedCourses: 5, totalCourses: 5, pointsEarned: pointsEarned, stars: stars)
        }
        return try await callFunction(name: "checkIn", data: [
            "childId": childId,
            "date": ISO8601DateFormatter().string(from: date),
            "pointsEarned": pointsEarned,
            "stars": stars
        ])
    }

    // MARK: - Get Parent Settings
    func getParentSettings(childId: String) async throws -> ParentControl {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 200_000_000)
            return ParentControl()
        }
        return try await callFunction(name: "getParentSettings", data: ["childId": childId])
    }

    // MARK: - Update Parent Settings
    func updateParentSettings(childId: String, settings: ParentControl) async throws -> Bool {
        if AppConfig.useMockData {
            try await Task.sleep(nanoseconds: 300_000_000)
            return true
        }
        let encoder = JSONEncoder()
        let settingsData = try encoder.encode(settings)
        let settingsDict = try JSONSerialization.jsonObject(with: settingsData) as? [String: Any] ?? [:]
        return try await callFunction(name: "updateParentSettings", data: [
            "childId": childId,
            "settings": settingsDict
        ])
    }

    // MARK: - Private: Call Cloud Function
    private func callFunction<T: Decodable>(name: String, data: [String: Any]) async throws -> T {
        // TODO: 实际实现调用腾讯云CloudBase SDK
        // let res = try await tcb.callFunction(name: name, data: data)
        // return try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: res))
        throw CloudBaseError.notImplemented
    }
}

enum CloudBaseError: Error {
    case notImplemented
    case networkError
    case serverError(String)
}

// MARK: - Mock Data Generator
struct MockDataGenerator {

    static func generateDailyTask(grade: Grade) -> DailyTask {
        let courses: [Course] = Subject.allCases.map { subject in
            Course(
                subject: subject,
                title: subject.rawValue,
                description: subject.description,
                progress: 0,
                todayTasks: generateQuestions(for: subject, grade: grade)
            )
        }

        return DailyTask(
            id: UUID().uuidString,
            date: Date(),
            courses: courses,
            totalMinutes: AppConfig.Study.dailyStudyMinutes
        )
    }

    static func generateQuestions(for subject: Subject, grade: Grade) -> [Question] {
        switch subject {
        case .chinese:
            return [
                Question(subject: .chinese, type: .choice, content: "哪个字是'日'字？", options: ["日", "目", "田", "白"], correctAnswer: "日"),
                Question(subject: .chinese, type: .choice, content: "'大'字有几笔？", options: ["2笔", "3笔", "4笔", "5笔"], correctAnswer: "3笔"),
                Question(subject: .chinese, type: .fillBlank, content: "天上有个______(太阳/月亮)🌞", options: ["太阳"], correctAnswer: "太阳"),
                Question(subject: .chinese, type: .image, content: "图中是什么水果？🍎", options: ["苹果", "香蕉", "橙子", "葡萄"], correctAnswer: "苹果"),
                Question(subject: .chinese, type: .choice, content: "'山'字像什么形状？⛰️", options: ["三角形", "圆形", "方形", "星形"], correctAnswer: "三角形"),
            ]
        case .math:
            return [
                Question(subject: .math, type: .choice, content: "1 + 2 = ?", options: ["2", "3", "4", "5"], correctAnswer: "3"),
                Question(subject: .math, type: .choice, content: "5 - 1 = ?", options: ["3", "4", "5", "6"], correctAnswer: "4"),
                Question(subject: .math, type: .choice, content: "2 + 3 = ?", options: ["4", "5", "6", "7"], correctAnswer: "5"),
                Question(subject: .math, type: .fillBlank, content: "比4多1是____", options: ["5"], correctAnswer: "5"),
                Question(subject: .math, type: .image, content: "图中有几个苹果？🍎🍎🍎", options: ["1个", "2个", "3个", "4个"], correctAnswer: "3个"),
            ]
        case .english:
            return [
                Question(subject: .english, type: .choice, content: "苹果用英语怎么说？🍎", options: ["Apple", "Banana", "Orange", "Grape"], correctAnswer: "Apple"),
                Question(subject: .english, type: .choice, content: "'Cat'是什么意思？🐱", options: ["狗", "猫", "鸟", "鱼"], correctAnswer: "猫"),
                Question(subject: .english, type: .choice, content: "太阳用英语怎么说？☀️", options: ["Moon", "Star", "Sun", "Cloud"], correctAnswer: "Sun"),
                Question(subject: .english, type: .fillBlank, content: "Hello! 你好！再见怎么说？Bye~", options: ["Goodbye"], correctAnswer: "Goodbye"),
                Question(subject: .english, type: .choice, content: "'One'是数字几？", options: ["1", "2", "3", "4"], correctAnswer: "1"),
            ]
        case .thinking:
            return [
                Question(subject: .thinking, type: .choice, content: "找规律：2, 4, 6, ___?", options: ["7", "8", "9", "10"], correctAnswer: "8"),
                Question(subject: .thinking, type: .image, content: "哪两个图形是一样的？🟩🟨🟩🟨", options: ["第1和第3", "第2和第4", "第1和第2", "第3和第4"], correctAnswer: "第1和第3"),
                Question(subject: .thinking, type: .choice, content: "小明前面有3个人，后面有2个人，一共有几人？", options: ["4人", "5人", "6人", "7人"], correctAnswer: "6人"),
                Question(subject: .thinking, type: .choice, content: "一个西瓜切3刀，最多能切几块？🍉", options: ["4块", "6块", "7块", "8块"], correctAnswer: "8块"),
                Question(subject: .thinking, type: .fillBlank, content: "○○ + ○○○ = ○○○○○? 正确吗？", options: ["正确", "错误"], correctAnswer: "正确"),
            ]
        case .writing:
            return [
                Question(subject: .writing, type: .choice, content: "'一'字的笔画顺序第一步是？", options: ["横", "竖", "撇", "点"], correctAnswer: "横"),
                Question(subject: .writing, type: .choice, content: "'人'字有几笔？", options: ["1笔", "2笔", "3笔", "4笔"], correctAnswer: "2笔"),
                Question(subject: .writing, type: .choice, content: "'口'字像什么？", options: ["圆形", "方形", "三角形", "星形"], correctAnswer: "方形"),
                Question(subject: .writing, type: .fillBlank, content: "写'大'字时，先写____", options: ["横", "竖", "撇", "捺"], correctAnswer: "横"),
                Question(subject: .writing, type: .choice, content: "握笔的正确姿势是？✏️", options: ["捏紧", "轻握", "不用手", "用脚"], correctAnswer: "轻握"),
            ]
        }
    }
}
