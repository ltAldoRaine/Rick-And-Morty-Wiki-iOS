//
//  RMCharactersPageResponseEntity+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

extension RMCharactersPageResponseEntity {
    func toDTO() -> RMCharactersPageResponseDTO? {
        guard let info,
              let results
        else { return nil }

        return .init(
            info: info.toDTO(),
            results: results.allObjects.compactMap { ($0 as? RMCharacterResponseEntity)?.toDTO() }
        )
    }
}

extension RMCharactersPageInfoResponseEntity {
    func toDTO() -> RMCharactersPageResponseDTO.RMCharactersPageInfoDTO {
        return .init(
            count: Int(count),
            pages: Int(pages),
            next: next,
            prev: prev
        )
    }
}

extension RMCharacterResponseEntity {
    func toDTO() -> RMCharactersPageResponseDTO.RMCharacterDTO? {
        guard let name,
              let status,
              let species,
              let type,
              let gender,
              let origin,
              let location,
              let image,
              let episode,
              let url,
              let created else { return nil }

        return .init(
            id: Int(character_id),
            name: name,
            status: RMCharactersPageResponseDTO.RMCharacterDTO.StatusDTO(rawValue: status) ?? .none,
            species: species,
            type: type,
            gender: RMCharactersPageResponseDTO.RMCharacterDTO.GenderDTO(rawValue: gender) ?? .none,
            origin: RMCharactersPageResponseDTO.RMCharacterDTO.RMCharacterOriginDto(name: origin, url: ""),
            location: RMCharactersPageResponseDTO.RMCharacterDTO.RMCharacterLocationDto(name: location, url: ""),
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}

extension RMCharactersPageRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharactersPageRequestEntity {
        let entity: RMCharactersPageRequestEntity = .init(context: context)

        entity.name = name
        entity.page = Int32(page)

        return entity
    }
}

extension RMCharactersPageResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharactersPageResponseEntity {
        let entity: RMCharactersPageResponseEntity = .init(context: context)

        entity.info = info.toEntity(in: context)

        results.forEach {
            entity.addToResults($0.toEntity(in: context))
        }

        return entity
    }
}

extension RMCharactersPageResponseDTO.RMCharactersPageInfoDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharactersPageInfoResponseEntity {
        let entity: RMCharactersPageInfoResponseEntity = .init(context: context)

        entity.count = Int32(count)
        entity.pages = Int32(pages)
        entity.next = next
        entity.prev = prev

        return entity
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO {
    func toEntity(in context: NSManagedObjectContext) -> RMCharacterResponseEntity {
        let entity: RMCharacterResponseEntity = .init(context: context)

        entity.character_id = Int64(id)
        entity.name = name
        entity.status = status.rawValue
        entity.species = species
        entity.type = type
        entity.gender = gender.rawValue
        entity.origin = origin.name
        entity.location = location.name
        entity.image = image
        entity.episode = episode
        entity.url = url
        entity.created = created

        return entity
    }
}
