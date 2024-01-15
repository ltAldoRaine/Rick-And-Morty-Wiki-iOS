//
//  RMCharacterResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharacterResponseStorage {
    func getResponse(
        for request: RMCharacterRequestDTO,
        completion: @escaping (Result<RMCharactersPageResponseDTO.RMCharacterDTO?, Error>) -> Void
    )

    func save(response: RMCharactersPageResponseDTO.RMCharacterDTO, for requestDto: RMCharacterRequestDTO)
}
