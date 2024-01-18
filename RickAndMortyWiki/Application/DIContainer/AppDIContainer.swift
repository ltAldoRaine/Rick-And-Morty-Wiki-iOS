//
//  AppDIContainer.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

final class AppDIContainer {
    // MARK: - Properties

    private lazy var appConfiguration = AppConfiguration()

    // MARK: - Network

    private lazy var apiDataTransferService: DataTransferService = {
        guard let baseURL = URL(string: appConfiguration.apiBaseURL) else {
            fatalError("Error: Invalid API base URL.")
        }

        let config = ApiDataNetworkConfig(
            baseURL: baseURL,
            queryParameters: [:]
        )

        let apiDataNetwork = DefaultNetworkService(config: config)

        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    private lazy var imageDataTransferService: DataTransferService = {
        guard let baseURL = URL(string: appConfiguration.imagesBaseURL) else {
            fatalError("Error: Invalid Images base URL.")
        }

        let config = ApiDataNetworkConfig(
            baseURL: baseURL
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
