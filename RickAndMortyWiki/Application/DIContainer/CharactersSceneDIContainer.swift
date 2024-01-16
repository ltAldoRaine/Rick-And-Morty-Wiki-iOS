//
//  CharactersSceneDIContainer.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import SwiftUI
import UIKit

final class CharactersSceneDIContainer: CharactersFilterFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }

    private let dependencies: Dependencies

    // MARK: - Persistent Storage

    lazy var rmCharacterResponseCache: RMCharacterResponseStorage = CoreDataRMCharacterResponseStorage()
    lazy var rmCharactersPageResponseCache: RMCharactersPageResponseStorage = CoreDataRMCharactersPageResponseStorage()
    lazy var rmCharactersResponseCache: RMCharactersResponseStorage = CoreDataRMCharactersResponseStorage()
    lazy var rmEpisodeResponseCache: RMEpisodeResponseStorage = CoreDataRMEpisodeResponseStorage()
    lazy var rmEpisodesResponseCache: RMEpisodesResponseStorage = CoreDataRMEpisodesResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    func makeFetchRMCharactersUseCase() -> FetchRMCharactersUseCase {
        DefaultFetchRMCharactersUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    func makeFetchRMCharacterUseCase() -> FetchRMCharacterUseCase {
        DefaultFetchRMCharacterUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    func makeFilterRMCharactersUseCase() -> FilterRMCharactersUseCase {
        DefaultFilterRMCharactersUseCase(rmCharactersRepository: makeRMCharactersRepository())
    }

    func makeFetchRMEpisodesUseCase() -> FetchRMEpisodesUseCase {
        DefaultFetchRMEpisodesUseCase(rmEpisodesRepository: makeRMEpisodesRepository())
    }

    func makeFetchRMEpisodeUseCase() -> FetchRMEpisodeUseCase {
        DefaultFetchRMEpisodeUseCase(rmEpisodesRepository: makeRMEpisodesRepository())
    }

    // MARK: - Repositories

    func makeRMCharactersRepository() -> RMCharactersRepository {
        DefaultRMCharactersRepository(
            dataTransferService: dependencies.apiDataTransferService,
            rmCharacterResponseCache: rmCharacterResponseCache,
            rmCharactersResponseCache: rmCharactersResponseCache,
            rmCharactersPageResponseCache: rmCharactersPageResponseCache
        )
    }

    func makeRMEpisodesRepository() -> RMEpisodesRepository {
        DefaultRMEpisodesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            rmEpisodesResponseCache: rmEpisodesResponseCache,
            rmEpisodeResponseCache: rmEpisodeResponseCache
        )
    }

    func makeRMPosterImagesRepository() -> RMPosterImagesRepository {
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

    func makeCharacterDetailsViewController(character: RMCharacter) -> UIViewController {
        CharacterDetailsViewController(
            with: makeCharacterDetailsViewModel(character: character),
            posterImagesRepository: makeRMPosterImagesRepository()
        )
    }

    func makeCharacterDetailsViewModel(character: RMCharacter) -> CharacterDetailsViewModel {
        DefaultCharacterDetailsViewModel(
            character: character,
            posterImagesRepository: makeRMPosterImagesRepository()
        )
    }

    // MARK: - Flow Coordinators

    func makeCharactersFilterFlowCoordinator(navigationController: UINavigationController) -> CharactersFilterFlowCoordinator {
        CharactersFilterFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
