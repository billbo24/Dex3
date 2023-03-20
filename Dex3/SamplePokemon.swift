//
//  SamplePokemon.swift
//  Dex3
//
//  Created by William Floyd on 3/19/23.
//

import Foundation
import CoreData
//Since it's kind of a hassle to actually create a sample pokemon we're going to build a sample pokemon struct

struct SamplePokemon {
    //We're going to reuse this over and over, so we need to make it shareable
    static let samplePokemon = {
        //This is where we stashed our bulbasaur example
        let context = PersistenceController.preview.container.viewContext
        
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try! context.fetch(fetchRequest)
        
        return results.first! //exclamation mark is forcing the issue 
    }() //This lets us sort of build the sample pokemon 
}
