//
//  RMEpisodesResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMEpisodesResponseStorage {
    typealias ResultType = Result<[RMEpisodeDTO]?, Error>

    func getResponse(
        for request: RMEpisodesRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: [RMEpisodeDTO], for requestDto: RMEpisodesRequestDTO)
}
