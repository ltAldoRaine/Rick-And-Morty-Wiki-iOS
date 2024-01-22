//
//  CharactersListTableViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class CharactersListTableViewController: UITableViewController {
    // MARK: - Properties

    private var viewModel: CharactersListViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?
    private var nextPageActivityIndicatorView: UIActivityIndicatorView?

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
        tableView = UITableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        tableView.estimatedRowHeight = CharactersListTableViewCell.defaultHeight

        tableView.rowHeight = CharactersListTableViewCell.defaultHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.register(
            CharactersListTableViewCell.self,
            forCellReuseIdentifier: CharactersListTableViewCell.reuseIdentifier
        )
    }

    // MARK: - Loading Indicator Management

    private func showNextPageActivityIndicatorView() {
        let size: CGSize = CGSize(width: tableView.frame.width, height: 44.0)

        nextPageActivityIndicatorView?.removeFromSuperview()

        nextPageActivityIndicatorView = makeActivityIndicatorView(size: size)

        tableView.tableFooterView = nextPageActivityIndicatorView
    }

    private func hideNextPageActivityIndicatorView() {
        tableView.tableFooterView = nil
    }

    // MARK: - Data Handling

    func reloadItems() {
        tableView.reloadData()
    }

    func updateLoading(_ loading: CharactersListViewModelLoading?) {
        switch loading {
        case .nextPage:
            showNextPageActivityIndicatorView()
        case .fullScreen, .none:
            hideNextPageActivityIndicatorView()
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension CharactersListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharactersListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CharactersListTableViewCell else {
            assertionFailure(
                """
                Cannot dequeue reusable cell \(CharactersListTableViewCell.self)
                with reuseIdentifier: \(CharactersListTableViewCell.reuseIdentifier)
                """
            )

            return UITableViewCell()
        }

        guard let item = viewModel.items[safe: indexPath.row] else {
            assertionFailure(
                """
                Unable to access element at index \(indexPath.row).
                Index is out of bounds.
                """)

            return UITableViewCell()
        }

        cell.configure(with: item,
                       posterImagesRepository: posterImagesRepository)

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == viewModel.items.count - 1 {
            viewModel.didLoadNextPage()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
