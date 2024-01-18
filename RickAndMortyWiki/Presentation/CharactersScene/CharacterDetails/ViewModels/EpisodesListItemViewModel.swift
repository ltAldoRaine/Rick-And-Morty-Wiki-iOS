//
//  EpisodesListItemViewModel.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import Foundation

struct EpisodesListItemViewModel: Equatable {
    let name: String
    let episode: String
    let characters: [String]

    var isExpanded: Bool
}

extension EpisodesListItemViewModel {
    init(episode: RMEpisode) {
        name = episode.name
        self.episode = episode.episode
        characters = episode.characters

        isExpanded = false
    }
}
