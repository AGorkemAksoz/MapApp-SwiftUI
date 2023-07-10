//
//  ContentView.swift
//  MapApp
//
//  Created by Ali Görkem Aksöz on 9.07.2023.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MapSearchingViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            
            MapViewContainer(annotations: viewModel.annotations)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                HStack {
                    Button {
                        viewModel.performSearch(for: "Aspava")
                        
                    } label: {
                        Text("Search for airports")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    
                    
                    Button {
                        viewModel.annotations = []
                    } label: {
                        Text("Clear Annotations")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    
                }
                .shadow(radius: 8)
                
                if viewModel.isSearching {
                    Text("Searching...")
                }
            }
            

        }
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MapSearchingViewModel())
    }
}
