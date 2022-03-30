//
//  SceneDelegate.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 26.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeMainViewController()
        window.makeKeyAndVisible()
        self.window = window
    }

    private func makeMainViewController() -> UIViewController {
        let loginVC = LoginVC()
        let mainUINavigationController = MainUINavigationController(rootViewController: loginVC)
        return mainUINavigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
