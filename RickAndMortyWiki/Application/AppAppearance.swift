//
//  AppAppearance.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

final class AppAppearance {
    // MARK: - Public Methods

    static func setupAppearance() {
        if #available(iOS 15, *) {
            setupAppearanceForiOS15AndAbove()
        } else {
            setupAppearanceForiOS14AndBelow()
        }
    }

    // MARK: - Private Methods

    @available(iOS 15, *)
    private static func setupAppearanceForiOS15AndAbove() {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = ColorHelper.backgroundColorOne.color
        appearance.titleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().prefersLargeTitles = true
    }

    private static func setupAppearanceForiOS14AndBelow() {
        let navigationBar = UINavigationBar.appearance()

        navigationBar.barTintColor = ColorHelper.textColorOne.color
        navigationBar.tintColor = ColorHelper.textColorOne.color
        navigationBar.titleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: ColorHelper.textColorOne.color]
    }
}
