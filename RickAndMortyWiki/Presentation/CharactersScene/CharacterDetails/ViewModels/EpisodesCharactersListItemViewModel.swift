//
//  EpisodesCharactersListItemViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 18.01.24.
//

import Foundation

struct EpisodesCharactersListItemViewModel: Equatable {
    let characterId: Int?
    let posterImagePath: String?
}

extension EpisodesCharactersListItemViewModel {
    init(string: String?) {
        guard let string,
              let url = URL(string: string) else {
            characterId = nil
            posterImagePath = nil

            return
        }

        let lastPathComponent = url.lastPathComponent

        characterId = Int(lastPathComponent)

        posterImagePath = "\(lastPathComponent).jpeg"
    }
}
