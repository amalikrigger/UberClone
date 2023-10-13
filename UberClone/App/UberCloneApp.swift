//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import SwiftUI

@main
struct UberCloneApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var locationSearchViewModel = LocationSearchViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationSearchViewModel)
        }
    }
}
