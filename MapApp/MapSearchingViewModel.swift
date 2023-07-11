//
//  MapSearchingViewModel.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import Combine
import Foundation
import MapKit

class MapSearchingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var annotations: [MKPointAnnotation] = []
    @Published var isSearching = false
    @Published var searchQuery = ""
    @Published var mapItmes = [MKMapItem]()
    @Published var selectedMapItem: MKMapItem?
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
    
    var cancellable: AnyCancellable?
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Onayla lan")
        case .restricted:
            print("Onayla dövmeyim")
        case .denied:
            print("Son şansın")
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        
//        print(firstLocation.coordinate)
        self.currentLocation = firstLocation.coordinate
    }
    
    override init() {
        super.init()
       cancellable =  $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self]searchTerm in
                self?.performSearch(for: searchTerm)
            }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(forName: MapViewContainer.Coordinator.regionChangeNotification, object: nil, queue: .main) { [weak self] notification in
            self?.region = notification.object as? MKCoordinateRegion
        }
    }
    
    fileprivate var region: MKCoordinateRegion?
    
    func performSearch(for query: String) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let region = self.region {
            request.region = region
        }
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
