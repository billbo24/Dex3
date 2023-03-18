//
//  TempPokemon.swift
//  Dex3
//
//  Created by William Floyd on 3/13/23.
//

import Foundation

//allows us to read from JSON
struct TempPokemon: Codable {
    //Recall this will help with the transition from the fetched data to the core data.  There's no favorite property in the fetched data
    let id: Int
    let name: String
    let types: [String]
    var hp: Int  = 0//Remember, we used int16 in the core datas setuop.  We will convert when the time is right
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    let sprite: URL
    let shiny: URL
    
    //This is going to help us build the structure of the JSON data within our code
    enum PokemonKeys: String, CodingKey {
        //Alright we don't need to specifiy default values here and if ChatGPT is to be believed, I think it's because
        //When we use the decoder protocol below, swift looks for key names that match the variable names in the PokemonKeys.self enum.  They have to match or else it doesn't work I guess.  
        case id
        case name
        case types
        case stats
        case sprites
        
        //Look up CodingKey
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat" //not sure I get this
            case stat
            
            
            enum StatKeys: String, CodingKey {
                case name
            }
            
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        //no clue what any of this is
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        //The ! negates it, so while we're NOT at the end of the typesContainer
        while !typesContainer.isAtEnd {
            //No clue what any of this self nonsense is
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            //All this stuff goes in and pulls out the type and appends it to a dictionary.  I suspect there's a WAY better way of doing this
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        types = decodedTypes //This creates our types array
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name) {
                //Interesting note here.  We got an error that said "immutable value, self.hp may only be initialized once.  it turns out the code knows this is a loop and it could potentially be initialized multiple times which isn't allowed.
                //We made this a let property!! It can only be set once. He had us change this by making them all vars.  That
                //doesn't really seem like a proper fix but okay.
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("it will never get here, but where does this show up")
            }
        }
        
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        //Apparently apple made this URL type to handle string URLs?
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
        
    }
    
}
