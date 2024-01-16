//
//  CharactersFilterFlowCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

protocol CharactersFilterFlowCoordinatorDependencies {
    func makeCharactersListViewController(
        actions: CharactersListViewModelActions
    ) -> CharactersListViewController
    func makeCharacterDetailsViewController(character: RMCharacter) -> UIViewController
}

final class CharactersFilterFlowCoordinator {
    private let dependencies: CharactersFilterFlowCoordinatorDependencies

    private weak var navigationController: UINavigationController?

    private weak var charactersListVC: CharactersListViewController?

    init(navigationController: UINavigationController,
         dependencies: CharactersFilterFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = CharactersListViewModelActions(showCharacterDetails: showCharacterDetails)

        let vc = dependencies.makeCharactersListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)

        charactersListVC = vc
    }

    private func showCharacterDetails(character: RMCharacter) {
        let vc = dependencies.makeCharacterDetailsViewController(character: character)

        navigationController?.pushViewController(vc, animated: true)
    }
}
