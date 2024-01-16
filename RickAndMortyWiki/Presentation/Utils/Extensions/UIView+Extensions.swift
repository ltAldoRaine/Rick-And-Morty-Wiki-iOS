//
//  UIView+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import UIKit

extension UIView {
    func fixInViewSafe(
        _ container: UIView?
    ) {
        guard let container else { return }

        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame

        container.addSubview(self)

        let guide = container.safeAreaLayoutGuide

        trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }

    func fixInView(
        _ container: UIView?,
        top: CGFloat = 0,
        trailing: CGFloat = 0,
        bottom: CGFloat = 0,
        leading: CGFloat = 0
    ) {
        guard let container else { return }

        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame

        container.addSubview(self)

        NSLayoutConstraint.activate([
            topConstraint(toItem: container, constant: top),
            trailingConstraint(toItem: container, constant: trailing),
            bottomContstrain(toItem: container, constant: bottom),
            leadingConstraint(toItem: container, constant: leading)
        ])
    }

    func topConstraint(toItem: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: constant)
    }

    func trailingConstraint(toItem: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: 1.0, constant: constant)
    }

    func bottomContstrain(toItem: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: constant)
    }

    func leadingConstraint(toItem: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: 1.0, constant: constant)
    }

    func heightConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }

    func widthConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }

    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}
