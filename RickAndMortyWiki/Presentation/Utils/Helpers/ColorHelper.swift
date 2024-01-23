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
    case inputsStrokesButtonsColor
    case successColor
    case textColorOne
    case textColorThree
    case textColorTwo

    var color: UIColor {
        UIColor(named: rawValue.capitalizingFirstLetter()) ?? .clear
    }
}
