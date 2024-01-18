//
//  EpisodesListTableViewCell.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import UIKit

final class EpisodesListTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = String(describing: EpisodesListTableViewCell.self)
    static let defaultHeight: CGFloat = 50.0

    private let mainQueue: DispatchQueueType = DispatchQueue.main

    private lazy var mainView: UIView = {
        let mainView: UIView = UIView()

        mainView.backgroundColor = ColorHelper.backgroundColorOne.color

        vStackView.fixInView(mainView)

        return mainView
    }()

    private lazy var vStackView: UIStackView = {
        let vStackView: UIStackView = UIStackView(arrangedSubviews: [
            hStackView,
            collectionView
        ])

        vStackView.axis = .vertical

        return vStackView
    }()

    private lazy var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        flowLayout.itemSize = CGSize(width: 110.0, height: 110.0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 0

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        collectionView.register(CharactersListCollectionViewCell.self, forCellWithReuseIdentifier: CharactersListCollectionViewCell.reuseIdentifier)

        return collectionView
    }()

    private lazy var hStackView: UIStackView = {
        let hStackView: UIStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            arrowImageView
        ])

        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.alignment = .center
        hStackView.spacing = 5.0

        return hStackView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel: UILabel = UILabel()

        nameLabel.textColor = ColorHelper.textColorOne.color
        nameLabel.font = FontHelper.latoBold(16.0).font

        NSLayoutConstraint.activate([
            nameLabel.heightConstraint(constant: 40.0)
        ])

        return nameLabel
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView: UIImageView = UIImageView()

        arrowImageView.image = ImageHelper.arrow.image
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = ColorHelper.textColorTwo.color

        NSLayoutConstraint.activate([
            arrowImageView.heightConstraint(constant: 18.0),
            arrowImageView.aspectRatio(1.0)
        ])

        return arrowImageView
    }()

    private var viewModel: EpisodesListItemViewModel!
    private var detailsViewModel: CharacterDetailsViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?

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

        arrowImageView.transform = .identity
    }

    // MARK: - Data Handling

    private func updateLabels() {
        nameLabel.text = "\(viewModel.name) - \(viewModel.episode)"
    }

    // MARK: - Configuration

    private func setupViews() {
        mainView.fixInView(contentView)

        selectionStyle = .none
    }

    func configure(
        with viewModel: EpisodesListItemViewModel?,
        extra detailsViewModel: CharacterDetailsViewModel?,
        posterImagesRepository: RMPosterImagesRepository?
    ) {
        guard let viewModel,
              let detailsViewModel else { return }

        self.viewModel = viewModel
        self.detailsViewModel = detailsViewModel
        self.posterImagesRepository = posterImagesRepository

        updateLabels()
    }

    func expand() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi / 2)
        }

        collectionView.constraints.forEach { $0.isActive = false }

        NSLayoutConstraint.activate([
            collectionView.heightConstraint(constant: 110.0)
        ])
    }

    func collapse() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.arrowImageView.transform = .identity
        }

        collectionView.constraints.forEach { $0.isActive = false }

        NSLayoutConstraint.activate([
            collectionView.heightConstraint(constant: 0)
        ])
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension EpisodesListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharactersListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CharactersListCollectionViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(CharactersListCollectionViewCell.self) with reuseIdentifier: \(CharactersListCollectionViewCell.reuseIdentifier)")

            return UICollectionViewCell()
        }

        cell.configure(with: EpisodesCharactersListItemViewModel(string: viewModel.characters[safe: indexPath.row]),
                       posterImagesRepository: posterImagesRepository)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let string = viewModel.characters[safe: indexPath.row],
              let url = URL(string: string) else { return }

        detailsViewModel.didSelectItem(with: Int(url.lastPathComponent))
    }
}
