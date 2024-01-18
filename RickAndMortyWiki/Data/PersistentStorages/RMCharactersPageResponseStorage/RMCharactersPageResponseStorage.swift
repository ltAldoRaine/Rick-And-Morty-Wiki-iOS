//
//  RMCharactersPageResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersPageResponseStorage {
    typealias ResultType = Result<RMCharactersPageResponseDTO?, Error>

    func getResponse(
        for request: RMCharactersPageRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: RMCharactersPageResponseDTO, for requestDto: RMCharactersPageRequestDTO)
}
