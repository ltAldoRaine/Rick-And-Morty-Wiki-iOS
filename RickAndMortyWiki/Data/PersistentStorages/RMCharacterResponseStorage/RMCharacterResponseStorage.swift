//
//  RMCharacterResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharacterResponseStorage {
    typealias ResultType = Result<RMCharacterDTO?, Error>

    func getResponse(
        for request: RMCharacterRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: RMCharacterDTO, for requestDto: RMCharacterRequestDTO)
}
