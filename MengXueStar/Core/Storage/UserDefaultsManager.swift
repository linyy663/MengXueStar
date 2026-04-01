import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let user = "current_user"
        static let currentChild = "current_child"
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let lastCheckInDate = "last_check_in_date"
        static let deviceToken = "device_token"
    }

    private init() {}

    // MARK: - User Session
    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: Keys.user)
        }
    }

    func getUser() -> User? {
        guard let data = defaults.data(forKey: Keys.user) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func saveCurrentChild(_ child: ChildProfile) {
        if let data = try? JSONEncoder().encode(child) {
            defaults.set(data, forKey: Keys.currentChild)
        }
    }

    func getCurrentChild() -> ChildProfile? {
        guard let data = defaults.data(forKey: Keys.currentChild) else { return nil }
        return try? JSONDecoder().decode(ChildProfile.self, from: data)
    }

    func clearSession() {
        defaults.removeObject(forKey: Keys.user)
        defaults.removeObject(forKey: Keys.currentChild)
    }

    // MARK: - Onboarding
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }

    // MARK: - Device Token
    var deviceToken: String? {
        get { defaults.string(forKey: Keys.deviceToken) }
        set { defaults.set(newValue, forKey: Keys.deviceToken) }
    }
}
