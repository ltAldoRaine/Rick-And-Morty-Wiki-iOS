//
//  RMEpisodeResponseEntity+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

extension RMEpisodeRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMEpisodeRequestEntity {
        let entity: RMEpisodeRequestEntity = .init(context: context)

        entity.episode_id = Int64(id)

        return entity
    }
}
