//
//  String+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 16.01.24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    }

    func urlQueryParameter(_ parameter: String) -> String? {
        guard let url = URLComponents(string: self) else { return nil }

        return url.queryItems?.first { $0.name == parameter }?.value
    }
}
