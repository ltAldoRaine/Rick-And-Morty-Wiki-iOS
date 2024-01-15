//
//  FetchRMCharactersUseCase.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

protocol FetchRMCharactersUseCase {
    func execute(
        requestValue: [Int],
        cached: @escaping ([RMCharacter]) -> Void,
        completion: @escaping (Result<[RMCharacter], Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchRMCharactersUseCase: FetchRMCharactersUseCase {
    private let rmCharactersRepository: RMCharactersRepository

    init(
        rmCharactersRepository: RMCharactersRepository
    ) {
        self.rmCharactersRepository = rmCharactersRepository
    }

    func execute(
        requestValue: [Int],
        cached: @escaping ([RMCharacter]) -> Void,
        completion: @escaping (Result<[RMCharacter], Error>) -> Void
    ) -> Cancellable? {
        return rmCharactersRepository.fetchRMCharactersByIds(
            ids: requestValue,
            cached: cached,
            completion: { result in
                completion(result)
            })
    }
}
