//
//  NetworkService.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import Foundation
import UIKit

protocol NetworkService: AnyObject {
    func fetchAllPokemon() async -> Results?
    func fetchAllPokemonDetails() async -> AsyncStream<Pokemon?>
//    func fetchImagesForPokemon(urls: [URL]) async -> AsyncStream<UIImage?>
    func fetchImagesForPokemon(pokemonStream: AsyncStream<Pokemon?>) async -> AsyncStream<PokemonWithImage?>
}

class NetworkServiceImplementation: NetworkService {
    
    private var cache: NSCache = NSCache<NSString, PokemonWithImage>()
    
    func fetchAllPokemon() async -> Results? {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else {
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
    
    func fetchImagesForPokemon(pokemonStream: AsyncStream<Pokemon?>) async -> AsyncStream<PokemonWithImage?> {
        AsyncStream<PokemonWithImage?> { continuation in
            Task {
                await withTaskGroup(of: PokemonWithImage?.self) { [weak self] taskGroup in
                    guard let self = self else {
                        continuation.finish()
                        return
                    }

                    for await pokemon in pokemonStream {
                        taskGroup.addTask {
                            if let pokemon = pokemon, let url = URL(string: pokemon.sprites.frontDefault) {
                                
                                if let cachedPokemonWithImage = self.cache.object(forKey: pokemon.name as NSString) {
                                    return cachedPokemonWithImage
                                }
                                
                                do {
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    let image = UIImage(data: data)
                                    
                                    let pokemonWithImage = PokemonWithImage(name: pokemon.name, image: image)
                                    self.cache.setObject(pokemonWithImage, forKey: pokemon.name as NSString)
                                    
                                    return pokemonWithImage
                                }
                                catch {
                                    print("Trouble creating pokemon with image object")
                                    return nil
                                }
                            } else {
                                return nil
                            }
                        }
                    }
                    
                    for await pokemonWithImage in taskGroup {
                        continuation.yield(pokemonWithImage)
                    }
                    continuation.finish()
                }
            }
        }
    }
}
