//
//  FetchRMEpisodeUseCaseTests.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

import XCTest

final class FetchRMEpisodeUseCaseTests: XCTestCase {
    static let episode: RMEpisode = {
        let episode =
            RMEpisode(
                id: 1,
                name: "Pilot",
                airDate: "December 2, 2013",
                episode: "S01E01",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                ],
                url: "https://rickandmortyapi.com/api/episode/1",
                created: "2017-11-10T12:56:33.798Z"
            )

        return episode
    }()

    enum EpisodesRepositorySuccessTestError: Error {
        case failedFetching
    }

    class EpisodesRepositoryMock: RMEpisodesRepository {
        var result: Result<RMEpisode, Error>
        var fetchCompletionCallsCount = 0

        init(result: Result<RMEpisode, Error>) {
            self.result = result
        }

        func fetchRMEpisodeById(
            id: Int,
            cached: @escaping (RMEpisode) -> Void,
            completion: @escaping (Result<RMEpisode, Error>) -> Void
        ) -> Cancellable? {
            completion(result)

            fetchCompletionCallsCount += 1

            return nil
        }
    }

    func testFetchEpisodeUseCase_whenSuccessfullyFetchesEpisode() {
        // given
        var useCaseCompletionCallsCount = 0

        let episodesRepository = EpisodesRepositoryMock(
            result: .success(FetchRMEpisodeUseCaseTests.episode)
        )
        let useCase = DefaultFetchRMEpisodeUseCase(
            rmEpisodesRepository: episodesRepository
        )

        // when
        let requestValue = 1

        _ = useCase.execute(
            requestValue: requestValue,
            cached: { _ in },
            completion: { _ in
                useCaseCompletionCallsCount += 1
            }
        )

        // then
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(episodesRepository.fetchCompletionCallsCount, 1)
    }

    func testFetchEpisodeUseCase_whenFailedFetchingEpisode() {
        // given
        var useCaseCompletionCallsCount = 0

        let episodesRepository = EpisodesRepositoryMock(
            result: .failure(EpisodesRepositorySuccessTestError.failedFetching)
        )
        let useCase = DefaultFetchRMEpisodeUseCase(
            rmEpisodesRepository: episodesRepository
        )

        // when
        let requestValue = 1

        _ = useCase.execute(
            requestValue: requestValue,
            cached: { _ in },
            completion: { _ in
                useCaseCompletionCallsCount += 1
            }
        )

        // then
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(episodesRepository.fetchCompletionCallsCount, 1)
    }
}
