//
//  LocationSearchViewModel.swift
//  UberClone
//
//  Created by Amali Krigger on 10/13/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
  @Published var results = [MKLocalSearchCompletion]()
  @Published var selectedUberLocation: UberLocation?
  @Published var pickUpTime: String?
  @Published var dropOffTime: String?
    
  private let searchCompleter = MKLocalSearchCompleter()
  var queryFragment: String = "" {
    didSet {
      searchCompleter.queryFragment = queryFragment
    }
  }
    
  var userLocation: CLLocationCoordinate2D?

  override init() {
    super.init()
    searchCompleter.delegate = self
    searchCompleter.queryFragment = queryFragment
  }

  func selectLocation(_ localSearch: MKLocalSearchCompletion) {
    locationSearch(forLocalSearchCompletion: localSearch) { response, error in
      if let error = error {
        print("DEBUG: Location search failed with error \(error.localizedDescription)")
        return
      }
      guard let item = response?.mapItems.first else { return }
      let coordinate = item.placemark.coordinate
      self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
    }
  }

  func locationSearch(
    forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
    completion: @escaping MKLocalSearch.CompletionHandler
  ) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: completion)
  }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destinaton = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        let tripDistanceInMeters = userLocation.distance(from: destinaton)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(
      from userLocation: CLLocationCoordinate2D,
      to destination: CLLocationCoordinate2D,
      completion: @escaping (MKRoute) -> Void
    ) {
      let userPlacemark = MKPlacemark(coordinate: userLocation)
      let desPlacemark = MKPlacemark(coordinate: destination)
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: userPlacemark)
      request.destination = MKMapItem(placemark: desPlacemark)
      let directions = MKDirections(request: request)
      directions.calculate { response, error in
        if let error = error {
          print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
          return
        }

        guard let route = response?.routes.first else { return }
          self.configurePickUAndDropOffTimes(with: route.expectedTravelTime)
        completion(route)
      }
    }
    
    func configurePickUAndDropOffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickUpTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.results = completer.results
  }
}
