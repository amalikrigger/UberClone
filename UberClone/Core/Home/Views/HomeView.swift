//
//  HomeView.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import SwiftUI

struct HomeView: View {
  @State private var mapState = MapViewState.noInput
  @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel

  var body: some View {
      ZStack(alignment: .bottom) {
          ZStack(alignment: .top) {
          UberMapViewRepresentable(mapState: $mapState).ignoresSafeArea()

          if mapState == .searchingForLocation {
            LocationSearchView(mapState: $mapState)
          } else if mapState == .noInput {
            LocationSearchActivationView().padding(.top, 72)
              .onTapGesture {
                withAnimation(.spring()) {
                  mapState = .searchingForLocation
                }
             }
          }
          MapViewActionButton(mapState: $mapState).padding(.leading).padding(.top, 4)
          }
          
          if mapState == .locationSelected {
              RideRequestView()
                  .transition(.move(edge: .bottom))
          }
      }.edgesIgnoringSafeArea(.bottom)
          .onReceive(LocationManager.shared.$userLocation) { location in
              if let location = location {
                  locationSearchViewModel.userLocation = location
              }
          }
  }
}

#Preview {
  HomeView()
}
