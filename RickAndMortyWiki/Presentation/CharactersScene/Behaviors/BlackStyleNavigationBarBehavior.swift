//
//  BlackStyleNavigationBarBehavior.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
