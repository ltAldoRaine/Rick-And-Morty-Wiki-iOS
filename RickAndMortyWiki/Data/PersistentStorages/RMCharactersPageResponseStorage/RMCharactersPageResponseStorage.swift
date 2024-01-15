//
//  RMCharactersPageResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersPageResponseStorage {
    func getResponse(
        for request: RMCharactersPageRequestDTO,
        completion: @escaping (Result<RMCharactersPageResponseDTO?, Error>) -> Void
    )

    func save(response: RMCharactersPageResponseDTO, for requestDto: RMCharactersPageRequestDTO)
}
