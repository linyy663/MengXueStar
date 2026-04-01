import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("学习", systemImage: "book.fill")
                }
                .tag(0)

            CourseListView()
                .tabItem {
                    Label("课程", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(2)

            ParentControlView()
                .tabItem {
                    Label("家长", systemImage: "lock.shield.fill")
                }
                .tag(3)
        }
        .tint(.brandOrange)
    }
}
