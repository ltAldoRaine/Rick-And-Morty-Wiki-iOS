//
//  ImageHelper.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 16.01.24.
//

import UIKit

enum ImageHelper: String {
    case backgroundColorOne
    case errorColor
    case helpColorOne
    case helpColorTwo
    case inputsStrokesButtonsColor
    case successColor
    case textColorFour
    case textColorOne
    case textColorThree
    case textColorTwo
    case warningColor

    var image: UIImage? {
        UIImage(named: rawValue.capitalizingFirstLetter())
    }
}
