//
//  RMCharactersPageRequestDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

struct RMCharactersPageRequestDTO: Encodable {
    let query: String
    let page: Int
}
