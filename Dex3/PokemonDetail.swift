//
//  PokemonDetail.swift
//  Dex3
//
//  Created by William Floyd on 3/19/23.
//

import SwiftUI
import CoreData //Required to get the NSFetch request stuff in here

struct PokemonDetail: View {
    //We have to initialize this a little differently since we're using coredata
    @EnvironmentObject var pokemon :  Pokemon
    
    @State var showShiny = false
    
    var body: some View {
        ScrollView {
            //Data will be long enough that we'll need the scrolling ability
            ZStack {
                Image("normalgrasselectricpoisonfairy")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                AsyncImage(url:showShiny ? pokemon.shinySprite : pokemon.sprite) {
                    image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top,50)
                        .shadow(color:.black,radius: 6)
                    
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                //Remember we need an id for each item.  We used the type which works, but they have to be unique or else we can't use itself as an id
                ForEach(pokemon.types!,id:\.self){
                    type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color:.white, radius: 1)
                        .padding([.top,.bottom],7)
                        .padding([.leading,.trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                Spacer()
            }
            .padding()
        }
        //note this stuff doesn't show up in the preview because....some reason.  I forget why exactly but the guy said trust him it will show up in the content view
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                Button {//toggle the show shiny variable
                    showShiny.toggle()
                } label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    }
                    else {
                        Image(systemName:"want.and.stars.inverse")
                    }
                }
            }
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        
        //the return is ambiguous with other info above, so we have to explicitly return pokemondetail
        PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
            
    }
}
