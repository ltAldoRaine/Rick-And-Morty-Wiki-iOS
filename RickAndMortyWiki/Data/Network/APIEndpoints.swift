//
//  APIEndpoints.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

struct APIEndpoints {
    /// Returns the endpoint for fetching a single Rick and Morty character by ID.
    static func getSingleRMCharacter(
        with rmCharacterRequestDto: RMCharacterRequestDTO
    ) -> Endpoint<RMCharacterDTO> {
        Endpoint(
            path: "character/\(rmCharacterRequestDto.id)",
            method: .get
        )
    }

    /// Returns the endpoint for fetching a list of Rick and Morty characters by IDs.
    static func getRMCharactersList(
        with rmCharactersRequestDto: RMCharactersRequestDTO
    ) -> Endpoint<[RMCharacterDTO]> {
        Endpoint(
            path: "characters/\(rmCharactersRequestDto.ids.map { "\($0)" }.joined(separator: ","))",
            method: .get
        )
    }

    /// Returns the endpoint for fetching a list of Rick and Morty characters based on page and name.
    static func getRMCharacters(
        with rmCharactersPageRequestDTO: RMCharactersPageRequestDTO
    ) -> Endpoint<RMCharactersPageResponseDTO> {
        Endpoint(
            path: "character",
            method: .get,
            queryParametersEncodable: rmCharactersPageRequestDTO
        )
    }

    /// Returns the endpoint for fetching a single Rick and Morty episode by ID.
    static func getRMEpisode(
        with rmEpisodeRequestDto: RMEpisodeRequestDTO
    ) -> Endpoint<RMEpisodeDTO> {
        Endpoint(
            path: "episode/\(rmEpisodeRequestDto.id)",
            method: .get
        )
    }

    /// Returns the endpoint for fetching a list of Rick and Morty episodes by IDs.
    static func getRMEpisodes(
        with rmEpisodesRequestDto: RMEpisodesRequestDTO
    ) -> Endpoint<[RMEpisodeDTO]> {
        Endpoint(
            path: "episode/\(rmEpisodesRequestDto.ids.map { "\($0)" }.joined(separator: ","))",
            method: .get
        )
    }

    /// Returns the endpoint for fetching the poster image of a Rick and Morty character.
    static func getRMCharacterPoster(
        path: String
    ) -> Endpoint<Data> {
        Endpoint(
            path: path,
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
