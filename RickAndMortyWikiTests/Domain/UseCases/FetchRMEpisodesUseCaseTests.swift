//
//  FetchRMEpisodesUseCaseTests.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

import XCTest

final class FetchRMEpisodesUseCaseTests: XCTestCase {
    static let episodes: [RMEpisode] = {
        let episode1 =
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

        let episode2 =
            RMEpisode(
                id: 2,
                name: "Lawnmower Dog",
                airDate: "December 9, 2013",
                episode: "S01E02",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                ],
                url: "https://rickandmortyapi.com/api/episode/2",
                created: "2017-11-10T12:56:33.916Z"
            )

        return [episode1, episode2]
    }()

    enum EpisodesRepositorySuccessTestError: Error {
        case failedFetching
    }

    class EpisodesRepositoryMock: RMEpisodesRepository {
        var result: Result<[RMEpisode], Error>
        var fetchCompletionCallsCount = 0

        init(result: Result<[RMEpisode], Error>) {
            self.result = result
        }

        func fetchRMEpisodesByIds(
            ids: [Int],
            cached: @escaping ([RMEpisode]) -> Void,
            completion: @escaping (Result<[RMEpisode], Error>) -> Void
        ) -> Cancellable? {
            completion(result)

            fetchCompletionCallsCount += 1

            return nil
        }
    }

    func testFetchEpisodesUseCase_whenSuccessfullyFetchesEpisodes() {
        // given
        var useCaseCompletionCallsCount = 0

        let episodesRepository = EpisodesRepositoryMock(
            result: .success(FetchRMEpisodesUseCaseTests.episodes)
        )
        let useCase = DefaultFetchRMEpisodesUseCase(
            rmEpisodesRepository: episodesRepository
        )

        // when
        let requestValue = [1, 2]

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

    func testFetchEpisodesUseCase_whenFailedFetchingEpisodes() {
        // given
        var useCaseCompletionCallsCount = 0

        let episodesRepository = EpisodesRepositoryMock(
            result: .failure(EpisodesRepositorySuccessTestError.failedFetching)
        )
        let useCase = DefaultFetchRMEpisodesUseCase(
            rmEpisodesRepository: episodesRepository
        )

        // when
        let requestValue = [1, 2]

        _ = useCase.execute(
            requestValue: requestValue,
            cached: { _ in }
        ) { _ in
            useCaseCompletionCallsCount += 1
        }

        // then
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(episodesRepository.fetchCompletionCallsCount, 1)
    }
}
