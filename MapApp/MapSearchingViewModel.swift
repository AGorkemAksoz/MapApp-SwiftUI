//
//  MapSearchingViewModel.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import Combine
import Foundation
import MapKit

class MapSearchingViewModel: ObservableObject {
    
    @Published var annotations: [MKPointAnnotation] = []
    @Published var isSearching = false
    @Published var searchQuery = ""
    @Published var mapItmes = [MKMapItem]()
    @Published var selectedMapItem: MKMapItem?
    var cancellable: AnyCancellable?
    
    init() {
       cancellable =  $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self]searchTerm in
                self?.performSearch(for: searchTerm)
            }
    }
    
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
            
            self.mapItmes = resp?.mapItems ?? []
            
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
