//
//  NetworkService.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import Foundation

protocol NetworkService: AnyObject {
    func fetchAllPokemon() async -> Results?
}

class NetworkServiceImplementation: NetworkService {
    
    func fetchAllPokemon() async -> Results? {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            let results = try JSONDecoder().decode(Results.self, from: data)
            return results
        }
        catch {
            print("Trouble with request")
            return nil
        }
    }
}
