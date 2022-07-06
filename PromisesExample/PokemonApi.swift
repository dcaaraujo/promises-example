import Foundation
import Promises

protocol PokemonApi {
    func fetchPokemon() -> Promise<AllPokemonResponse>
}

class PokemonApiImpl: PokemonApi {
    
    private let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100")!
    
    func fetchPokemon() -> Promise<AllPokemonResponse> {
        Promise<AllPokemonResponse> { fulfill, reject in
            let task = URLSession.shared.dataTask(with: self.url) { data, _, error in
                if let error = error {
                    reject(error)
                    return
                }
                do {
                    let response = try JSONDecoder().decode(AllPokemonResponse.self, from: data!)
                    fulfill(response)
                } catch {
                    reject(error)
                }
            }
            task.resume()
        }
    }
}


struct AllPokemonResponse: Decodable {
    let count: UInt
    let next: String
    let previous: String?
    let results: [PokemonQuery]
}

struct PokemonQuery: Decodable {
    let name: String
    let url: URL
}
