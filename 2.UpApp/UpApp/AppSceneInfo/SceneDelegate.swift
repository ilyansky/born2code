import UIKit
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var totalSecondsFromSession = 0
//    var pausedTimerFlag = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = TabBarController(nibName: nil, bundle: nil)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    // Timer "in background"
    func sceneDidEnterBackground(_ scene: UIScene) {
        if PerkTimer.timerIsActive == true {
            totalSecondsFromSession = PerkTimer.totalSeconds
            PerkTimer.timeBeforeBackground = Date()
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
            if PerkTimer.timerIsActive == true {
                PerkTimer.timeAfterBackground = Date()
                totalSecondsFromSession += Int(PerkTimer.timeAfterBackground.timeIntervalSince(PerkTimer.timeBeforeBackground))
                PerkTimer.totalSeconds = totalSecondsFromSession
                
                PerkTimer.refreshDates() // MAYBE DEL
        }
    }
}

