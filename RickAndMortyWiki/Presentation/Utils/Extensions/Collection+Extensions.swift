//
//  Collection+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 17.01.24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
