//
//  AppAppearance.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation
import UIKit

final class AppAppearance {
    static func setupAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()

            appearance.backgroundColor = ColorHelper.backgroundColorOne.color
            appearance.titleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
            appearance.largeTitleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().prefersLargeTitles = true
        } else {
            UINavigationBar.appearance().barTintColor = ColorHelper.textColorOne.color
            UINavigationBar.appearance().tintColor = ColorHelper.textColorOne.color
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
        }
    }
}
