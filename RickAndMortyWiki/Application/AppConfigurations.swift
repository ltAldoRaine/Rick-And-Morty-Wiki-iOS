//
//  AppConfigurations.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

final class AppConfiguration {
    // MARK: - Constants

    private enum Keys {
        static let apiBaseURL = "ApiBaseURL"
        static let imageBaseURL = "ImageBaseURL"
    }

    // MARK: - Properties

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: Keys.apiBaseURL) as? String else {
            fatalError("Error: \(Keys.apiBaseURL) must not be empty in the Info.plist file.")
        }

        return apiBaseURL
    }()

    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: Keys.imageBaseURL) as? String else {
            fatalError("Error: \(Keys.imageBaseURL) must not be empty in the Info.plist file.")
        }

        return imageBaseURL
    }()
}
