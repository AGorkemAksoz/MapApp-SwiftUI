//
//  MapView.swift
//  MapApp
//
//  Created by Gorkem on 10.07.2023.
//

import MapKit
import SwiftUI

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



struct MapViewContainer: UIViewRepresentable {
    
    var annotations = [MKPointAnnotation]()
    var selectedMapItem: MKMapItem?
    
    let mapView = MKMapView()
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        init(mapView: MKMapView) {
            super.init()
            mapView.delegate = self
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            pinAnnotationView.canShowCallout = true
            return pinAnnotationView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: mapView )
    }
    
    // treat this as your setup area
    func makeUIView(context: Context) -> MKMapView {
        
        
        setupRegionForMap()
        return mapView
    }

    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(uiView.annotations, animated: true)
        
        uiView.annotations.forEach { annotation in
            if annotation.title == selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
        }
        
    }
    
    typealias UIViewType = MKMapView
    
    
}
