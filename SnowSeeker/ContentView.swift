//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Peter Hartnett on 5/21/22.
//

import SwiftUI

//This extension allows for a modifier that will force phones to use only the stacked style navigation view, while leaving other devices and settings alone.
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    @StateObject var favorites = Favorites()
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    //Day 99 challenge 3 States
    @State private var showingSortConfirmation = false
    enum SortingOrder{
        case none, alphabetical, country
    }
    @State private var currentSortingOrder : SortingOrder = .none
    
    
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            //dayy 99 challenge 3 change these to use the sorted variable
            return sortedResorts
        } else {
            return sortedResorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    // Day 99 challenge 3 sorting
    var sortedResorts: [Resort] {
        if currentSortingOrder == .alphabetical{
            return resorts.sorted { $0.name < $1.name  }
        } else if currentSortingOrder == .country{
            return resorts.sorted { $0.country < $1.country}
        } else {
            return resorts
        }
    }
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack{
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }//endlistlabel
            }//endlist
            
            //Day 99 challenge 3 Toolbar button
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        showingSortConfirmation = true
                    } label: {
                        Label("Add Book", systemImage: "arrow.up.arrow.down.square")
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            //Day 99 chalenge 3 confirmation dialog
            .confirmationDialog("Choose Sort Order", isPresented: $showingSortConfirmation, titleVisibility: .visible){
                Button("Default"){
                    currentSortingOrder = .none
                }
                Button("Alphabetical"){
                    currentSortingOrder = .alphabetical
                }
                Button("Country"){
                    currentSortingOrder = .country
                }
                
            }
            
           WelcomeView()
        }//end navigation view
        .environmentObject(favorites)
        
    //    .phoneOnlyStackNavigationView()
    }

   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
