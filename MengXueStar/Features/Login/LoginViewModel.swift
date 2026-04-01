import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var phone = ""
    @Published var code = ""
    @Published var isLoading = false
    @Published var codeCountdown = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var foxScale: CGFloat = 1.0

    var loggedInUser: User?
    var loggedInChild: ChildProfile?

    private var countdownTimer: Timer?
    private let cloudBase = CloudBaseService.shared

    var canLogin: Bool {
        phone.count == 11 && code.count == 6
    }

    init() {
        startCountdownTimer()
    }

    deinit {
        countdownTimer?.invalidate()
    }

    // MARK: - Send SMS Code
    func sendCode() {
        guard phone.count == 11 else {
            showAlert(message: "请输入正确的11位手机号")
            return
        }

        Task { @MainActor in
            isLoading = true
            do {
                let success = try await cloudBase.sendSMS(phone: phone)
                if success {
                    codeCountdown = 60
                    showAlert(message: "验证码已发送！\n开发测试阶段验证码为：任意6位数字")
                }
            } catch {
                showAlert(message: "发送失败，请稍后重试")
            }
            isLoading = false
        }
    }

    // MARK: - Login
    func login(completion: @escaping (Bool) -> Void) {
        guard phone.count == 11 else {
            showAlert(message: "请输入正确的11位手机号")
            completion(false)
            return
        }
        guard code.count == 6 else {
            showAlert(message: "请输入6位验证码")
            completion(false)
            return
        }

        Task { @MainActor in
            isLoading = true
            do {
                // 验证验证码
                let verified = try await cloudBase.verifySMS(phone: phone, code: code)
                if verified {
                    // 登录（注册）
                    let (user, child) = try await cloudBase.login(
                        phone: phone,
                        childName: "萌宝",
                        childAge: 5,
                        grade: .large
                    )
                    self.loggedInUser = user
                    self.loggedInChild = child
                    completion(true)
                } else {
                    showAlert(message: "验证码错误，请重试")
                    completion(false)
                }
            } catch {
                showAlert(message: "登录失败：\(error.localizedDescription)")
                completion(false)
            }
            isLoading = false
        }
    }

    // MARK: - Private
    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.codeCountdown > 0 {
                self.codeCountdown -= 1
            }
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
