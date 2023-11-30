//
//  User.swift
//  UberClone
//
//  Created by Amali Krigger on 11/15/23.
//

import Foundation
import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let fullName: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}

extension User {
    static let mockUser = User(
        fullName: "Amali Krigger",
        email: "amalikrigger93@gmail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude: 37.332331, longitude: -122.031219),
        accountType: .passenger,
        homeLocation: nil,
        workLocation: nil)
}
