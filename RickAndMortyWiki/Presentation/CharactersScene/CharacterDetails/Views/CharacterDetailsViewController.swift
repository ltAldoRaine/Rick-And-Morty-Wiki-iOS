//
//  CharacterDetailsViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Combine
import UIKit

final class CharacterDetailsViewController: UIViewController {
    // MARK: - Properties

    private lazy var contentView: UIView = {
        let contentView: UIView = UIView()

        contentView.backgroundColor = ColorHelper.backgroundColorOne.color

        characterDetailsContainerView.fixInViewSafe(contentView, top: 20.0, trailing: -15.0, leading: 15.0)

        return contentView
    }()

    private lazy var characterDetailsContainerView: UIView = {
        let characterDetailsContainerView: UIView = UIView()

        characterDetailsContainerView.translatesAutoresizingMaskIntoConstraints = false

        characterDetailsTableViewController.view.fixInView(characterDetailsContainerView)

        return characterDetailsContainerView
    }()

    private lazy var characterDetailsTableViewController: CharacterDetailsTableViewController = {
        let characterDetailsTableViewController: CharacterDetailsTableViewController = CharacterDetailsTableViewController(
            with: viewModel,
            posterImagesRepository: posterImagesRepository
        )

        return characterDetailsTableViewController
    }()

    private lazy var emptyDataLabel: UILabel = {
        let emptyDataLabel: UILabel = UILabel()

        emptyDataLabel.backgroundColor = .white
        emptyDataLabel.textAlignment = .center
        emptyDataLabel.font = FontHelper.latoMedium(20.0).font

        return emptyDataLabel
    }()

    private var viewModel: CharacterDetailsViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?
    private var subscribers: Set<AnyCancellable> = []

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
        viewModel.itemPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                guard let self else { return }

                self.reloadItem(item)
            }
            .store(in: &subscribers)
    }

    // MARK: - Setup

    private func setupViews() {}

    private func setupBehaviours() {
        addBehaviors([
            BackButtonEmptyTitleNavigationBarBehavior(),
            BlackStyleNavigationBarBehavior()
        ])
    }

    // MARK: - Data Handling

    private func reloadItem(_ item: CharactersListItemViewModel?) {
        updateTitle(item: item)
    }

    private func updateTitle(item: CharactersListItemViewModel?) {
        title = item?.name
    }
}
