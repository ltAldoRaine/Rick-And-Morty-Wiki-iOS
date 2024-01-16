//
//  UITableViewController+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

extension UITableViewController {
    func makeActivityIndicatorView(size: CGSize) -> UIActivityIndicatorView {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

        activityIndicatorView.backgroundColor = ColorHelper.helpColorOne.color

        activityIndicatorView.frame = CGRect(origin: .zero, size: size)
        activityIndicatorView.isHidden = false

        activityIndicatorView.startAnimating()

        return activityIndicatorView
    }
}
