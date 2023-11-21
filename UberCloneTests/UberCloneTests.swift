//
//  UberCloneTests.swift
//  UberCloneTests
//
//  Created by Amali Krigger on 10/12/23.
//

import XCTest
import MapKit
@testable import UberClone

final class UberCloneTests: XCTestCase {
    
    var locationSearchViewModel: LocationSearchViewModel?

    override func setUpWithError() throws {
        locationSearchViewModel = LocationSearchViewModel()
    }

    override func tearDownWithError() throws {
        locationSearchViewModel = nil
    }

    func testSelectLocation() {
        var mockLocalSearchCompletion = MockLocalSearchCompletion()
        mockLocalSearchCompletion.mockTitle = "Qdoba Mexican Eats"
        mockLocalSearchCompletion.subtitle = "5610 Glenridge Dr, Unit 105, Atlanta, GA 30342, United States"
        locationSearchViewModel?.selectLocation(mockLocalSearchCompletion)
        print("Title: \(locationSearchViewModel?.selectedUberLocation?.title ?? "None")")
    }
    
    func testComputeRidePrice() {
        let coordinate = CLLocationCoordinate2D(latitude: 33.908204480027528, longitude: -84.36352550983429)
        locationSearchViewModel?.selectedUberLocation = UberLocation(title: "Qdoba Mexican Eats", coordinate: coordinate)
        locationSearchViewModel?.userLocation = CLLocationCoordinate2D(latitude: 33.775396999999998, longitude: -84.387855000000002)
        let uberXPrice = locationSearchViewModel?.computeRidePrice(forType: RideType.uberX)
        XCTAssertEqual(uberXPrice?.toCurrency(), "$18.97")
        let uberBlackPrice = locationSearchViewModel?.computeRidePrice(forType: RideType.black)
        XCTAssertEqual(uberBlackPrice?.toCurrency(), "$38.63")
        let uberXLPrice = locationSearchViewModel?.computeRidePrice(forType: RideType.uberXL)
        XCTAssertEqual(uberXLPrice?.toCurrency(), "$26.30")
        locationSearchViewModel?.selectedUberLocation = nil
        let noDestinationPrice = locationSearchViewModel?.computeRidePrice(forType: RideType.uberXL)
        XCTAssertEqual(noDestinationPrice?.toCurrency(), "$0.00")
        locationSearchViewModel?.selectedUberLocation = UberLocation(title: "Qdoba Mexican Eats", coordinate: coordinate)
        locationSearchViewModel?.userLocation = nil
        let noUserLocationPrice = locationSearchViewModel?.computeRidePrice(forType: RideType.uberXL)
        XCTAssertEqual(noUserLocationPrice?.toCurrency(), "$0.00")
    }
    
    func testConfigurePickUAndDropOffTimes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        locationSearchViewModel?.configurePickUAndDropOffTimes(with: 600)
        let pickUpTime = formatter.string(from: Date())
        let dropOffTime = formatter.string(from: Date() + 600)
        
        XCTAssertEqual(pickUpTime, locationSearchViewModel?.pickUpTime)
        XCTAssertEqual(dropOffTime, locationSearchViewModel?.dropOffTime)
    }

}

class MockLocalSearchCompletion: MKLocalSearchCompletion {
    var mockTitle: String?
    var mockSubtitle: String?
    var mockCoordinate: CLLocationCoordinate2D?

    override var title: String {
        get {
            return mockTitle ?? ""
        }
        set {
            mockTitle = newValue
        }
    }

    override var subtitle: String {
        get {
            return mockSubtitle ?? ""
        }
        set {
            mockSubtitle = newValue
        }
    }
}

