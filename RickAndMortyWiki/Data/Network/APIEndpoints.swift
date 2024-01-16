//
//  APIEndpoints.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

struct APIEndpoints {
    static func getRMCharacter(with rmCharacterRequestDto: RMCharacterRequestDTO) -> Endpoint<RMCharactersPageResponseDTO.RMCharacterDTO> {
        return Endpoint(
            path: "characters/\(rmCharacterRequestDto.id)",
            method: .get
        )
    }

    static func getRMCharacters(with rmCharactersRequestDto: RMCharactersRequestDTO) -> Endpoint<[RMCharactersPageResponseDTO.RMCharacterDTO]> {
        return Endpoint(
            path: "characters/\(rmCharactersRequestDto.ids.map { "\($0)" }.joined(separator: ","))",
            method: .get
        )
    }

    static func getRMCharacters(with rmCharactersPageRequestDTO: RMCharactersPageRequestDTO) -> Endpoint<RMCharactersPageResponseDTO> {
        return Endpoint(
            path: "character",
            method: .get,
            queryParametersEncodable: rmCharactersPageRequestDTO
        )
    }

    static func getRMEpisode(with rmEpisodeRequestDto: RMEpisodeRequestDTO) -> Endpoint<RMEpisodeDTO> {
        return Endpoint(
            path: "episode/\(rmEpisodeRequestDto.id)",
            method: .get
        )
    }

    static func getRMEpisodes(with rmEpisodesRequestDto: RMEpisodesRequestDTO) -> Endpoint<[RMEpisodeDTO]> {
        return Endpoint(
            path: "episode/\(rmEpisodesRequestDto.ids.map { "\($0)" }.joined(separator: ","))",
            method: .get
        )
    }

    static func getRMCharacterPoster(path: String) -> Endpoint<Data> {
        return Endpoint(
            path: path,
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
