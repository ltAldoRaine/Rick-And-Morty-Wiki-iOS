//
//  FetchRMEpisodeUseCase.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol FetchRMEpisodeUseCase {
    func execute(
        requestValue: Int,
        cached: @escaping (RMEpisode) -> Void,
        completion: @escaping (Result<RMEpisode, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchRMEpisodeUseCase: FetchRMEpisodeUseCase {
    private let rmEpisodesRepository: RMEpisodesRepository

    init(
        rmEpisodesRepository: RMEpisodesRepository
    ) {
        self.rmEpisodesRepository = rmEpisodesRepository
    }

    func execute(
        requestValue: Int,
        cached: @escaping (RMEpisode) -> Void,
        completion: @escaping (Result<RMEpisode, Error>) -> Void
    ) -> Cancellable? {
        return rmEpisodesRepository.fetchRMEpisodeById(
            id: requestValue,
            cached: cached,
            completion: { result in
                completion(result)
            })
    }
}
