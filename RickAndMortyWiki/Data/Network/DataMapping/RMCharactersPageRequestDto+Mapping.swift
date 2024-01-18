//
//  RMCharactersPageRequestDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

/// Data Transfer Object (DTO) representing the request for fetching a page of Rick and Morty characters.
struct RMCharactersPageRequestDTO: Encodable {
    /// The name filter for characters.
    let name: String

    /// The page number to retrieve.
    let page: Int
}
