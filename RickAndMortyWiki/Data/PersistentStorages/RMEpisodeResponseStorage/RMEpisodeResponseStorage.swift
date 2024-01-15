//
//  RMEpisodeResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMEpisodeResponseStorage {
    func getResponse(
        for request: RMEpisodeRequestDTO,
        completion: @escaping (Result<RMEpisodeDTO?, Error>) -> Void
    )

    func save(response: RMEpisodeDTO, for requestDto: RMEpisodeRequestDTO)
}
