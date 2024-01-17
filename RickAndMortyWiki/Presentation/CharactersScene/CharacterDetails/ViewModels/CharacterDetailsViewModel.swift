//
//  CharacterDetailsViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import Foundation

protocol CharacterDetailsViewModelInput {
    func viewDidLoad()
}

protocol CharacterDetailsViewModelOutput {
    var item: CharactersListItemViewModel? { get }

    var itemPublisher: AnyPublisher<CharactersListItemViewModel?, Never> { get }
}

protocol CharacterDetailsViewModel: CharacterDetailsViewModelInput, CharacterDetailsViewModelOutput { }

final class DefaultCharacterDetailsViewModel: CharacterDetailsViewModel {
    @Published var item: CharactersListItemViewModel?

    private let posterImagePath: String? = nil
    private let posterImagesRepository: RMPosterImagesRepository
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }

    private let mainQueue: DispatchQueueType

    init(
        character: RMCharacter,
        posterImagesRepository: RMPosterImagesRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.posterImagesRepository = posterImagesRepository
        self.mainQueue = mainQueue

        item = CharactersListItemViewModel(character: character)
    }
}

extension DefaultCharacterDetailsViewModel {
    var itemPublisher: AnyPublisher<CharactersListItemViewModel?, Never> {
        $item.eraseToAnyPublisher()
    }

    func viewDidLoad() {
    }
}
