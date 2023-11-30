//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct UberCloneApp: App {
  let persistenceController = PersistenceController.shared
//  @StateObject var locationSearchViewModel = LocationSearchViewModel()
  @StateObject var authViewModel = AuthViewModel()
  @StateObject var homeViewModel = HomeViewModel()

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      HomeView()
//        .environmentObject(locationSearchViewModel)
        .environmentObject(authViewModel)
        .environmentObject(homeViewModel)
    }
  }
}
