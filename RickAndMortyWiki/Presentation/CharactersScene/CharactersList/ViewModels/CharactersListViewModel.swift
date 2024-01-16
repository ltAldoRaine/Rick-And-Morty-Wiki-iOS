//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import Foundation

struct CharactersListViewModelActions {
    let showCharacterDetails: (RMCharacter) -> Void
}

enum CharactersListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol CharactersListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didFilter(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol CharactersListViewModelOutput {
    var items: [CharactersListItemViewModel] { get }
    var loading: CharactersListViewModelLoading? { get }
    var query: String { get }
    var error: String { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataText: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }

    var itemsPublisher: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var loadingPublisher: AnyPublisher<CharactersListViewModelLoading?, Never> { get }
    var queryPublisher: AnyPublisher<String, Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
}

typealias CharactersListViewModel = CharactersListViewModelInput & CharactersListViewModelOutput

final class DefaultCharactersListViewModel: CharactersListViewModel {
    @Published var items: [CharactersListItemViewModel] = []
    @Published var loading: CharactersListViewModelLoading?
    @Published var query = ""
    @Published var error = ""

    private let filterCharactersUseCase: FilterRMCharactersUseCase
    private let mainQueue: DispatchQueueType
    private let actions: CharactersListViewModelActions?

    private var pages: [RMCharactersPage] = []
    private var charactersLoadTask: Cancellable? {
        willSet {
            charactersLoadTask?.cancel()
        }
    }

    let screenTitle = NSLocalizedString("Characters", comment: "")
    let emptyDataText = NSLocalizedString("No data available", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search", comment: "")

    var isEmpty: Bool { items.isEmpty }

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    init(
        filterCharactersUseCase: FilterRMCharactersUseCase,
        actions: CharactersListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.filterCharactersUseCase = filterCharactersUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    private func appendPage(_ charactersPage: RMCharactersPage) {
        if let nextPage = charactersPage.info.next?.urlQueryParamter("page"),
           let nextPageInt = Int(nextPage) {
            currentPage = nextPageInt - 1
        } else {
            currentPage = charactersPage.info.pages
        }

        totalPageCount = charactersPage.info.count

        pages = pages
            .filter({ $0.info.next != charactersPage.info.next })
            + [charactersPage]

        items = pages.characters.map(CharactersListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1

        pages.removeAll()
        items.removeAll()
    }

    private func load(charactersQuery: String, loading: CharactersListViewModelLoading) {
        self.loading = loading

        query = charactersQuery

        charactersLoadTask = filterCharactersUseCase.execute(
            requestValue: .init(query: charactersQuery, page: nextPage),
            cached: { [weak self] page in
                guard let self else { return }

                mainQueue.async {
                    self.appendPage(page)
                }
            },
            completion: { [weak self] result in
                guard let self else { return }

                mainQueue.async {
                    switch result {
                    case let .success(page):
                        self.appendPage(page)
                    case let .failure(error):
                        self.handle(error: error)
                    }

                    self.loading = .none
                }
            })
    }

    private func handle(error: Error) {
        self.error = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading characters", comment: "")
    }

    private func update(charactersQuery: String) {
        resetPages()

        load(charactersQuery: charactersQuery, loading: .fullScreen)
    }
}

extension DefaultCharactersListViewModel {
    var itemsPublisher: AnyPublisher<[CharactersListItemViewModel], Never> {
        $items.eraseToAnyPublisher()
    }

    var loadingPublisher: AnyPublisher<CharactersListViewModelLoading?, Never> {
        $loading.eraseToAnyPublisher()
    }

    var queryPublisher: AnyPublisher<String, Never> {
        $query.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<String, Never> {
        $error.eraseToAnyPublisher()
    }

    func viewDidLoad() {
        didFilter(query: query)
    }

    func didLoadNextPage() {
        guard hasMorePages,
              loading == .none else { return }

        load(charactersQuery: query, loading: .nextPage)
    }

    func didFilter(query: String) {
        update(charactersQuery: query)
    }

    func didCancelSearch() {
        charactersLoadTask?.cancel()
    }

    func didSelectItem(at index: Int) {
        actions?.showCharacterDetails(pages.characters[index])
    }
    
}

private extension Array where Element == RMCharactersPage {
    var characters: [RMCharacter] { flatMap { $0.results } }
}
