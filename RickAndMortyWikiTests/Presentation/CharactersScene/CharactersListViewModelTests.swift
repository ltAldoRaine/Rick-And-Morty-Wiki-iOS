//
//  CharactersListViewModelTests.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

import XCTest

class CharactersListViewModelTests: XCTestCase {
    private enum FilterCharactersUseCaseError: Error {
        case someError
    }

    let charactersPages: [RMCharactersPage] = {
        let page1 = RMCharactersPage(
            info: RMCharactersPageInfo(
                count: 2,
                pages: 2,
                next: "https://rickandmortyapi.com/api/character?page=2",
                prev: nil
            ), results: [
                .stub()
            ])

        let page2 = RMCharactersPage(
            info: RMCharactersPageInfo(
                count: 826,
                pages: 2,
                next: nil,
                prev: nil
            ), results: [
                .stub(
                    id: 21,
                    name: "Aqua Morty",
                    status: .unknown,
                    species: "Fish-Person",
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

    class FilterCharactersUseCaseMock: FilterRMCharactersUseCase {
        var executeCallCount: Int = 0

        typealias ExecuteBlock = (
            FilterRMCharactersUseCaseRequestValue,
            (RMCharactersPage) -> Void,
            (Result<RMCharactersPage, Error>) -> Void
        ) -> Void

        lazy var _execute: ExecuteBlock = { _, _, _ in
            XCTFail("not implemented")
        }

        func execute(
            requestValue: FilterRMCharactersUseCaseRequestValue,
            cached: @escaping (RMCharactersPage) -> Void,
            completion: @escaping (Result<RMCharactersPage, Error>) -> Void
        ) -> Cancellable? {
            executeCallCount += 1

            _execute(requestValue, cached, completion)

            return nil
        }
    }

    func test_whenFilterCharactersUseCaseRetrievesEmptyPage_thenViewModelIsEmpty() {
        // given
        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)

            completion(
                .success(
                    RMCharactersPage(
                        info: RMCharactersPageInfo(
                            count: 0,
                            pages: 0,
                            next: nil,
                            prev: nil
                        ),
                        results: []
                    )
                )
            )
        }

        let viewModel = DefaultCharactersListViewModel(
            filterCharactersUseCase: filterCharactersUseCaseMock,
            mainQueue: DispatchQueueTypeMock()
        )

        // when
        viewModel.freshLoad()

        // then
        XCTAssertEqual(viewModel.currentPage, 0)
        XCTAssertFalse(viewModel.hasMorePages)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenFilterCharactersUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)

            completion(.success(self.charactersPages[0]))
        }

        let viewModel = DefaultCharactersListViewModel.make(
            filterCharactersUseCase: filterCharactersUseCaseMock
        )

        // when
        viewModel.freshLoad()

        // then
        let expectedItems = charactersPages[0]
            .results
            .map { CharactersListItemViewModel(character: $0) }

        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenFilterCharactersUseCaseRetrievesFirstAndSecondPage_thenViewModelContainsTwoPages() {
        // given
        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)

            completion(.success(self.charactersPages[0]))
        }

        let viewModel = DefaultCharactersListViewModel.make(
            filterCharactersUseCase: filterCharactersUseCaseMock
        )

        // when
        viewModel.freshLoad()

        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 2)

            completion(.success(self.charactersPages[1]))
        }

        viewModel.didLoadNextPage()

        print("VASKA \(viewModel.currentPage)")
        print("VASKA \(viewModel.hasMorePages)")
        print("VASKA \(viewModel.totalPageCount)")

        // then
        let expectedItems = charactersPages
            .flatMap { $0.results }
            .map { CharactersListItemViewModel(character: $0) }

        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 2)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenFilterCharactersUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)

            completion(.failure(FilterCharactersUseCaseError.someError))
        }

        let viewModel = DefaultCharactersListViewModel.make(
            filterCharactersUseCase: filterCharactersUseCaseMock
        )

        // when
        viewModel.freshLoad()

        // then
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenLastPage_thenHasNoPageIsTrue() {
        // given
        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)

            completion(.success(self.charactersPages[0]))
        }

        let viewModel = DefaultCharactersListViewModel.make(
            filterCharactersUseCase: filterCharactersUseCaseMock
        )

        // when
        viewModel.freshLoad()

        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        filterCharactersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 2)

            completion(.success(self.charactersPages[1]))
        }

        viewModel.didLoadNextPage()

        // then
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 2)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenFilterCharactersUseCaseReturnsCachedData_thenViewModelShowsFirstCachedDataAndAfterFreshData() {
        // given
        let cachedPage: RMCharactersPage =
            RMCharactersPage(
                info: RMCharactersPageInfo(
                    count: 2,
                    pages: 2,
                    next: "https://rickandmortyapi.com/api/character?page=2",
                    prev: nil
                ),
                results: [.stub()]
            )

        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        let viewModel = DefaultCharactersListViewModel(
            filterCharactersUseCase: filterCharactersUseCaseMock,
            mainQueue: DispatchQueueTypeMock()
        )

        let testItemsBeforeFreshData = { [weak viewModel] in
            guard let viewModel else { return }

            let expectedItems = cachedPage
                .results
                .map { CharactersListItemViewModel(character: $0) }

            XCTAssertEqual(viewModel.items, expectedItems)
        }

        filterCharactersUseCaseMock._execute = { requestValue, cached, completion in
            XCTAssertEqual(requestValue.page, 1)

            cached(cachedPage)
            testItemsBeforeFreshData()
            completion(.success(self.charactersPages[0]))
        }

        // when
        viewModel.freshLoad()

        // then
        let expectedItems = charactersPages[0]
            .results
            .map { CharactersListItemViewModel(character: $0) }

        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }

    func test_whenFilterCharactersUseCaseReturnsError_thenViewModelShowsCachedData() {
        // given
        let cachedPage: RMCharactersPage = .init(
            info: RMCharactersPageInfo(
                count: 2,
                pages: 2,
                next: "https://rickandmortyapi.com/api/character?page=2",
                prev: nil
            ),
            results: [.stub()]
        )

        let filterCharactersUseCaseMock = FilterCharactersUseCaseMock()

        let viewModel = DefaultCharactersListViewModel(
            filterCharactersUseCase: filterCharactersUseCaseMock,
            mainQueue: DispatchQueueTypeMock()
        )

        filterCharactersUseCaseMock._execute = { requestValue, cached, completion in
            XCTAssertEqual(requestValue.page, 1)

            cached(cachedPage)
            completion(.failure(FilterCharactersUseCaseError.someError))
        }

        // when
        viewModel.freshLoad()

        // then
        let expectedItems = cachedPage
            .results
            .map { CharactersListItemViewModel(character: $0) }

        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertEqual(filterCharactersUseCaseMock.executeCallCount, 1)

        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
}

extension DefaultCharactersListViewModel {
    static func make(
        filterCharactersUseCase: FilterRMCharactersUseCase
    ) -> DefaultCharactersListViewModel {
        DefaultCharactersListViewModel(
            filterCharactersUseCase: filterCharactersUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
    }
}
