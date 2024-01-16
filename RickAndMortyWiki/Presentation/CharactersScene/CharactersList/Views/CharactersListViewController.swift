//
//  CharactersListViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import UIKit

final class CharactersListViewController: UIViewController, Alertable {
    // MARK: - Properties

    private lazy var contentView: UIView = {
        let contentView: UIView = UIView()

        contentView.backgroundColor = ColorHelper.backgroundColorOne.color

        vStackView.fixInViewSafe(contentView)

        return contentView
    }()

    private lazy var vStackView: UIStackView = {
        let vStackView: UIStackView = UIStackView(arrangedSubviews: [
            searchBar,
            charactersContainerView,
            emptyDataLabel
        ])

        vStackView.axis = .vertical

        return vStackView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        let height: CGFloat = 56.0

        searchBar.translatesAutoresizingMaskIntoConstraints = false

        searchBar.delegate = self
        searchBar.barTintColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField

        NSLayoutConstraint.activate([
            searchBar.heightConstraint(constant: height)
        ])

        return searchBar
    }()

    private lazy var charactersContainerView: UIView = {
        let charactersContainerView: UIView = UIView()

        charactersTableViewController.view.fixInView(charactersContainerView, top: 15.0, trailing: 15.0, leading: 15.0)

        return charactersContainerView
    }()

    private lazy var charactersTableViewController: CharactersListTableViewController = {
        let charactersListTableViewController: CharactersListTableViewController = CharactersListTableViewController(
            with: viewModel,
            posterImagesRepository: posterImagesRepository
        )

        return charactersListTableViewController
    }()

    private lazy var emptyDataLabel: UILabel = {
        let emptyDataLabel: UILabel = UILabel()

        emptyDataLabel.backgroundColor = .white
        emptyDataLabel.textAlignment = .center

        return emptyDataLabel
    }()

    private var viewModel: CharactersListViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?
    private var subscribers: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(
        with viewModel: CharactersListViewModel,
        posterImagesRepository: RMPosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBehaviours()

        bindData()

        viewModel.viewDidLoad()
    }

    // MARK: - Data Binding

    private func bindData() {
        viewModel.itemsPublisher
            .sink { [weak self] _ in
                guard let self else { return }

                reloadItems()
            }
            .store(in: &subscribers)

        viewModel.loadingPublisher
            .sink { [weak self] in
                guard let self else { return }

                updateLoading($0)
            }
            .store(in: &subscribers)

        viewModel.queryPublisher
            .sink { [weak self] in
                guard let self else { return }

                updateSearchText($0)
            }
            .store(in: &subscribers)

        viewModel.errorPublisher
            .sink { [weak self] in
                guard let self else { return }

                showError($0)
            }
            .store(in: &subscribers)
    }

    // MARK: - Setup

    private func setupViews() {
        title = viewModel.screenTitle

        emptyDataLabel.text = viewModel.emptyDataText
    }

    private func setupBehaviours() {
        addBehaviors([
            BackButtonEmptyTitleNavigationBarBehavior(),
            BlackStyleNavigationBarBehavior()
        ])
    }

    // MARK: - Data Handling

    private func reloadItems() {
        charactersTableViewController.reloadItems()
    }

    private func updateLoading(_ loading: CharactersListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        charactersContainerView.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen:
            LoadingView.show()
        case .nextPage:
            charactersContainerView.isHidden = false
        case .none:
            charactersContainerView.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }

        charactersTableViewController.updateLoading(loading)
    }

    private func updateSearchText(_ text: String) {
        searchBar.text = text
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }

        presentAlert(title: viewModel.errorTitle, message: error)
    }
}

// MARK: - UISearchBarDelegate

extension CharactersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let trimmedSearchText = searchBar.text?.trim(),
              !trimmedSearchText.isEmpty else { return }

        viewModel.didFilter(query: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.endEditing(true)

        if searchBar.text?.isEmpty == false {
            viewModel.didCancelSearch()
        }

        searchBar.text = nil
    }
}
