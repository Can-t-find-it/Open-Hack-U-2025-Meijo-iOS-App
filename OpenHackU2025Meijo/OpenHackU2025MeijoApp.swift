import SwiftUI
import UserNotifications

@main
struct OpenHackU2025MeijoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TopView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        // 通知の許可をユーザーに聞く
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    // APNs に登録
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("通知許可が拒否されました")
            }
        }
        return true
    }
    
    // ✅ APNs の deviceToken 取得成功時に呼ばれる
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs Device Token: \(tokenString)")
        
        Task {
            do {
                let api = APIClient()
                try await api.registerDeviceToken(tokenString)
                print("✅ device token registered")
            } catch {
                print("❌ failed to register device token:", error)
            }
        }
    }
    
    // 取得失敗
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications:", error)
    }
    
    // アプリが前面のときもバナーを出す設定（お好みで）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
