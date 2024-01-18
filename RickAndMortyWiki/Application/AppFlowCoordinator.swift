//
//  AppFlowCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

/// Coordinator responsible for starting the main flow of the app.
final class AppFlowCoordinator {
    // MARK: - Properties

    private let appDIContainer: AppDIContainer
    private var navigationController: UINavigationController

    // MARK: - Initialization

    /// Initializes the coordinator with the necessary dependencies.
    ///
    /// - Parameters:
    ///   - appDIContainer: The dependency container for the app.
    ///   - navigationController: The navigation controller to manage the flow.
    init(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController
    ) {
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }

    // MARK: - Public Methods

    /// Starts the main flow of the app.
    func start() {
        let charactersSceneDIContainer = appDIContainer.makeCharactersSceneDIContainer()

        let flow = charactersSceneDIContainer.makeCharactersFilterFlowCoordinator(navigationController: navigationController)

        flow.start()
    }
}
