//
//  AppFlowCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class AppFlowCoordinator {
    private let appDIContainer: AppDIContainer

    var navigationController: UINavigationController

    init(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController
    ) {
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }

    func start() {
        let charactersSceneDIContainer = appDIContainer.makeCharactersSceneDIContainer()

        let flow = charactersSceneDIContainer.makeCharactersFilterFlowCoordinator(navigationController: navigationController)

        flow.start()
    }
}
