//
//  RMEpisodeResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMEpisodeResponseStorage {
    typealias ResultType = Result<RMEpisodeDTO?, Error>

    func getResponse(
        for request: RMEpisodeRequestDTO,
        completion: @escaping (ResultType) -> Void
    )

    func save(response: RMEpisodeDTO, for requestDto: RMEpisodeRequestDTO)
}
