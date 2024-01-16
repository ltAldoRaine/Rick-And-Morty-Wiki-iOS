//
//  FontHelper.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 16.01.24.
//

import UIKit

enum FontHelper {
    case latoRegular(_ size: CGFloat)
    case latoMedium(_ size: CGFloat)
    case latoBold(_ size: CGFloat)

    static let systemFont = UIFont.systemFont(ofSize: 14.0)

    var font: UIFont {
        let font: UIFont? = switch self {
        case let .latoRegular(size):
            UIFont(name: "Lato-Regular", size: size)
        case let .latoMedium(size):
            UIFont(name: "Lato-Medium", size: size)
        case let .latoBold(size):
            UIFont(name: "Lato-Bold", size: size)
        }

        return font ?? FontHelper.systemFont
    }
}
