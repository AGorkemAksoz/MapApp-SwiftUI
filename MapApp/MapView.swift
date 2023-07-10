//
//  MapView.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import MapKit
import SwiftUI


struct MapView: UIViewRepresentable {
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            annotationView.animatesDrop = true
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        // Setup Region For Map
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        /*
        // Setup Annotations For Map
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        mapView.addAnnotation(annotation)
        
        let appleCampusAnnotation = MKPointAnnotation()
        appleCampusAnnotation.coordinate = .init(latitude: 37.3326, longitude: -122.030024)
        appleCampusAnnotation.title = "Apple Campus"
        mapView.addAnnotation(appleCampusAnnotation)

        mapView.showAnnotations(mapView.annotations, animated: true)
         */
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Apple"
        request.region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { resp, error in
            if let error = error {
                print("Failed local search: \(error)")
                return
            }
            
            resp?.mapItems.forEach({ mapItem in
                
                print(mapItem.address(mapItem))
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                mapView.addAnnotation(annotation)
                mapView.showAnnotations(mapView.annotations, animated: true)
            })
        }
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}

extension MKMapItem {
    func address(_ mapItem: MKMapItem) -> String {
        let placemark = mapItem.placemark
        var addressString = ""
        
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        return addressString
    }
}
