//
//  RMCharactersRequestDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

/// Data Transfer Object (DTO) representing the request for fetching Rick and Morty characters.
struct RMCharactersRequestDTO: Encodable {
    /// Array of character identifiers.
    let ids: [Int]
}
