//
//  FetchRMCharacterUseCase.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

protocol FetchRMCharacterUseCase {
    func execute(
        requestValue: Int,
        cached: @escaping (RMCharacter) -> Void,
        completion: @escaping (Result<RMCharacter, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchRMCharacterUseCase: FetchRMCharacterUseCase {
    private let rmCharactersRepository: RMCharactersRepository

    init(
        rmCharactersRepository: RMCharactersRepository
    ) {
        self.rmCharactersRepository = rmCharactersRepository
    }

    func execute(
        requestValue: Int,
        cached: @escaping (RMCharacter) -> Void,
        completion: @escaping (Result<RMCharacter, Error>) -> Void
    ) -> Cancellable? {
        return rmCharactersRepository.fetchRMCharacterById(
            id: requestValue,
            cached: cached,
            completion: { result in
                completion(result)
            })
    }
}
