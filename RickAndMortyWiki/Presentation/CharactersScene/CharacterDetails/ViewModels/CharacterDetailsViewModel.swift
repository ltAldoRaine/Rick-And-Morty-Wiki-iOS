//
//  CharacterDetailsViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

protocol CharacterDetailsViewModelInput {
    func updatePosterImage()
}

protocol CharacterDetailsViewModelOutput {}

protocol CharacterDetailsViewModel: CharacterDetailsViewModelInput, CharacterDetailsViewModelOutput { }

final class DefaultCharacterDetailsViewModel: CharacterDetailsViewModel {
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
    }
}

extension DefaultCharacterDetailsViewModel {
    func updatePosterImage() {
    }
}
