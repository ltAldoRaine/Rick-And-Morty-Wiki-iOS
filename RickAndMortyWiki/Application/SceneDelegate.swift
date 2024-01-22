//
//  SceneDelegate.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 11.01.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    private let appDIContainer = AppDIContainer()

    private var appFlowCoordinator: AppFlowCoordinator?

    var window: UIWindow?

    // MARK: - UIWindow Setup

    private func setupWindow(with scene: UIWindowScene) {
        AppAppearance.setupAppearance()

        window = UIWindow(windowScene: scene)

        guard let window = window else {
            fatalError("Error creating UIWindow.")
        }

        let navigationController = UINavigationController()

        window.rootViewController = navigationController

        appFlowCoordinator = AppFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: navigationController
        )

        appFlowCoordinator?.start()

        window.makeKeyAndVisible()
    }

    // MARK: - UIScene Lifecycle

    func scene(
        _ scene:
        UIScene,
        willConnectTo
        session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        setupWindow(with: scene)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let scene = (scene as? UIWindowScene) else { return }

        setupWindow(with: scene)
    }
}
