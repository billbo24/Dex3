//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by William Floyd on 3/17/23.
//

import Foundation

//wtf is this
@MainActor

class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
        
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller:FetchController) {
        self.controller = controller
        
        Task {
            //This must go in a task because async functions can only get run in the init block of code if they're in this Task block
            await getPokemon()
        }
        
    }
    
    private func getPokemon() async {
        //Note this async doesn't throw.  Look up why
        status = .fetching
        
        //Async means that multiuple fetch requests are sent simultaneously.  THis means we might not get them back in the right order.
        
        do {
            var pokedex = try await controller.fetchAllPokemon()
            
            pokedex.sort {$0.id < $1.id} //this sorts them
            
            for pokemon in pokedex {
                //Now is where we add the pokemon to core data
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                
                //Alright remember at the start of the project we created a core data object called pokemon.  We initialized one above this in the context line??? And the id had the property id which was type int16.  Simple conversion is needed that's all
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(newPokemon.hp)
                newPokemon.attack = Int16(newPokemon.attack)
                newPokemon.defense = Int16(newPokemon.defense)
                newPokemon.specialAttack = Int16(newPokemon.specialAttack)
                newPokemon.specialDefense = Int16(newPokemon.specialDefense)
                newPokemon.speed = Int16(newPokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny //had to udpate the coreData to add this.  Had to restart xcode to get it to work.
                newPokemon.favorite = false //set to false by default, and the user can set it to true if they want
                
                //This is how we actually save the coreData
                try PersistenceController.shared.container.viewContext.save()
                
            }
            
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
