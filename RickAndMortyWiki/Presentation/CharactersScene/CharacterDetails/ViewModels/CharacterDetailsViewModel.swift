//
//  CharacterDetailsViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import Foundation

// MARK: - ViewModel Input

protocol CharacterDetailsViewModelInput {
    func viewDidLoad()
    func didSelectItem(with characterId: Int?)
    func didToggleEpisode(at index: Int)
}

// MARK: - ViewModel Output

protocol CharacterDetailsViewModelOutput {
    var item: CharactersListItemViewModel? { get }
    var error: String { get }
    var errorTitle: String { get }

    var itemPublisher: AnyPublisher<CharactersListItemViewModel?, Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
}

// MARK: - Combined ViewModel

protocol CharacterDetailsViewModel: CharacterDetailsViewModelInput, CharacterDetailsViewModelOutput { }

final class DefaultCharacterDetailsViewModel: CharacterDetailsViewModel {
    // MARK: - Properties

    @Published private(set) var item: CharactersListItemViewModel?
    @Published private(set) var error = ""

    private let fetchRMCharacterUseCase: FetchRMCharacterUseCase
    private let fetchRMEpisodesUseCase: FetchRMEpisodesUseCase
    private let posterImagesRepository: RMPosterImagesRepository
    private let actions: CharactersListViewModelActions?
    private let mainQueue: DispatchQueueType

    private var imageLoadTask: Cancellable? {
        willSet { imageLoadTask?.cancel() }
    }

    private var episodesLoadTask: Cancellable? {
        willSet { episodesLoadTask?.cancel() }
    }

    let errorTitle = StringHelper.errorTitle

    // MARK: - Initialization

    init(
        character: RMCharacter?,
        characterId: Int?,
        fetchRMCharacterUseCase: FetchRMCharacterUseCase,
        fetchRMEpisodesUseCase: FetchRMEpisodesUseCase,
        posterImagesRepository: RMPosterImagesRepository,
        actions: CharactersListViewModelActions,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.fetchRMCharacterUseCase = fetchRMCharacterUseCase
        self.fetchRMEpisodesUseCase = fetchRMEpisodesUseCase
        self.posterImagesRepository = posterImagesRepository
        self.actions = actions
        self.mainQueue = mainQueue

        // Initialize item with provided character or load character if characterId is provided
        if let character {
            item = CharactersListItemViewModel(character: character)
        } else if let characterId {
            load(characterId: characterId)
        }
    }

    // MARK: - Private Methods

    private func load(characterId: Int) {
//        loading = loading

        episodesLoadTask = fetchRMCharacterUseCase.execute(
            requestValue: characterId,
            cached: { [weak self] character in
                guard let self else { return }
                self.item = CharactersListItemViewModel(character: character)

                self.update()
            },
            completion: { [weak self] result in
                guard let self else { return }

                mainQueue.async {
                    switch result {
                    case let .success(character):
                        self.item = CharactersListItemViewModel(character: character)

                        self.update()
                    case let .failure(error):
                        self.handle(error: error)
                    }

//                    self.loading = .none
                }
            })
    }

    private func load(episodesIds: [Int]) {
        guard !episodesIds.isEmpty else { return }
//        loading = loading

        episodesLoadTask = fetchRMEpisodesUseCase.execute(
            requestValue: episodesIds,
            cached: { [weak self] episodes in
                guard let self else { return }
                self.item?.episodes = episodes.map(EpisodesListItemViewModel.init)
            },
            completion: { [weak self] result in
                guard let self else { return }

                mainQueue.async {
                    switch result {
                    case let .success(episodes):
                        self.item?.episodes = episodes.map(EpisodesListItemViewModel.init)
                    case let .failure(error):
                        self.handle(error: error)
                    }

//                    self.loading = .none
                }
            })
    }

    private func handle(error: Error) {
        self.error = error.isInternetConnectionError ?
            StringHelper.noInternetConnection :
            StringHelper.failedLoadingCharacters
    }

    private func getEpisodesIds() -> [Int] {
        var episodesIds: [Int] = []

        item?.episode.forEach {
            guard let url = URL(string: $0),
                  let id = Int(url.lastPathComponent) else { return }

            episodesIds.append(id)
        }

        return episodesIds
    }

    private func update() {
        load(episodesIds: getEpisodesIds())
    }
}

extension DefaultCharacterDetailsViewModel {
    var itemPublisher: AnyPublisher<CharactersListItemViewModel?, Never> {
        $item.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<String, Never> {
        $error.eraseToAnyPublisher()
    }

    func viewDidLoad() {
        update()
    }

    func didSelectItem(with characterId: Int?) {
        guard let characterId else { return }

        actions?.showCharacterDetails(nil, characterId)
    }

    func didToggleEpisode(at index: Int) {
        guard let episode = item?.episodes[safe: index] else { return }

        item?.episodes[index].isExpanded = !episode.isExpanded
    }
}
