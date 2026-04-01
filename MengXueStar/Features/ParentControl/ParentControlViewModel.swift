import Foundation
import Combine

class ParentControlViewModel: ObservableObject {
    @Published var isTimeLimitEnabled = false
    @Published var dailyTimeLimit: Double = 60
    @Published var isTimeRangeEnabled = false
    @Published var startTime = "07:00"
    @Published var endTime = "21:00"
    @Published var enabledSubjects: Set<Subject> = Set(Subject.allCases)
    @Published var isNotificationEnabled = true
    @Published var isReportEnabled = true
    @Published var isSaving = false

    private let cloudBase = CloudBaseService.shared

    func loadSettings(from control: ParentControl) {
        isTimeLimitEnabled = control.isTimeLimitEnabled
        dailyTimeLimit = Double(control.dailyTimeLimitMinutes)
        isTimeRangeEnabled = control.isTimeRangeEnabled
        startTime = control.allowedTimeStart
        endTime = control.allowedTimeEnd
        enabledSubjects = Set(control.subjectsEnabled)
        isNotificationEnabled = control.isNotificationsEnabled
    }

    func isSubjectEnabled(_ subject: Subject) -> Bool {
        enabledSubjects.contains(subject)
    }

    func toggleSubject(_ subject: Subject, enabled: Bool) {
        if enabled {
            enabledSubjects.insert(subject)
        } else {
            enabledSubjects.remove(subject)
        }
    }

    func buildParentControl() -> ParentControl {
        ParentControl(
            dailyTimeLimitMinutes: Int(dailyTimeLimit),
            allowedTimeStart: startTime,
            allowedTimeEnd: endTime,
            isTimeLimitEnabled: isTimeLimitEnabled,
            isTimeRangeEnabled: isTimeRangeEnabled,
            subjectsEnabled: Array(enabledSubjects),
            isNotificationsEnabled: isNotificationEnabled
        )
    }

    func saveSettings(completion: @escaping (Bool) -> Void) {
        isSaving = true
        Task { @MainActor in
            do {
                // Mock: 实际调用云端保存
                try await Task.sleep(nanoseconds: 800_000_000)
                completion(true)
            } catch {
                completion(false)
            }
            isSaving = false
        }
    }
}
