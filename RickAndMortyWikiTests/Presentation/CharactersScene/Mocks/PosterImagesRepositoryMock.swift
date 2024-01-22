//
//  PosterImagesRepositoryMock.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

import Foundation
import XCTest

class PosterImagesRepositoryMock: RMPosterImagesRepository {
    var completionCalls = 0
    var error: Error?
    var image = Data()
    var validateInput: ((String) -> Void)?

    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        validateInput?(imagePath)

        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(image))
        }

        completionCalls += 1

        return nil
    }
}
