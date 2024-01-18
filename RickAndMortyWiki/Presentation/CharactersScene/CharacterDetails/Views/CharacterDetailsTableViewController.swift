//
//  CharacterDetailsTableViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import UIKit

final class CharacterDetailsTableViewController: UITableViewController {
    // MARK: - Nested types

    enum Section {
        case info(_ numberOfRows: Int)
        case episodes
    }

    // MARK: - Properties

    private lazy var sections: [Section] = {
        [
            .info(1),
            .episodes
        ]
    }()

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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.register(CharacterDetailsTableViewCell.self, forCellReuseIdentifier: CharacterDetailsTableViewCell.reuseIdentifier)
        tableView.register(EpisodesListTableViewCell.self, forCellReuseIdentifier: EpisodesListTableViewCell.reuseIdentifier)
    }

    // MARK: - Data Handling

    func reloadItems() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension CharacterDetailsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case let .info(numberOfRows):
            numberOfRows
        default:
            viewModel.item?.episodes.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .info:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CharacterDetailsTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? CharacterDetailsTableViewCell else {
                assertionFailure("Cannot dequeue reusable cell \(CharacterDetailsTableViewCell.self) with reuseIdentifier: \(CharacterDetailsTableViewCell.reuseIdentifier)")

                return UITableViewCell()
            }

            cell.configure(with: viewModel.item,
                           posterImagesRepository: posterImagesRepository)

            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EpisodesListTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? EpisodesListTableViewCell else {
                assertionFailure("Cannot dequeue reusable cell \(EpisodesListTableViewCell.self) with reuseIdentifier: \(EpisodesListTableViewCell.reuseIdentifier)")

                return UITableViewCell()
            }

            let episodeViewModel = viewModel.item?.episodes[safe: indexPath.row]

            cell.configure(with: episodeViewModel,
                           extra: viewModel,
                           posterImagesRepository: posterImagesRepository)

            if episodeViewModel?.isExpanded == true {
                cell.expand()
            } else {
                cell.collapse()
            }

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .episodes:
            let headerTitle: UILabel = UILabel()

            headerTitle.font = FontHelper.latoBold(28.0).font
            headerTitle.textColor = ColorHelper.textColorOne.color
            headerTitle.backgroundColor = ColorHelper.backgroundColorOne.color

            headerTitle.text = "Episodes"

            return headerTitle
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .episodes:
            return 50.0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .info:
            break
        default:
            viewModel.didToggleEpisode(at: indexPath.row)
        }
    }
}
