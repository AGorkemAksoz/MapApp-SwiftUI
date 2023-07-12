//
//  MapView.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import MapKit
import SwiftUI

struct MapViewContainer: UIViewRepresentable {
    
    var annotations = [MKPointAnnotation]()
    var selectedMapItem: MKMapItem?
    var currentLocation = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
    var searchQuery: String?
    
    
    let mapView = MKMapView()
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        init(mapView: MKMapView) {
            super.init()
            mapView.delegate = self
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if !(annotation is MKPointAnnotation) { return nil }
            
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            pinAnnotationView.canShowCallout = true
            return pinAnnotationView
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print("****** \(mapView.region)")
            NotificationCenter.default.post(name: MapViewContainer.Coordinator.regionChangeNotification, object: mapView.region)
        }
        
        static let regionChangeNotification = NSNotification.Name("regionChangeNotification")
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: mapView )
    }
    
    // treat this as your setup area
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.showsUserLocation = true
        setupRegionForMap()
        return mapView
    }

    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if annotations.count == 0 {
            
            print("*** Annotations count is \(annotations.count)")
            // setting up the map to current location
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            
            uiView.setRegion(region, animated: true)
            
            uiView.removeAnnotations(uiView.annotations)
            return
        }

        if let searchQuery = searchQuery, searchQuery.count >= 3 {
            print("*** Search Query")
                uiView.removeAnnotations(uiView.annotations)
                uiView.addAnnotations(annotations)
//                uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
            
            uiView.annotations.forEach { (annotation) in
                if annotation.title == selectedMapItem?.name {
                    print("*** Annotation \(annotations.count)")
                    uiView.selectAnnotation(annotation, animated: true)
                    withAnimation {
                        uiView.region.center = (selectedMapItem?.placemark.coordinate)!
                        
                    }
                }
            }
            }
        
        

        
        if searchQuery?.count ?? 0 < 3 {
            uiView.removeAnnotations(uiView.annotations)
        }
    }
    
    // This checks to see whether or not annotations have changed.  The algorithm generates a hashmap/dictionary for all the annotations and then goes through the map to check if they exist. If it doesn't currently exist, we treat this as a need to refresh the map
    fileprivate func shouldRefreshAnnotations(mapView: MKMapView) -> Bool {
        let grouped = Dictionary(grouping: mapView.annotations, by: { $0.title ?? ""})
        for (_, annotation) in annotations.enumerated() {
            if grouped[annotation.title ?? ""] == nil {
                return true
            }
        }
        return false
    }
    
}



/*
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
 */
