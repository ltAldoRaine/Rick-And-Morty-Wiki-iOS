//
//  CharactersFlowCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
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

    private let dependencies: CharactersFlowCoordinatorDependencies

    private weak var navigationController: UINavigationController?
    private weak var charactersListVC: CharactersListViewController?

    init(navigationController: UINavigationController,
         dependencies: CharactersFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    // MARK: - Navigation Methods

    private func showCharacterDetails(character: RMCharacter?, characterId: Int?) {
        let actions = CharactersListViewModelActions(showCharacterDetails: showCharacterDetails)

        let characterDetailsVC = dependencies.makeCharacterDetailsViewController(
            character: character,
            characterId: characterId,
            actions: actions
        )

        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }

    // MARK: - Start Flow

    func start() {
        let actions = CharactersListViewModelActions(showCharacterDetails: showCharacterDetails)

        let charactersListVC = dependencies.makeCharactersListViewController(actions: actions)

        navigationController?.pushViewController(charactersListVC, animated: false)

        self.charactersListVC = charactersListVC
    }
}
