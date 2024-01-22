//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import Foundation

struct CharactersListViewModelActions {
    let showCharacterDetails: (RMCharacter?, Int?) -> Void
}

enum CharactersListViewModelLoading {
    case fullScreen
    case nextPage
}

// MARK: - ViewModel Input

protocol CharactersListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func freshLoad()
    func didFilter(with name: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

// MARK: - ViewModel Output

protocol CharactersListViewModelOutput {
    var items: [CharactersListItemViewModel] { get }
    var loading: CharactersListViewModelLoading? { get }
    var name: String { get }
    var error: String { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataText: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }

    var itemsPublisher: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var loadingPublisher: AnyPublisher<CharactersListViewModelLoading?, Never> { get }
    var namePublisher: AnyPublisher<String, Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
}

// MARK: - ViewModel Combined

typealias CharactersListViewModel = CharactersListViewModelInput & CharactersListViewModelOutput

final class DefaultCharactersListViewModel: CharactersListViewModel {
    // MARK: - Properties

    @Published private(set) var items: [CharactersListItemViewModel] = []
    @Published private(set) var loading: CharactersListViewModelLoading?
    @Published private(set) var name = ""
    @Published private(set) var error = ""

    private let filterCharactersUseCase: FilterRMCharactersUseCase
    private let mainQueue: DispatchQueueType
    private let actions: CharactersListViewModelActions?

    private var pages: [RMCharactersPage] = []
    private var charactersLoadTask: Cancellable? {
        willSet {
            charactersLoadTask?.cancel()
        }
    }

    let screenTitle = StringHelper.screenTitle
    let emptyDataText = StringHelper.emptyDataText
    let errorTitle = StringHelper.errorTitle
    let searchBarPlaceholder = StringHelper.searchBarPlaceholder

    var isEmpty: Bool { items.isEmpty }

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    // MARK: - Initialization

    init(
        filterCharactersUseCase: FilterRMCharactersUseCase,
        actions: CharactersListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.filterCharactersUseCase = filterCharactersUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private Methods

    private func appendPage(_ charactersPage: RMCharactersPage) {
        if let nextPage = charactersPage.info.next?.urlQueryParameter("page"),
           let nextPageInt = Int(nextPage) {
            currentPage = nextPageInt - 1
        } else {
            currentPage = charactersPage.info.pages
        }

        totalPageCount = charactersPage.info.pages

        pages = pages
            .filter { $0.info.next != charactersPage.info.next }
            + [charactersPage]

        items = pages.characters.map(CharactersListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1

        pages.removeAll()
        items.removeAll()
    }

    private func load(characterName: String, loading: CharactersListViewModelLoading) {
        self.loading = loading

        name = characterName

        charactersLoadTask = filterCharactersUseCase.execute(
            requestValue: .init(name: characterName, page: nextPage),
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
            StringHelper.noInternetConnection :
            StringHelper.failedLoadingCharacters
    }

    private func update(characterName: String) {
        resetPages()

        load(characterName: characterName, loading: .fullScreen)
    }
}

extension DefaultCharactersListViewModel {
    var itemsPublisher: AnyPublisher<[CharactersListItemViewModel], Never> {
        $items.eraseToAnyPublisher()
    }

    var loadingPublisher: AnyPublisher<CharactersListViewModelLoading?, Never> {
        $loading.eraseToAnyPublisher()
    }

    var namePublisher: AnyPublisher<String, Never> {
        $name.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<String, Never> {
        $error.eraseToAnyPublisher()
    }

    func viewDidLoad() {
        freshLoad()
    }

    func didLoadNextPage() {
        guard hasMorePages,
              loading == .none else { return }

        load(characterName: name, loading: .nextPage)
    }

    func didFilter(with name: String) {
        guard !name.isEmpty else { return }

        update(characterName: name)
    }

    func freshLoad() {
        update(characterName: "")
    }

    func didCancelSearch() {
        freshLoad()
    }

    func didSelectItem(at index: Int) {
        guard let character = pages.characters[safe: index] else { return }

        actions?.showCharacterDetails(character, nil)
    }
}

private extension Array where Element == RMCharactersPage {
    var characters: [RMCharacter] { flatMap { $0.results } }
}
