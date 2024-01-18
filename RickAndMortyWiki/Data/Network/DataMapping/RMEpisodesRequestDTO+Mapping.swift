//
//  RMEpisodesRequestDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

/// Data Transfer Object (DTO) representing the request for fetching Rick and Morty episodes.
struct RMEpisodesRequestDTO {
    /// Array of episode identifiers.
    let ids: [Int]
}
