//
//  Alertable.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func presentAlert(title: String,
                      message: String,
                      actions: [UIAlertAction] = [],
                      completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "Done", style: .cancel))
        } else {
            actions.forEach {
                alert.addAction($0)
            }
        }

        present(alert, animated: true, completion: completion)
    }
}
