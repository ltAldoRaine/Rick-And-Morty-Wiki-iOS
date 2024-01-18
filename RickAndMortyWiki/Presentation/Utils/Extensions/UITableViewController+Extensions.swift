//
//  UITableViewController+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

extension UITableViewController {
    func makeActivityIndicatorView(size: CGSize = CGSize(width: 40, height: 40)) -> UIActivityIndicatorView {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

        activityIndicatorView.backgroundColor = ColorHelper.helpColorOne.color
        activityIndicatorView.frame = CGRect(origin: .zero, size: size)
        activityIndicatorView.startAnimating()

        return activityIndicatorView
    }
}
