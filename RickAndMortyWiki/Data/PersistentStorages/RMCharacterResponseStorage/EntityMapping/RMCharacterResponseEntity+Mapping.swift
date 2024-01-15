//
//  RMCharacterResponseEntity+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

extension RMCharacterRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharacterRequestEntity {
        let entity: RMCharacterRequestEntity = .init(context: context)

        entity.character_id = Int64(id)

        return entity
    }
}
