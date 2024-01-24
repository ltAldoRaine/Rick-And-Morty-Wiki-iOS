//
//  TapGestureRecognizerWithClosure.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 24.01.24.
//

import UIKit

class TapGestureRecognizerWithClosure: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action

        super.init(target: nil, action: nil)

        addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
