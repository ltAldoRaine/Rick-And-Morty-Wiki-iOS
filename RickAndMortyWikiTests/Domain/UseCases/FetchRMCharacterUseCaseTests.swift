//
//  FetchRMCharacterUseCaseTests.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

import XCTest

final class FetchRMCharacterUseCaseTests: XCTestCase {
    static let character: RMCharacter = {
        let character =
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

        return character
    }()

    enum CharactersRepositorySuccessTestError: Error {
        case failedFetching
    }

    class CharactersRepositoryMock: RMCharactersRepository {
        var result: Result<RMCharacter, Error>
        var fetchCompletionCallsCount = 0

        init(result: Result<RMCharacter, Error>) {
            self.result = result
        }

        func fetchRMCharacterById(
            id: Int,
            cached: @escaping (RMCharacter) -> Void,
            completion: @escaping (Result<RMCharacter, Error>) -> Void
        ) -> Cancellable? {
            completion(result)

            fetchCompletionCallsCount += 1

            return nil
        }
    }

    func testFetchCharacterUseCase_whenSuccessfullyFetchesCharacter() {
        // given
        var useCaseCompletionCallsCount = 0

        let charactersRepository = CharactersRepositoryMock(
            result: .success(FetchRMCharacterUseCaseTests.character)
        )
        let useCase = DefaultFetchRMCharacterUseCase(
            rmCharactersRepository: charactersRepository
        )

        // when
        let requestValue = 1

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

    func testFetchCharacterUseCase_whenFailedFetchingCharacter() {
        // given
        var useCaseCompletionCallsCount = 0

        let charactersRepository = CharactersRepositoryMock(
            result: .failure(CharactersRepositorySuccessTestError.failedFetching)
        )
        let useCase = DefaultFetchRMCharacterUseCase(
            rmCharactersRepository: charactersRepository
        )

        // when
        let requestValue = 1

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
