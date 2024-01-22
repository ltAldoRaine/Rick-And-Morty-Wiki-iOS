//
//  CharactersSceneDIContainer.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class CharactersSceneDIContainer: CharactersFlowCoordinatorDependencies {
    // MARK: - Nested Types

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }

    // MARK: - Properties

    private let dependencies: Dependencies

    private lazy var rmCharacterResponseCache: RMCharacterResponseStorage = CoreDataRMCharacterResponseStorage()
    private lazy var rmCharactersPageResponseCache: RMCharactersPageResponseStorage =
        CoreDataRMCharactersPageResponseStorage()
    private lazy var rmCharactersResponseCache: RMCharactersResponseStorage = CoreDataRMCharactersResponseStorage()
    private lazy var rmEpisodeResponseCache: RMEpisodeResponseStorage = CoreDataRMEpisodeResponseStorage()
    private lazy var rmEpisodesResponseCache: RMEpisodesResponseStorage = CoreDataRMEpisodesResponseStorage()

    // MARK: - Initialization

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    private func makeFetchRMCharactersUseCase() -> FetchRMCharactersUseCase {
        DefaultFetchRMCharactersUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    private func makeFetchRMCharacterUseCase() -> FetchRMCharacterUseCase {
        DefaultFetchRMCharacterUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    private func makeFilterRMCharactersUseCase() -> FilterRMCharactersUseCase {
        DefaultFilterRMCharactersUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    private func makeFetchRMEpisodesUseCase() -> FetchRMEpisodesUseCase {
        DefaultFetchRMEpisodesUseCase(rmEpisodesRepository: makeRMEpisodesRepository())
    }

    private func makeFetchRMEpisodeUseCase() -> FetchRMEpisodeUseCase {
        DefaultFetchRMEpisodeUseCase(rmEpisodesRepository: makeRMEpisodesRepository())
    }

    // MARK: - Repositories

    private func makeRMCharactersRepository() -> RMCharactersRepository {
        DefaultRMCharactersRepository(
            dataTransferService: dependencies.apiDataTransferService,
            rmCharacterResponseCache: rmCharacterResponseCache,
            rmCharactersResponseCache: rmCharactersResponseCache,
            rmCharactersPageResponseCache: rmCharactersPageResponseCache
        )
    }

    private func makeRMEpisodesRepository() -> RMEpisodesRepository {
        DefaultRMEpisodesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            rmEpisodesResponseCache: rmEpisodesResponseCache,
            rmEpisodeResponseCache: rmEpisodeResponseCache
        )
    }

    private func makeRMPosterImagesRepository() -> RMPosterImagesRepository {
        DefaultRMPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }

    // MARK: - Characters List

    func makeCharactersListViewController(actions: CharactersListViewModelActions) -> CharactersListViewController {
        CharactersListViewController(
            with: makeCharactersListViewModel(actions: actions),
            posterImagesRepository: makeRMPosterImagesRepository()
        )
    }

    func makeCharactersListViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        DefaultCharactersListViewModel(
            filterCharactersUseCase: makeFilterRMCharactersUseCase(),
            actions: actions
        )
    }

    // MARK: - Character Details

    func makeCharacterDetailsViewController(
        character: RMCharacter?,
        characterId: Int?,
        actions: CharactersListViewModelActions
    ) -> UIViewController {
        CharacterDetailsViewController(
            with: makeCharacterDetailsViewModel(character: character, characterId: characterId, actions: actions),
            posterImagesRepository: makeRMPosterImagesRepository()
        )
    }

    func makeCharacterDetailsViewModel(
        character: RMCharacter?,
        characterId: Int?,
        actions: CharactersListViewModelActions
    ) -> CharacterDetailsViewModel {
        DefaultCharacterDetailsViewModel(
            character: character,
            characterId: characterId,
            fetchRMCharacterUseCase: makeFetchRMCharacterUseCase(),
            fetchRMEpisodesUseCase: makeFetchRMEpisodesUseCase(),
            posterImagesRepository: makeRMPosterImagesRepository(),
            actions: actions
        )
    }

    // MARK: - Flow Coordinators

    func makeCharactersFilterFlowCoordinator(
        navigationController: UINavigationController
    ) -> CharactersFilterFlowCoordinator {
        CharactersFilterFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
