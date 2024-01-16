//
//  CharacterDetailsViewController.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class CharacterDetailsViewController: UIViewController {
    private lazy var contentView: UIView = {
        let contentView: UIView = UIView()

        contentView.backgroundColor = ColorHelper.backgroundColorOne.color

        return contentView
    }()

    private var viewModel: CharacterDetailsViewModel!
    private var posterImagesRepository: RMPosterImagesRepository?

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

    override func loadView() {
        view = contentView
    }
}
