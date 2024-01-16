//
//  RMCharactersPageResponseDTO+Mapping.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

// MARK: - Data Transfer Object

struct RMCharactersPageResponseDTO: Decodable {
    let info: RMCharactersPageInfoDTO
    let results: [RMCharacterDTO]
}

extension RMCharactersPageResponseDTO {
    struct RMCharactersPageInfoDTO: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct RMCharacterDTO: Decodable {
        enum StatusDTO: String, Decodable {
            case alive
            case dead
            case unknown
            case none = ""

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawString = try container.decode(String.self)

                if let statusDTO = StatusDTO(rawValue: rawString.lowercased()) {
                    self = statusDTO
                } else {
                    self = .none
                }
            }
        }

        enum GenderDTO: String, Decodable {
            case female
            case male
            case genderless
            case unknown
            case none = ""

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawString = try container.decode(String.self)

                if let genderDTO = GenderDTO(rawValue: rawString.lowercased()) {
                    self = genderDTO
                } else {
                    self = .none
                }
            }
        }

        struct RMCharacterOriginDto: Decodable {
            let name: String
            let url: String
        }

        struct RMCharacterLocationDto: Decodable {
            let name: String
            let url: String
        }

        let id: Int
        let name: String
        let status: StatusDTO
        let species: String
        let type: String
        let gender: GenderDTO
        let origin: RMCharacterOriginDto
        let location: RMCharacterLocationDto
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }
}

// MARK: - Mappings to Domain

extension RMCharactersPageResponseDTO {
    func toDomain() -> RMCharactersPage {
        return .init(
            info: info.toDomain(),
            results: results.map { $0.toDomain() }
        )
    }
}

extension RMCharactersPageResponseDTO.RMCharactersPageInfoDTO {
    func toDomain() -> RMCharactersPageInfo {
        return .init(
            count: count,
            pages: pages,
            next: next,
            prev: prev
        )
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO {
    func toDomain() -> RMCharacter {
        return .init(
            id: RMCharacter.Identifier(id),
            name: name,
            status: status.toDomain(),
            species: species,
            type: type,
            gender: gender.toDomain(),
            origin: origin.toDomain(),
            location: location.toDomain(),
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}

extension [RMCharactersPageResponseDTO.RMCharacterDTO] {
    func toDomain() -> [RMCharacter] {
        return map { $0.toDomain() }
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO.StatusDTO {
    func toDomain() -> RMCharacter.Status {
        switch self {
        case .alive: return .alive
        case .dead: return .dead
        case .unknown: return .unknown
        case .none: return .none
        }
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO.GenderDTO {
    func toDomain() -> RMCharacter.Gender {
        switch self {
        case .female: return .female
        case .male: return .male
        case .genderless: return .genderless
        case .unknown: return .unknown
        case .none: return .none
        }
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO.RMCharacterOriginDto {
    func toDomain() -> RMCharacterOrigin {
        return .init(
            name: name,
            url: url
        )
    }
}

extension RMCharactersPageResponseDTO.RMCharacterDTO.RMCharacterLocationDto {
    func toDomain() -> RMCharacterLocation {
        return .init(
            name: name,
            url: url
        )
    }
}
