//
//  HomeViewModel.swift
//  UberClone
//
//  Created by Amali Krigger on 11/27/23.
//

import SwiftUI
import Firebase
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    @Published var drivers = [User]()
    private let service = UserService.shared
    private var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    // Location search props
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?

    var queryFragment: String = "" {
      didSet {
        searchCompleter.queryFragment = queryFragment
      }
    }
    
    override init() {
        super.init()
        fetchUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users").whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.compactMap({try? $0.data(as: User.self)})
                self.drivers = drivers
            }
    }
    
    func fetchUser() {
        service.$user.sink { user in
            self.currentUser = user
            guard let user = user else { return }
            self.currentUser = user
            guard user.accountType == .passenger else { return }
            self.fetchDrivers()
        }
        .store(in: &cancellables)
    }
}

// MARK: - Passenger API

extension HomeViewModel {
    func requestTrip() {
        guard let driver = drivers.first else {return}
        guard let currentUser = currentUser else {return}
        guard let dropOffLocation = selectedUberLocation else {return}
        let dropOffGeoPoint = GeoPoint(latitude: dropOffLocation.coordinate.latitude, longitude: dropOffLocation.coordinate.longitude)
        
        print("DEBUG: Current user latitude \(currentUser.coordinates.latitude)")
        print("DEBUG: Current user longitude \(currentUser.coordinates.longitude)")

        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        
        getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark = placemark else {return}
            print("DEBUG: Placemark for user location is \(placemark.name)")
            let trip = Trip(id: NSUUID().uuidString,
                            passengerUid: currentUser.uid,
                            driverUid: driver.uid,
                            passengerName: currentUser.fullName,
                            driverName: driver.fullName,
                            passengerLocation: currentUser.coordinates,
                            driverLocation: driver.coordinates,
                            pickupLocationName: placemark.name ?? "Current Location",
                            dropoffLocationName: dropOffLocation.title,
                            pickupLocationAddress: "Rest",
                            pickupLocation: currentUser.coordinates,
                            dropoffLocation: dropOffGeoPoint,
                            tripCost: 50.0)
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else {return}
            
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("DEBUG: Did upload trip to firestore")
            }
        }
        
//        print("DEBUG: Trip is \(trip)")
    }
}

// MARK: - Driver API

extension HomeViewModel {
    
}

extension HomeViewModel {
    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
              print("DEBUG: Location search failed with error \(error.localizedDescription)")
              return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([viewModel.databaseKey: encodedLocation])
            }
        }
  }
    
  func locationSearch (
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
    let userLocation = CLLocation(
      latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
    let destinaton = CLLocation(
      latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
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

extension HomeViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.results = completer.results
  }
}

