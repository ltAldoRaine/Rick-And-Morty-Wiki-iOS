//
//  CharactersListItemViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

struct CharactersListItemViewModel: Equatable {
    enum Status: String {
        case alive
        case dead
        case unknown
        case none = ""
    }

    let name: String
    let origin: String
    let status: Status
    let species: String
    let posterImagePath: String
}

extension CharactersListItemViewModel {
    init(character: RMCharacter) {
        name = character.name
        origin = character.origin.name
        status = Status(rawValue: character.status.rawValue) ?? .none
        species = character.species
        posterImagePath = character.image
    }
}
