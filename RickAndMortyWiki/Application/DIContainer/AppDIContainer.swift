//
//  AppDIContainer.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()

    // MARK: - Network

    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )

        let apiDataNetwork = DefaultNetworkService(config: config)

        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.imagesBaseURL)!
        )

        let imagesDataNetwork = DefaultNetworkService(config: config)

        return DefaultDataTransferService(with: imagesDataNetwork)
    }()

    // MARK: - DIContainers of scenes

    func makeCharactersSceneDIContainer() -> CharactersSceneDIContainer {
        let dependencies = CharactersSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageDataTransferService
        )

        return CharactersSceneDIContainer(dependencies: dependencies)
    }
}
