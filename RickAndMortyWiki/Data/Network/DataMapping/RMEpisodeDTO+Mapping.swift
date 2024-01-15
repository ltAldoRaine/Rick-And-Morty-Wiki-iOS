//
//  RMEpisodeDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

// MARK: - Data Transfer Object

struct RMEpisodeDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }

    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

// MARK: - Mappings to Domain

extension [RMEpisodeDTO] {
    func toDomain() -> [RMEpisode] {
        return map { $0.toDomain() }
    }
}

extension RMEpisodeDTO {
    func toDomain() -> RMEpisode {
        return .init(
            id: RMEpisode.Identifier(id),
            name: name,
            airDate: airDate,
            episode: episode,
            characters: characters,
            url: url,
            created: created
        )
    }
}
