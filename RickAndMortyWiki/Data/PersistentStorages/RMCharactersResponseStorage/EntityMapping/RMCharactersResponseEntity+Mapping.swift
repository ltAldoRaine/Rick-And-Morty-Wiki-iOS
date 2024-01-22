//
//  RMCharactersResponseEntity+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

extension RMCharactersResponseEntity {
    func toDTO() -> [RMCharacterDTO]? {
        guard let results else { return nil }

        return results.allObjects.compactMap { ($0 as? RMCharacterResponseEntity)?.toDTO() }
    }
}

extension RMCharactersRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharactersRequestEntity {
        let entity: RMCharactersRequestEntity = .init(context: context)

        entity.characters_ids = ids.map { "\($0)" }.joined(separator: ",")

        return entity
    }
}

extension [RMCharacterDTO] {
    func toEntity(in context: NSManagedObjectContext) -> RMCharactersResponseEntity {
        let entity: RMCharactersResponseEntity = .init(context: context)

        forEach {
            entity.addToResults($0.toEntity(in: context))
        }

        return entity
    }
}
