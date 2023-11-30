//
//  SavedLocation.swift
//  UberClone
//
//  Created by Amali Krigger on 11/22/23.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
