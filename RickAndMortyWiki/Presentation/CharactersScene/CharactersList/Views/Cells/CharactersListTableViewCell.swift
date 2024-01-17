//
//  CharactersListTableViewCell.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class CharactersListTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = String(describing: CharactersListTableViewCell.self)
    static let defaultHeight: CGFloat = 130.0

    private let mainQueue: DispatchQueueType = DispatchQueue.main

    private lazy var mainView: UIView = {
        let mainView: UIView = UIView()

        mainView.backgroundColor = ColorHelper.backgroundColorOne.color

        hStackView.fixInView(mainView)

        return mainView
    }()

    private lazy var posterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = ColorHelper.helpColorOne.color
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthConstraint(constant: CharactersListTableViewCell.defaultHeight - 8.0),
            imageView.aspectRatio(1.0)
        ])

        return imageView
    }()

    private lazy var hStackView: UIStackView = {
        let hStackView: UIStackView = UIStackView(arrangedSubviews: [posterImageView, vStackView])

        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 8.0

        return hStackView
    }()

    private lazy var vStackView: UIStackView = {
        let vStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, statusStackView, originStackView])

        vStackView.axis = .vertical
        vStackView.alignment = .leading
        vStackView.spacing = 8.0

        return vStackView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel: UILabel = UILabel()

        nameLabel.textColor = ColorHelper.textColorOne.color
        nameLabel.font = FontHelper.latoBold(20.0).font
        nameLabel.numberOfLines = 0
        
        return nameLabel
    }()

    private lazy var statusStackView: UIStackView = {
        let statusStackView: UIStackView = UIStackView(arrangedSubviews: [statusView, statusLabel])

        statusStackView.axis = .horizontal
        statusStackView.alignment = .center
        statusStackView.spacing = 8.0

        return statusStackView
    }()

    private lazy var statusView: UIView = {
        let statusView: UIView = UIView()

        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 6.0

        NSLayoutConstraint.activate([
            statusView.heightConstraint(constant: 12.0),
            statusView.aspectRatio(1.0)
        ])

        return statusView
    }()

    private lazy var statusLabel: UILabel = {
        let statusLabel: UILabel = UILabel()

        statusLabel.textColor = ColorHelper.textColorOne.color
        statusLabel.font = FontHelper.latoRegular(14.0).font

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

        originTitleLabel.text = "Last known location:"
        originTitleLabel.textColor = ColorHelper.textColorTwo.color
        originTitleLabel.font = FontHelper.latoRegular(14.0).font

        return originTitleLabel
    }()

    private lazy var originLabel: UILabel = {
        let originLabel: UILabel = UILabel()

        originLabel.textColor = ColorHelper.textColorOne.color
        originLabel.font = FontHelper.latoRegular(14.0).font

        return originLabel
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
        nameLabel.text = viewModel.name
        originLabel.text = viewModel.origin
        statusLabel.text = "\(viewModel.status.rawValue.capitalizingFirstLetter()) - \(viewModel.species)"
    }

    private func updateStatusViewBackgroundColor() {
        statusView.backgroundColor = if viewModel.status == .alive { ColorHelper.successColor.color }
        else { ColorHelper.errorColor.color }
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
