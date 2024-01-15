//
//  RMCharacter.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 13.01.24.
//

import Foundation

struct RMCharacter: Equatable, Identifiable {
    typealias Identifier = Int

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

    let id: Identifier
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: RMCharacterOrigin
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct RMCharactersPageInfo: Equatable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct RMCharactersPage: Equatable {
    let info: RMCharactersPageInfo
    let results: [RMCharacter]
}
