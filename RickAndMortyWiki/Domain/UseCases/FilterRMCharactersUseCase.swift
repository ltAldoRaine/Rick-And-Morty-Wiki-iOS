//
//  FilterRMCharactersUseCase.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

protocol FilterRMCharactersUseCase {
    func execute(
        requestValue: FilterRMCharactersUseCaseRequestValue,
        cached: @escaping (RMCharactersPage) -> Void,
        completion: @escaping (Result<RMCharactersPage, Error>) -> Void
    ) -> Cancellable?

    func execute(
        requestValue: [Int],
        cached: @escaping ([RMCharacter]) -> Void,
        completion: @escaping (Result<[RMCharacter], Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFilterRMCharactersUseCase: FilterRMCharactersUseCase {
    private let rmCharactersRepository: RMCharactersRepository

    init(
        rmCharactersRepository: RMCharactersRepository
    ) {
        self.rmCharactersRepository = rmCharactersRepository
    }

    func execute(
        requestValue: FilterRMCharactersUseCaseRequestValue,
        cached: @escaping (RMCharactersPage) -> Void,
        completion: @escaping (Result<RMCharactersPage, Error>) -> Void
    ) -> Cancellable? {
        return rmCharactersRepository.fetchRMCharacters(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached,
            completion: { result in
                completion(result)
            })
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

struct FilterRMCharactersUseCaseRequestValue {
    let query: String
    let page: Int
}
