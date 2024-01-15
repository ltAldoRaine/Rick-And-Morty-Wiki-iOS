//
//  RMEpisode.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 13.01.24.
//

import Foundation

struct RMEpisode: Identifiable {
    typealias Identifier = Int

    let id: Identifier
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
