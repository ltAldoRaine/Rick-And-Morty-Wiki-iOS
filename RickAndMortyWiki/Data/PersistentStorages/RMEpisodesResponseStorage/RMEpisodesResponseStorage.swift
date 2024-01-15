//
//  RMEpisodesResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMEpisodesResponseStorage {
    func getResponse(
        for request: RMEpisodesRequestDTO,
        completion: @escaping (Result<[RMEpisodeDTO]?, Error>) -> Void
    )

    func save(response: [RMEpisodeDTO], for requestDto: RMEpisodesRequestDTO)
}
