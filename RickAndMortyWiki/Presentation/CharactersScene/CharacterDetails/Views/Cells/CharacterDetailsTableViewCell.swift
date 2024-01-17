//
//  CharacterDetailsTableViewCell.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import UIKit

final class CharacterDetailsTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = String(describing: CharacterDetailsTableViewCell.self)
    static let defaultHeight: CGFloat = 150.0

    private let mainQueue: DispatchQueueType = DispatchQueue.main

    private lazy var mainView: UIView = {
        let mainView: UIView = UIView()

        mainView.backgroundColor = ColorHelper.backgroundColorOne.color

        vStackView.fixInView(mainView)

        return mainView
    }()

    private lazy var vStackView: UIStackView = {
        let vStackView: UIStackView = UIStackView(arrangedSubviews: [
            posterImageContainer
        ])

        vStackView.axis = .vertical
        vStackView.spacing = 10.0

        return vStackView
    }()

    private lazy var posterImageContainer: UIView = {
        let posterImageContainer: UIView = UIView()

        posterImageContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageContainer.heightConstraint(constant: 200.0),
        ])

        posterImageView.fixCenterX(posterImageContainer)

        return posterImageContainer
    }()

    private lazy var posterImageView: UIImageView = {
        let posterImageView: UIImageView = UIImageView()

        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 20.0
        posterImageView.backgroundColor = ColorHelper.helpColorOne.color

        NSLayoutConstraint.activate([
            posterImageView.widthConstraint(constant: 200.0),
            posterImageView.aspectRatio(1.0)
        ])

        return posterImageView
    }()

    private var viewModel: CharactersListItemViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadTask?.cancel()

        posterImageView.image = nil
    }

    // MARK: - Data Handling

    private func updatePosterImage() {
        guard let lastPathComponent = URL(string: viewModel.posterImagePath)?.lastPathComponent else { return }

        posterImageView.image = nil

        imageLoadTask = posterImagesRepository?.fetchImage(
            with: lastPathComponent
        ) { [weak self] result in
            guard let self else { return }

            mainQueue.async {
                guard self.viewModel.posterImagePath.contains(lastPathComponent) else { return }

                if case let .success(data) = result {
                    self.posterImageView.image = UIImage(data: data)
                }

                self.imageLoadTask = nil
            }
        }
    }

    private func updateLabels() {
//        nameLabel.text = viewModel.name
//        originLabel.text = viewModel.origin
//        statusLabel.text = "\(viewModel.status.rawValue.capitalizingFirstLetter()) - \(viewModel.species)"
    }

    private func updateStatusViewBackgroundColor() {
//        statusView.backgroundColor = if viewModel.status == .alive { ColorHelper.successColor.color }
//        else { ColorHelper.errorColor.color }
    }

    // MARK: - Configuration

    private func setupViews() {
        mainView.fixInView(contentView)

        selectionStyle = .none
    }

    func configure(
        with viewModel: CharactersListItemViewModel,
        posterImagesRepository: RMPosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        updateLabels()
        updateStatusViewBackgroundColor()
        updatePosterImage()
    }
}
