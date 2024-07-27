//
//  Pokemon.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import Foundation
import UIKit

struct Results: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let name: String?
    let url: String
}

struct Pokemon: Decodable {
    let abilities: [Abilities]
    let sprites: Sprites
    let name: String
}

struct Abilities: Decodable {
    let ability: Ability
}

struct Ability: Decodable {
    let name: String
    let url: String
}

struct Sprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

class PokemonWithImage {
    let name: String
    let image: UIImage?
    
    init(name: String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}
