//
//  RMPosterImagesRepository.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMPosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
