//
//  FilterRMCharactersUseCase.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

protocol FilterRMCharactersUseCase {
    typealias ResultType = (
        FilterRMCharactersUseCaseRequestValue,
        (RMCharactersPage) -> Void,
        (Result<RMCharactersPage, Error>) -> Void
    ) -> Void

    func execute(
        requestValue: FilterRMCharactersUseCaseRequestValue,
        cached: @escaping (RMCharactersPage) -> Void,
        completion: @escaping (Result<RMCharactersPage, Error>) -> Void
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
            name: requestValue.name,
            page: requestValue.page,
            cached: cached,
            completion: { result in
                completion(result)
            })
    }
}

struct FilterRMCharactersUseCaseRequestValue {
    let name: String
    let page: Int
}
