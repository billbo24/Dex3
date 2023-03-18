//
//  FetchController.swift
//  Dex3
//
//  Created by William Floyd on 3/15/23.
//

import Foundation

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string:"https://pokeapi.co/api/v2/pokemon/")! //look up what the exclamation mark means
    
    func fetchAllPokemon() async throws -> [TempPokemon] {//look up async, throws mean it can throw error, and we're returning an array of TEmpPokemon
        var allPokemon: [TempPokemon] = []
        
        var fetchComponents = URLComponents(url:baseURL,resolvingAgainstBaseURL: true) //Not sure what the resolve thing is
        fetchComponents?.queryItems = [URLQueryItem(name:"limit",value:"386")] //No idea why we need the question mark thing
        
        guard let fetchURL = fetchComponents?.url else { //guard says stop here if this doesn't work\
            //check to see if the URL is good
            throw NetworkError.badURL
        }
        
        let (data,response) = try await URLSession.shared.data(from:fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            //now check to see we get a good response
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"]as? [[String:String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            if let url = pokemon["url"] {
                //No idea what the ! does
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data,response) = try await URLSession.shared.data(from:url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            //now check to see we get a good response
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self,from:data)
        
        //This is really just to make sure it all looks good
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
}
