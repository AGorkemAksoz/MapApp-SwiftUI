//
//  ContentView.swift
//  MapApp
//
//  Created by Ali Görkem Aksöz on 9.07.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MapView()
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
