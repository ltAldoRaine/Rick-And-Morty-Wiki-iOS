//
//  DataTransferError+Extensions.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 15.01.24.
//

import Foundation

extension DataTransferError: ConnectionError {
    var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              case .notConnected = networkError else {
            return false
        }

        return true
    }

    var isDecodingError: Bool {
        guard case DataTransferError.parsing = self else { return false }

        return true
    }
}
