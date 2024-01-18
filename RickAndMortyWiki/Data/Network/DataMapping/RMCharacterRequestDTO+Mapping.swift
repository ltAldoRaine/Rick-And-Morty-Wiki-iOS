//
//  RMCharacterRequestDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

/// Data Transfer Object (DTO) representing the request for fetching a single Rick and Morty character by ID.
struct RMCharacterRequestDTO {
    /// The ID of the Rick and Morty character.
    let id: Int
}
