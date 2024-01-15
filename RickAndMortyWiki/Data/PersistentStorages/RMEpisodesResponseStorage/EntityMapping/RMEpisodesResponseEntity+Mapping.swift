//
//  RMEpisodesResponseEntity+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

extension RMEpisodesResponseEntity {
    func toDTO() -> [RMEpisodeDTO]? {
        guard let results else { return nil }

        return results.allObjects.compactMap { ($0 as? RMEpisodeResponseEntity)?.toDTO() }
    }
}

extension RMEpisodeResponseEntity {
    func toDTO() -> RMEpisodeDTO? {
        guard let name,
              let airDate,
              let episode,
              let characters,
              let url,
              let created else { return nil }

        return .init(
            id: Int(episode_id),
            name: name,
            airDate: airDate,
            episode: episode,
            characters: characters,
            url: url,
            created: created
        )
    }
}

extension RMEpisodesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMEpisodesRequestEntity {
        let entity: RMEpisodesRequestEntity = .init(context: context)

        entity.episodes_ids = ids.map { "\($0)" }.joined(separator: ",")

        return entity
    }
}

extension [RMEpisodeDTO] {
    func toEntity(in context: NSManagedObjectContext) -> RMEpisodesResponseEntity {
        let entity: RMEpisodesResponseEntity = .init(context: context)

        forEach {
            entity.addToResults($0.toEntity(in: context))
        }

        return entity
    }
}

extension RMEpisodeDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMEpisodeResponseEntity {
        let entity: RMEpisodeResponseEntity = .init(context: context)

        entity.episode_id = Int64(id)
        entity.name = name
        entity.airDate = airDate
        entity.episode = episode
        entity.characters = characters
        entity.url = url
        entity.created = created

        return entity
    }
}
