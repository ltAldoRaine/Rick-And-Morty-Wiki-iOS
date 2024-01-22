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
    static let defaultHeight: CGFloat = 200.0

    private let mainQueue: DispatchQueueType = DispatchQueue.main

    private lazy var mainView: UIView = {
        let mainView: UIView = UIView()

        mainView.backgroundColor = ColorHelper.backgroundColorOne.color

        vStackView.fixInView(mainView)

        return mainView
    }()

    private lazy var vStackView: UIStackView = {
        let leadingVStackView: UIStackView = UIStackView(arrangedSubviews: [
            originStackView,
            lastKnowLocationStackView
        ])

        leadingVStackView.axis = .vertical
        leadingVStackView.spacing = 10.0

        let trailingVStackView: UIStackView = UIStackView(arrangedSubviews: [
            episodesQuantityStackView,
            genderStackView
        ])

        trailingVStackView.axis = .vertical
        trailingVStackView.spacing = 10.0

        let separatorView = UIView()

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ColorHelper.inputsStrokesButtonsColor.color

        NSLayoutConstraint.activate([
            separatorView.widthConstraint(constant: 1.0)
        ])

        let hStackView: UIStackView = UIStackView(arrangedSubviews: [
            leadingVStackView,
            separatorView,
            trailingVStackView
        ])

        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 5.0

        let vStackView: UIStackView = UIStackView(arrangedSubviews: [
            posterImageContainer,
            statusContainer,
            hStackView
        ])

        vStackView.axis = .vertical
        vStackView.spacing = 10.0

        return vStackView
    }()

    private lazy var posterImageContainer: UIView = {
        let posterImageContainer: UIView = UIView()

        posterImageContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageContainer.heightConstraint(constant: 200.0)
        ])

        posterImageView.fixCenterX(posterImageContainer)

        return posterImageContainer
    }()

    private lazy var posterImageView: UIImageView = {
        let posterImageView: UIImageView = UIImageView()

        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 20.0
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = ColorHelper.helpColorOne.color

        NSLayoutConstraint.activate([
            posterImageView.widthConstraint(constant: 200.0),
            posterImageView.aspectRatio(1.0)
        ])

        return posterImageView
    }()

    private lazy var statusContainer: UIView = {
        let statusContainer: UIView = UIView()

        statusContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusContainer.heightConstraint(constant: 40.0)
        ])

        statusView.fixCenterX(statusContainer)

        return statusContainer
    }()

    private lazy var statusView: UIView = {
        let statusView: UIView = UIView()

        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 15.0

        NSLayoutConstraint.activate([
            statusView.widthConstraint(constant: 200.0),
            statusView.heightConstraint(constant: 40.0)
        ])

        statusLabel.fixCenterXAndY(statusView)

        return statusView
    }()

    private lazy var statusLabel: UILabel = {
        let statusLabel: UILabel = UILabel()

        statusLabel.textColor = ColorHelper.textColorThree.color
        statusLabel.font = FontHelper.latoBold(15.0).font

        return statusLabel
    }()

    private lazy var originStackView: UIStackView = {
        let originStackView: UIStackView = UIStackView(arrangedSubviews: [originTitleLabel, originLabel])

        originStackView.axis = .vertical
        originStackView.spacing = 2.0

        return originStackView
    }()

    private lazy var originTitleLabel: UILabel = {
        let originTitleLabel: UILabel = UILabel()

        originTitleLabel.text = StringHelper.origin
        originTitleLabel.textColor = ColorHelper.textColorTwo.color
        originTitleLabel.font = FontHelper.latoRegular(15.0).font

        return originTitleLabel
    }()

    private lazy var originLabel: UILabel = {
        let originLabel: UILabel = UILabel()

        originLabel.textColor = ColorHelper.textColorOne.color
        originLabel.font = FontHelper.latoBold(15.0).font

        return originLabel
    }()

    private lazy var lastKnowLocationStackView: UIStackView = {
        let lastKnowLocationStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                lastKnowLocationTitleLabel,
                lastKnowLocationLabel
            ]
        )

        lastKnowLocationStackView.axis = .vertical
        lastKnowLocationStackView.spacing = 2.0

        return lastKnowLocationStackView
    }()

    private lazy var lastKnowLocationTitleLabel: UILabel = {
        let lastKnowLocationTitleLabel: UILabel = UILabel()

        lastKnowLocationTitleLabel.text = StringHelper.lastKnownLocation
        lastKnowLocationTitleLabel.textColor = ColorHelper.textColorTwo.color
        lastKnowLocationTitleLabel.font = FontHelper.latoRegular(15.0).font

        return lastKnowLocationTitleLabel
    }()

    private lazy var lastKnowLocationLabel: UILabel = {
        let lastKnowLocationLabel: UILabel = UILabel()

        lastKnowLocationLabel.textColor = ColorHelper.textColorOne.color
        lastKnowLocationLabel.font = FontHelper.latoBold(15.0).font

        return lastKnowLocationLabel
    }()

    private lazy var episodesQuantityStackView: UIStackView = {
        let episodesQuantityStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                episodesQuantityTitleLabel, episodesQuantityLabel
            ]
        )

        episodesQuantityStackView.axis = .vertical
        episodesQuantityStackView.spacing = 2.0

        return episodesQuantityStackView
    }()

    private lazy var episodesQuantityTitleLabel: UILabel = {
        let episodesQuantityTitleLabel: UILabel = UILabel()

        episodesQuantityTitleLabel.text = StringHelper.numberOfEpisodes
        episodesQuantityTitleLabel.textColor = ColorHelper.textColorTwo.color
        episodesQuantityTitleLabel.font = FontHelper.latoRegular(15.0).font

        return episodesQuantityTitleLabel
    }()

    private lazy var episodesQuantityLabel: UILabel = {
        let episodesQuantityLabel: UILabel = UILabel()

        episodesQuantityLabel.textColor = ColorHelper.textColorOne.color
        episodesQuantityLabel.font = FontHelper.latoBold(15.0).font
        episodesQuantityLabel.textAlignment = .right

        return episodesQuantityLabel
    }()

    private lazy var genderStackView: UIStackView = {
        let genderStackView: UIStackView = UIStackView(arrangedSubviews: [genderTitleLabel, genderLabel])

        genderStackView.axis = .vertical
        genderStackView.spacing = 2.0

        return genderStackView
    }()

    private lazy var genderTitleLabel: UILabel = {
        let genderTitleLabel: UILabel = UILabel()

        genderTitleLabel.text = StringHelper.gender
        genderTitleLabel.textColor = ColorHelper.textColorTwo.color
        genderTitleLabel.font = FontHelper.latoRegular(15.0).font
        genderTitleLabel.textAlignment = .right

        return genderTitleLabel
    }()

    private lazy var genderLabel: UILabel = {
        let genderLabel: UILabel = UILabel()

        genderLabel.textColor = ColorHelper.textColorOne.color
        genderLabel.font = FontHelper.latoBold(15.0).font
        genderLabel.textAlignment = .right

        return genderLabel
    }()

    private var viewModel: CharactersListItemViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?
    private var imageLoadTask: Cancellable? {
        willSet { imageLoadTask?.cancel() }
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
        statusLabel.text = "\(viewModel.status.rawValue.capitalizingFirstLetter()) - \(viewModel.species)"
        originLabel.text = viewModel.origin
        lastKnowLocationLabel.text = viewModel.location
        episodesQuantityLabel.text = "\(viewModel.episode.count)"
        genderLabel.text = viewModel.gender.rawValue.capitalizingFirstLetter()
    }

    private func updateStatusViewBackgroundColor() {
        statusView.backgroundColor = if viewModel.status == .alive {
            ColorHelper.successColor.color
        } else {
            ColorHelper.errorColor.color
        }
    }

    // MARK: - Configuration

    private func setupViews() {
        mainView.fixInView(contentView)

        selectionStyle = .none
    }

    func configure(
        with viewModel: CharactersListItemViewModel?,
        posterImagesRepository: RMPosterImagesRepository?
    ) {
        guard let viewModel else { return }

        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        updateLabels()
        updateStatusViewBackgroundColor()
        updatePosterImage()
    }
}
