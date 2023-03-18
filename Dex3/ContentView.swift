//
//  ContentView.swift
//  Dex3
//
//  Created by William Floyd on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    var body: some View {
        
        //Navigation view has been deprecated in iOS 16 so now we have to use a NavigationStack
        NavigationStack {
            List(pokedex) { pokemon in
                NavigationLink(value: pokemon) {
                    //exclamation mark means force unwrap the optional
                    //Basically says "we know it has a value so go get it
                    AsyncImage(url:pokemon.sprite){ image in
                        image.resizable().scaledToFit()
                        
                    } placeholder: { //no effing clue what this is
                        ProgressView()
                    }
                    .frame(width: 100,height: 100) // don't love hardcoding dimensions
                    
                    
                    Text(pokemon.name!.capitalized)
                }
            }
                
            .navigationTitle("Pokedex")
            .navigationDestination(for: Pokemon.self, destination: { pokemon in
                //This lets us clock on the link and we can see the little picture
                
                AsyncImage(url:pokemon.sprite){ image in
                    image.resizable().scaledToFit()
                    
                } placeholder: { //no effing clue what this is
                    ProgressView()
                }
                .frame(width: 100,height: 100) // don't love hardcoding dimensions

            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            
        }
    }

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
