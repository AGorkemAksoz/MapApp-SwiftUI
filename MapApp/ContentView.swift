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
            
            MapViewContainer(annotations: viewModel.annotations, selectedMapItem: viewModel.selectedMapItem, currentLocation: viewModel.currentLocation, searchQuery: viewModel.searchQuery)
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture()
                        .onChanged({ newValue in
                            print("*** NewValue \(newValue)")
                            viewModel.selectedMapItem?.name = "New"
                        })
                )
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Search for places", text: $viewModel.searchQuery, onCommit: {
                        UIApplication.shared.keyWindow?.endEditing(true)
                    })
                    .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12 )
                        .background(Color.white)
                        .autocorrectionDisabled()
                }
                .shadow(radius: 3)
                .padding()
                
                if viewModel.isSearching {
                    Text("Searching...")
                }
                
                Spacer()
                
                if viewModel.searchQuery.count > 3 {
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.mapItmes, id: \.self) { item in
                                Button(action: {
                                    print(item.name ?? "")
                                    self.viewModel.selectedMapItem = item
                                }, label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name ?? "")
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                        Text(item.placemark.title ?? "")
                                    }
                                })
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 200)
                                .background(Color.white)
                                .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                    }
                    .shadow(radius: 5)

                }
            }
            .padding()
        }
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MapSearchingViewModel())
    }
}
