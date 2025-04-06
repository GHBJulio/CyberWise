import SwiftUI
import LocalAuthentication // For Face ID / Touch ID

@main
struct CyberWiseMainApp: App {
    @StateObject private var loginManager = LoginManager()
    @State private var isAppLocked: Bool = UserDefaults.standard.bool(forKey: "isAppLocked") // Persist lock state

    var body: some Scene {
        WindowGroup {
            if isAppLocked {
                LockScreenView(isAppLocked: $isAppLocked)
                    .environmentObject(loginManager) // Show lock screen when locked
            } else {
                AppView()
                    .environmentObject(loginManager)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        if loginManager.isAuthenticated { // Only lock if logged in
                            isAppLocked = true
                            UserDefaults.standard.set(true, forKey: "isAppLocked")
                        }
                    }
            }
        }
    }
}

struct AppView: View {
    @EnvironmentObject var loginManager: LoginManager
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some View {
        if loginManager.isAuthenticated {
            if !(loginManager.currentUser?.hasCompletedOnboarding ?? true) {
                FirstOnBoardingScreenUI()
            } else {
                HomeScreenUI()
            }
        } else {
            LoginScreenUI()
        }
    }
}

