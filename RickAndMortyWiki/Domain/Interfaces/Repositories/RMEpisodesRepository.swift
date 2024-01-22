//
//  RMEpisodesRepository.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMEpisodesRepository {
    @discardableResult
    func fetchRMEpisodeById(
        id: Int,
        cached: @escaping (RMEpisode) -> Void,
        completion: @escaping (Result<RMEpisode, Error>) -> Void
    ) -> Cancellable?

    @discardableResult
    func fetchRMEpisodesByIds(
        ids: [Int],
        cached: @escaping ([RMEpisode]) -> Void,
        completion: @escaping (Result<[RMEpisode], Error>) -> Void
    ) -> Cancellable?
}

extension RMEpisodesRepository {
    @discardableResult
    func fetchRMEpisodeById(
        id: Int,
        cached: @escaping (RMEpisode) -> Void,
        completion: @escaping (Result<RMEpisode, Error>) -> Void
    ) -> Cancellable? { return nil }

    @discardableResult
    func fetchRMEpisodesByIds(
        ids: [Int],
        cached: @escaping ([RMEpisode]) -> Void,
        completion: @escaping (Result<[RMEpisode], Error>) -> Void
    ) -> Cancellable? { return nil }
}
