//
//  MapSearchingViewModel.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import MapKit
import Foundation

class MapSearchingViewModel: ObservableObject {
    
    @Published var annotations: [MKPointAnnotation] = []
    @Published var isSearching = false
    
    func performSearch(for query: String) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { resp, error in
            if let error = error {
                print("Failed to search: \(error.localizedDescription)")
                return
            }
            
            var airportAnnotataions = [MKPointAnnotation]()
            
            resp?.mapItems.forEach({ mapItem in
                print(mapItem.name ?? "N/A")
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                airportAnnotataions.append(annotation)
                
            })
            
            self.isSearching = false
            
            self.annotations = airportAnnotataions
        }
    }

}
