//
//  CharacterDetailsTableViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import UIKit

final class CharacterDetailsTableViewController: UITableViewController {
    // MARK: - Properties

    private var viewModel: CharacterDetailsViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?

    // MARK: - Initialization

    init(
        with viewModel: CharacterDetailsViewModel,
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
        tableView.estimatedRowHeight = CharacterDetailsTableViewCell.defaultHeight

//        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = CharacterDetailsTableViewCell.defaultHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
//
        tableView.register(CharacterDetailsTableViewCell.self, forCellReuseIdentifier: CharacterDetailsTableViewCell.reuseIdentifier)
    }

    // MARK: - Data Handling

    func reloadItems() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension CharacterDetailsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterDetailsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CharacterDetailsTableViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(CharacterDetailsTableViewCell.self) with reuseIdentifier: \(CharacterDetailsTableViewCell.reuseIdentifier)")

            return UITableViewCell()
        }

        return cell
    }
}
