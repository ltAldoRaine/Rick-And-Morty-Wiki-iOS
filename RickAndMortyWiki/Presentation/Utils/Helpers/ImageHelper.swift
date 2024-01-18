//
//  ImageHelper.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 16.01.24.
//

import UIKit

enum ImageHelper: String {
    case arrow

    var image: UIImage? {
        UIImage(named: rawValue.capitalizingFirstLetter())
    }
}
