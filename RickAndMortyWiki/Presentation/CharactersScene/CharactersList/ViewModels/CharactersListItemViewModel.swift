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

    enum Gender: String {
        case female
        case male
        case genderless
        case unknown
        case none = ""
    }

    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let origin: String
    let location: String
    let posterImagePath: String
    let episode: [String]
}

extension CharactersListItemViewModel {
    init(character: RMCharacter) {
        name = character.name
        status = Status(rawValue: character.status.rawValue) ?? .none
        species = character.species
        gender = Gender(rawValue: character.gender.rawValue) ?? .none
        origin = character.origin.name
        location = character.location.name
        posterImagePath = character.image
        episode = character.episode
    }
}
