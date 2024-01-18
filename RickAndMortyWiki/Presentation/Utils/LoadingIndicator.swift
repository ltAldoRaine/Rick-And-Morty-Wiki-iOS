//
//  LoadingIndicator.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

// MARK: - RF

class LoadingIndicator {
    static var spinner: UIActivityIndicatorView?

    static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(update),
                name: UIDevice.orientationDidChangeNotification,
                object: nil
            )

            if spinner == nil,
               let window = UIApplication.shared.keyWindow {
                let bounds: CGRect = UIScreen.main.bounds
                let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: bounds)

                spinner.backgroundColor = ColorHelper.helpColorOne.color
                spinner.style = .large

                window.addSubview(spinner)

                spinner.startAnimating()

                self.spinner = spinner
            }
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }

            spinner.stopAnimating()
            spinner.removeFromSuperview()

            self.spinner = nil
        }
    }

    @objc static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}
