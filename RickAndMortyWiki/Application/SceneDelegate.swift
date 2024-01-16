//
//  SceneDelegate.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 11.01.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()

    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    private func openWindow(with scene: UIScene) {
        guard let scene = (scene as? UIWindowScene) else { return }

        AppAppearance.setupAppearance()

        window = UIWindow(windowScene: scene)

        let navigationController = UINavigationController()

        window?.rootViewController = navigationController

        appFlowCoordinator = AppFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: navigationController
        )

        appFlowCoordinator?.start()

        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        openWindow(with: scene)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openWindow(with: scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
