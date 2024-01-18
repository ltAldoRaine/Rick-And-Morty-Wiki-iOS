//
//  CharactersListCollectionViewCell.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import UIKit

final class CharactersListCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    static let reuseIdentifier = String(describing: CharactersListCollectionViewCell.self)
    static let defaultSize: CGSize = CGSize(width: 50.0, height: 50.0)

    private let mainQueue: DispatchQueueType = DispatchQueue.main

    private lazy var mainView: UIView = {
        let mainView: UIView = UIView()

        posterImageView.fixInView(mainView)

        return mainView
    }()

    private lazy var posterImageView: UIImageView = {
        let posterImageView: UIImageView = UIImageView()

        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 20.0
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = ColorHelper.helpColorOne.color

        return posterImageView
    }()

    private var viewModel: EpisodesCharactersListItemViewModel?
    private var posterImagesRepository: RMPosterImagesRepository?
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadTask?.cancel()

        posterImageView.image = nil
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Data Handling

    private func updatePosterImage() {
        posterImageView.image = nil

        guard let posterImagePath = viewModel?.posterImagePath else { return }

        imageLoadTask = posterImagesRepository?.fetchImage(
            with: posterImagePath
        ) { [weak self] result in
            guard let self else { return }

            mainQueue.async {
                guard self.viewModel?.posterImagePath?.contains(posterImagePath) == true else { return }

                if case let .success(data) = result {
                    self.posterImageView.image = UIImage(data: data)
                }

                self.imageLoadTask = nil
            }
        }
    }

    // MARK: - Configuration

    private func setupViews() {
        mainView.fixInView(contentView)
    }

    func configure(
        with viewModel: EpisodesCharactersListItemViewModel?,
        posterImagesRepository: RMPosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        updatePosterImage()
    }
}
