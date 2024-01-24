//
//  BackButtonNavigationBarBehavior.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

struct BackButtonNavigationBarBehavior: ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: StringHelper.back,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
