//
//  HideKeyboardWhenTappedAroundBehavior.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 24.01.24.
//

import UIKit

struct HideKeyboardWhenTappedAroundBehavior: ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {
        let tapGesture = TapGestureRecognizerWithClosure {
            viewController.view.endEditing(true)
        }

        tapGesture.cancelsTouchesInView = false

        if let navigationController = viewController.navigationController {
            navigationController.view.addGestureRecognizer(tapGesture)
        } else {
            viewController.view.addGestureRecognizer(tapGesture)
        }
    }
}
