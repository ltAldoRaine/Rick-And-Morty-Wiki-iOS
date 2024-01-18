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
    func makeCharacterDetailsViewController(
        character: RMCharacter?,
        characterId: Int?,
        actions: CharactersListViewModelActions
    ) -> UIViewController
}

final class CharactersFilterFlowCoordinator {
    // MARK: - Properties

    private let dependencies: CharactersFilterFlowCoordinatorDependencies

    private weak var navigationController: UINavigationController?
    private weak var charactersListVC: CharactersListViewController?

    init(navigationController: UINavigationController,
         dependencies: CharactersFilterFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    // MARK: - Navigation Methods

    private func showCharacterDetails(character: RMCharacter?, characterId: Int?) {
        let actions = CharactersListViewModelActions(showCharacterDetails: showCharacterDetails)

        let vc = dependencies.makeCharacterDetailsViewController(character: character, characterId: characterId, actions: actions)

        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Start Flow

    func start() {
        let actions = CharactersListViewModelActions(showCharacterDetails: showCharacterDetails)

        let vc = dependencies.makeCharactersListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)

        charactersListVC = vc
    }
}
