//
//  DefaultRMEpisodesRepository.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

final class DefaultRMEpisodesRepository {
    private let dataTransferService: DataTransferService
    private let rmEpisodesResponseCache: RMEpisodesResponseStorage
    private let rmEpisodeResponseCache: RMEpisodeResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        rmEpisodesResponseCache: RMEpisodesResponseStorage,
        rmEpisodeResponseCache: RMEpisodeResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.rmEpisodesResponseCache = rmEpisodesResponseCache
        self.rmEpisodeResponseCache = rmEpisodeResponseCache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultRMEpisodesRepository: RMEpisodesRepository {
    func fetchRMEpisodeById(
        id: Int,
        cached: @escaping (RMEpisode) -> Void,
        completion: @escaping (Result<RMEpisode, Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = RMEpisodeRequestDTO(id: id)
        let task = RepositoryTask()

        rmEpisodeResponseCache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }

            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getRMEpisode(with: requestDTO)

            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case let .success(responseDTO):
                    self?.rmEpisodeResponseCache.save(response: responseDTO, for: requestDTO)

                    completion(.success(responseDTO.toDomain()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }

    func fetchRMEpisodesByIds(
        ids: [Int],
        cached: @escaping ([RMEpisode]) -> Void,
        completion: @escaping (Result<[RMEpisode], Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = RMEpisodesRequestDTO(ids: ids)
        let task = RepositoryTask()

        rmEpisodesResponseCache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }

            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getRMEpisodes(with: requestDTO)

            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case let .success(responseDTO):
                    self?.rmEpisodesResponseCache.save(response: responseDTO, for: requestDTO)

                    completion(.success(responseDTO.toDomain()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }
}
