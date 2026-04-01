import Foundation

struct AppConfig {
    // MARK: - App Info
    static let appName = "萌学星球"
    static let appNameEnglish = "MengXueStar"
    static let bundleIdentifier = "com.mengxuexingqiu.app"

    // TODO: 正式打包时从外部传入（用户提供的bundle id）
    static var currentBundleId: String {
        return UserDefaults.standard.string(forKey: "bundle_id") ?? bundleIdentifier
    }

    // MARK: - CloudBase Config
    // TODO: 替换为你的腾讯云CloudBase环境ID
    static let cloudBaseEnvId = "YOUR_CLOUDBASE_ENV_ID"

    // MARK: - API Endpoints
    struct API {
        static let baseURL = "https://api.mengxuexingqiu.com"
        static let smsSend = "/sms/send"
        static let smsVerify = "/sms/verify"
        static let login = "/auth/login"
        static let dailyTasks = "/tasks/daily"
        static let checkIn = "/checkin/submit"
        static let parentSettings = "/parent/settings"
        static let parentSettingsUpdate = "/parent/settings/update"
    }

    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 56
        static let cardCornerRadius: CGFloat = 24
        static let iconSize: CGFloat = 32
    }

    // MARK: - Study Constants
    struct Study {
        static let dailyStudyMinutes = 30
        static let pointsPerCorrectAnswer = 10
        static let bonusPointsPerDay = 50
        static let streakBonusPoints = [0, 10, 20, 30, 50, 80, 100]
    }

    // MARK: - Mock Data for Development
    static let useMockData = true  // 开发阶段用Mock，正式上线改为false
}
