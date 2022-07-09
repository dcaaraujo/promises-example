import Foundation
import Promises

protocol PokemonApi {
    func fetchPokemon() -> Promise<PokemonList>
    func fetchDetails(for pokemon: PokemonApiLink) -> Promise<PokemonDetails>
}

class PokemonApiImpl: PokemonApi {
    
    private let decoder = JSONDecoder()
    private let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100")!
    
    func fetchPokemon() -> Promise<PokemonList> {
        Promise<PokemonList> { fulfill, reject in
            let task = URLSession.shared.dataTask(with: self.url) { data, _, error in
                if let error = error {
                    reject(error)
                    return
                }
                do {
                    let response = try self.decoder.decode(PokemonList.self, from: data!)
                    fulfill(response)
                } catch {
                    reject(error)
                }
            }
            task.resume()
        }
    }
    
    func fetchDetails(for pokemon: PokemonApiLink) -> Promise<PokemonDetails> {
        Promise<PokemonDetails> { fulfill, reject in
            let task = URLSession.shared.dataTask(with: pokemon.url) { data, _, error in
                if let error = error {
                    reject(error)
                    return
                }
                do {
                    let response = try self.decoder.decode(PokemonDetails.self, from: data!)
                    fulfill(response)
                } catch {
                    reject(error)
                }
            }
            task.resume()
        }
    }
}


struct PokemonList: Decodable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PokemonApiLink]
}

struct PokemonApiLink: Decodable {
    let name: String
    let url: URL
}

struct PokemonDetails: Decodable {
    let name: String
    let weight: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
}

struct PokemonType: Decodable {
    let slot: Int
    let type: PokemonApiLink
}

struct PokemonStat: Decodable {
    let baseStat: Int
    let stat: PokemonApiLink
    
    enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
    }
}
