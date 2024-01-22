//
//  FilterRMCharactersUseCaseTests.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 18.01.24.
//

import XCTest

final class FilterRMCharactersUseCaseTests: XCTestCase {
    static let charactersPages: [RMCharactersPage] = {
        let page1 = RMCharactersPage(
            info: RMCharactersPageInfo(
                count: 826,
                pages: 42,
                next: "https://rickandmortyapi.com/api/character/?page=2",
                prev: nil
            ), results: [
                RMCharacter(
                    id: 1,
                    name: "Rick Sanchez",
                    status: .alive,
                    species: "Human",
                    type: "",
                    gender: .male,
                    origin: RMCharacterOrigin(
                        name: "Earth (C-137)",
                        url: "https://rickandmortyapi.com/api/location/1"
                    ),
                    location: RMCharacterLocation(
                        name: "Citadel of Ricks",
                        url: "https://rickandmortyapi.com/api/location/3"
                    ),
                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    episode: [
                        "https://rickandmortyapi.com/api/episode/1",
                        "https://rickandmortyapi.com/api/episode/2"
                    ],
                    url: "https://rickandmortyapi.com/api/character/1",
                    created: "2017-11-04T18:48:46.250Z"
                )
            ])

        let page2 = RMCharactersPage(
            info: RMCharactersPageInfo(
                count: 826,
                pages: 42,
                next: "https://rickandmortyapi.com/api/character?page=3",
                prev: nil
            ), results: [
                RMCharacter(
                    id: 21,
                    name: "Aqua Morty",
                    status: .unknown,
                    species: "Humanoid",
                    type: "Fish-Person",
                    gender: .male,
                    origin: RMCharacterOrigin(
                        name: "uknown",
                        url: ""
                    ),
                    location: RMCharacterLocation(
                        name: "Citadel of Ricks",
                        url: "https://rickandmortyapi.com/api/location/3"
                    ),
                    image: "https://rickandmortyapi.com/api/character/avatar/21.jpeg",
                    episode: [
                        "https://rickandmortyapi.com/api/episode/10",
                        "https://rickandmortyapi.com/api/episode/22"
                    ],
                    url: "https://rickandmortyapi.com/api/character/21",
                    created: "2017-11-04T18:48:46.250Z"
                )
            ])

        return [page1, page2]
    }()

    enum CharactersRepositorySuccessTestError: Error {
        case failedFetching
    }

    class CharactersRepositoryMock: RMCharactersRepository {
        var result: Result<RMCharactersPage, Error>
        var fetchCompletionCallsCount = 0

        init(result: Result<RMCharactersPage, Error>) {
            self.result = result
        }

        func fetchRMCharacters(
            name: String,
            page: Int,
            cached: @escaping (RMCharactersPage) -> Void,
            completion: @escaping (Result<RMCharactersPage, Error>) -> Void) -> Cancellable? {
            completion(result)

            fetchCompletionCallsCount += 1

            return nil
        }
    }

    func testFilterCharactersUseCase_whenSuccessfullyFetchesCharactersForName() {
        // given
        var useCaseCompletionCallsCount = 0

        let charactersRepository = CharactersRepositoryMock(
            result: .success(FilterRMCharactersUseCaseTests.charactersPages[0])
        )
        let useCase = DefaultFilterRMCharactersUseCase(
            rmCharactersRepository: charactersRepository
        )

        // when
        let requestValue = FilterRMCharactersUseCaseRequestValue(
            name: "",
            page: 0
        )

        _ = useCase.execute(
            requestValue: requestValue,
            cached: { _ in }
        ) { _ in
            useCaseCompletionCallsCount += 1
        }

        // then
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(charactersRepository.fetchCompletionCallsCount, 1)
    }

    func testFilterCharactersUseCase_whenFailedFetchingCharactersForName() {
        // given
        var useCaseCompletionCallsCount = 0

        let charactersRepository = CharactersRepositoryMock(
            result: .failure(CharactersRepositorySuccessTestError.failedFetching)
        )
        let useCase = DefaultFilterRMCharactersUseCase(
            rmCharactersRepository: charactersRepository
        )

        // when
        let requestValue = FilterRMCharactersUseCaseRequestValue(
            name: "",
            page: 0
        )

        _ = useCase.execute(
            requestValue: requestValue,
            cached: { _ in }
        ) { _ in
            useCaseCompletionCallsCount += 1
        }

        // then
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(charactersRepository.fetchCompletionCallsCount, 1)
    }
}
