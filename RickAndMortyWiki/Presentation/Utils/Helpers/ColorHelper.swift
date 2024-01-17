//
//  ColorHelper.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 16.01.24.
//

import UIKit

enum ColorHelper: String {
    case accentColor
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
    case test

    var color: UIColor {
        UIColor(named: rawValue.capitalizingFirstLetter()) ?? .clear
    }
}
