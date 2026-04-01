import SwiftUI

@main
struct MengXueStarApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var currentChild: ChildProfile?

    private let defaults = UserDefaultsManager.shared

    init() {
        loadSession()
    }

    func loadSession() {
        if let userData = defaults.getUser(),
           let childData = defaults.getCurrentChild() {
            self.currentUser = userData
            self.currentChild = childData
            self.isLoggedIn = true
        }
    }

    func login(user: User, child: ChildProfile) {
        self.currentUser = user
        self.currentChild = child
        self.isLoggedIn = true
        defaults.saveUser(user)
        defaults.saveCurrentChild(child)
    }

    func logout() {
        self.currentUser = nil
        self.currentChild = nil
        self.isLoggedIn = false
        defaults.clearSession()
    }

    func updateChild(_ child: ChildProfile) {
        self.currentChild = child
        defaults.saveCurrentChild(child)
    }
}
