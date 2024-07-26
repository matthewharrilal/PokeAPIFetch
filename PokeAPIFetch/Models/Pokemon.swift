//
//  Pokemon.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import Foundation

struct Results: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Decodable {
    let abilities: [Ability]
    let sprites: Sprites
}

struct Ability: Decodable {
    let name: String
}

struct Sprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
