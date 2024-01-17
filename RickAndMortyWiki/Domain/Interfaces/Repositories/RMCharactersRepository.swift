//
//  RMCharactersRepository.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import Foundation

protocol RMCharactersRepository {
    @discardableResult
    func fetchRMCharacterById(
        id: Int,
        cached: @escaping (RMCharacter) -> Void,
        completion: @escaping (Result<RMCharacter, Error>) -> Void
    ) -> Cancellable?

    @discardableResult
    func fetchRMCharactersByIds(
        ids: [Int],
        cached: @escaping ([RMCharacter]) -> Void,
        completion: @escaping (Result<[RMCharacter], Error>) -> Void
    ) -> Cancellable?

    @discardableResult
    func fetchRMCharacters(
        name: String,
        page: Int,
        cached: @escaping (RMCharactersPage) -> Void,
        completion: @escaping (Result<RMCharactersPage, Error>) -> Void
    ) -> Cancellable?
}
