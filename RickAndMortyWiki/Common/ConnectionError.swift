//
//  ConnectionError.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
