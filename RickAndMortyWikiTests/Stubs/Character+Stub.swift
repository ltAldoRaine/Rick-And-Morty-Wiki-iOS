//
//  Character+Stub.swift
//  RickAndMortyWikiTests
//
//  Created by Beka Gelashvili on 22.01.24.
//

extension RMCharacter {
    static func stub(
        id: RMCharacter.Identifier = 1,
        name: String = "Rick Sanchez",
        status: RMCharacter.Status = .alive,
        species: String = "Human",
        type: String = "",
        gender: RMCharacter.Gender = .male,
        origin: RMCharacterOrigin = RMCharacterOrigin(
            name: "Earth (C-137)",
            url: "https://rickandmortyapi.com/api/location/1"
        ),
        location: RMCharacterLocation = RMCharacterLocation(
            name: "Citadel of Ricks",
            url: "https://rickandmortyapi.com/api/location/3"
        ),
        image: String = "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [String] = [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"

        ],
        url: String = "https://rickandmortyapi.com/api/character/1",
        created: String = "2017-11-04T18:48:46.250Z"
    ) -> Self {
        RMCharacter(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}
