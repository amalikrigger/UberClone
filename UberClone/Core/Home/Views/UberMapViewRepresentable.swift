//
//  UberMapViewRepresentable.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import MapKit
import SwiftUI

struct UberMapViewRepresentable: UIViewRepresentable {
  let mapView = MKMapView()
  let locationManager = LocationManager()
  @EnvironmentObject var viewModel: LocationSearchViewModel


  func makeUIView(context: Context) -> MKMapView {
    mapView.delegate = context.coordinator
    mapView.isRotateEnabled = false
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
      if let coordinate = viewModel.selectedLocationCoordinate {
          print("DEBUG: \(coordinate)")
      }
  }

  func makeCoordinator() -> MapCoordinator {
    return MapCoordinator(parent: self)
  }

}

extension UberMapViewRepresentable {
  class MapCoordinator: NSObject, MKMapViewDelegate {
    let parent: UberMapViewRepresentable

    init(parent: UberMapViewRepresentable) {
      self.parent = parent
      super.init()
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
          latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )

      parent.mapView.setRegion(region, animated: true)
    }
  }
}
