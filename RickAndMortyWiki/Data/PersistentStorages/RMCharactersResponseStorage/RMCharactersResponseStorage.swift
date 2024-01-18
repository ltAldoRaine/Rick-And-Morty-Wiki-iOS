//
//  RMCharactersResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersResponseStorage {
    typealias ResultType = Result<[RMCharactersPageResponseDTO.RMCharacterDTO]?, Error>

    func getResponse(
        for request: RMCharactersRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: [RMCharactersPageResponseDTO.RMCharacterDTO], for requestDto: RMCharactersRequestDTO)
}
