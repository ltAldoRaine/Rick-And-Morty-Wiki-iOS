//
//  RMCharactersResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersResponseStorage {
    func getResponse(
        for request: RMCharactersRequestDTO,
        completion: @escaping (Result<[RMCharactersPageResponseDTO.RMCharacterDTO]?, Error>) -> Void
    )

    func save(response: [RMCharactersPageResponseDTO.RMCharacterDTO], for requestDto: RMCharactersRequestDTO)
}
