//
//  RMCharactersResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersResponseStorage {
    typealias ResultType = Result<[RMCharacterDTO]?, Error>

    func getResponse(
        for request: RMCharactersRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: [RMCharacterDTO], for requestDto: RMCharactersRequestDTO)
}
