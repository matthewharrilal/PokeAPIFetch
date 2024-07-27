//
//  NetworkService.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import Foundation

protocol NetworkService: AnyObject {
    func fetchAllPokemon() async -> Results?
    func fetchAllPokemonDetails() async -> AsyncStream<Pokemon?>
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
            print("Trouble with fetching all Pokemon")
            return nil
        }
    }
    
    func fetchIndividualPokemon(url: URL) async -> Pokemon? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        }
        catch {
            print("Trouble fetching individual Pokemon")
            return nil
        }
    }
    
    func fetchAllPokemonDetails() async -> AsyncStream<Pokemon?> {
        let allPokemon = await fetchAllPokemon()
        let urls: [URL] = allPokemon?.results.compactMap { URL(string: $0.url) } ?? []
        
        return AsyncStream<Pokemon?> { continuation in
            Task { [weak self] in
                
                guard let self = self else {
                    continuation.finish() // Finish early if self is nil
                    return
                }
                await withTaskGroup(of: Pokemon?.self) { taskGroup in
                    for url in urls {
                        taskGroup.addTask {
                            do {
                                let pokemon = try await self.fetchIndividualPokemon(url: url)
                                return pokemon
                            }
                            catch {
                                print("Unable to fetch individual pokemon for \(url)")
                                return nil
                            }
                        }
                    }
                    
                    for await pokemon in taskGroup {
                        
                        continuation.yield(pokemon)
                    }
                    
                    continuation.finish()
                }
            }
            
        }
    }
}
