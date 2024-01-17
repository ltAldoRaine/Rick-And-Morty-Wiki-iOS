//
//  DefaultRMCharactersRepository.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

final class DefaultRMCharactersRepository {
    private let dataTransferService: DataTransferService
    private let rmCharacterResponseCache: RMCharacterResponseStorage
    private let rmCharactersResponseCache: RMCharactersResponseStorage
    private let rmCharactersPageResponseCache: RMCharactersPageResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        rmCharacterResponseCache: RMCharacterResponseStorage,
        rmCharactersResponseCache: RMCharactersResponseStorage,
        rmCharactersPageResponseCache: RMCharactersPageResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.rmCharacterResponseCache = rmCharacterResponseCache
        self.rmCharactersResponseCache = rmCharactersResponseCache
        self.rmCharactersPageResponseCache = rmCharactersPageResponseCache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultRMCharactersRepository: RMCharactersRepository {
    func fetchRMCharacterById(
        id: Int,
        cached: @escaping (RMCharacter) -> Void,
        completion: @escaping (Result<RMCharacter, Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = RMCharacterRequestDTO(id: id)
        let task = RepositoryTask()

        rmCharacterResponseCache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }

            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getRMCharacter(with: requestDTO)

            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case let .success(responseDTO):
                    self?.rmCharacterResponseCache.save(response: responseDTO, for: requestDTO)

                    completion(.success(responseDTO.toDomain()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }

    func fetchRMCharactersByIds(
        ids: [Int],
        cached: @escaping ([RMCharacter]) -> Void,
        completion: @escaping (Result<[RMCharacter], Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = RMCharactersRequestDTO(ids: ids)
        let task = RepositoryTask()

        rmCharactersResponseCache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }

            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getRMCharacters(with: requestDTO)

            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case let .success(responseDTO):
                    self?.rmCharactersResponseCache.save(response: responseDTO, for: requestDTO)

                    completion(.success(responseDTO.toDomain()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }

    func fetchRMCharacters(
        name: String,
        page: Int,
        cached: @escaping (RMCharactersPage) -> Void,
        completion: @escaping (Result<RMCharactersPage, Error>
        ) -> Void) -> Cancellable? {
        let requestDTO = RMCharactersPageRequestDTO(name: name, page: page)
        let task = RepositoryTask()

        rmCharactersPageResponseCache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }

            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getRMCharacters(with: requestDTO)

            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case let .success(responseDTO):
                    self?.rmCharactersPageResponseCache.save(response: responseDTO, for: requestDTO)

                    completion(.success(responseDTO.toDomain()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }
}
