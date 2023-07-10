//
//  MapAppApp.swift
//  MapApp
//
//  Created by Ali Görkem Aksöz on 9.07.2023.
//

import SwiftUI

@main
struct MapAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MapSearchingViewModel())
        }
    }
}
