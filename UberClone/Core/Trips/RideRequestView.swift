//
//  RideRequestView.swift
//  UberClone
//
//  Created by Amali Krigger on 10/13/23.
//

import SwiftUI

struct RideRequestView: View {
  @State private var selectedRideType: RideType = .uberX
  @EnvironmentObject var homeViewModel: HomeViewModel
  var body: some View {
    VStack {
      Capsule()
        .foregroundColor(Color(.systemGray5))
        .frame(width: 48, height: 6)
        .padding(.top, 8)
      HStack {
        VStack {
          Circle()
            .fill(Color(.systemGray3))
            .frame(width: 8, height: 8)
          Rectangle()
            .fill(Color(.systemGray3))
            .frame(width: 1, height: 32)
          Rectangle()
            .fill(Color(.black))
            .frame(width: 8, height: 8)
        }

        VStack(alignment: .leading, spacing: 24) {
          HStack {
            Text("Current Location")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.gray)

            Spacer()

            Text(homeViewModel.pickUpTime ?? "")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.gray)
          }
          .padding(.bottom, 10)

          HStack {
            if let location = homeViewModel.selectedUberLocation
              {
              Text(location.title)
                .font(.system(size: 16, weight: .semibold))
            }

            Spacer()

            Text(homeViewModel.dropOffTime ?? "")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.gray)
          }
        }.padding(.leading, 8)
      }.padding()

      Divider()

      Text("SUGGESTED RIDES")
        .font(.subheadline)
        .fontWeight(.semibold)
        .padding()
        .foregroundColor(Color(.gray))
        .frame(maxWidth: .infinity, alignment: .leading)

      ScrollView(.horizontal) {
        HStack(spacing: 12) {
          ForEach(RideType.allCases) { rideType in
            VStack(alignment: .leading) {
              Image(rideType.imageName)
                .resizable()
                .scaledToFit()

              VStack(alignment: .leading, spacing: 4) {
                Text(rideType.description)
                  .font(.system(size: 14, weight: .semibold))
                Text(homeViewModel.computeRidePrice(forType: rideType).toCurrency())
                  .font(.system(size: 14, weight: .semibold))
              }
              .padding()
            }
            .frame(width: 112, height: 140)
            .foregroundColor(rideType == selectedRideType ? .white : Color.theme.primaryTextColor)
            .background(rideType == selectedRideType ? .blue : Color.theme.secondaryBackgroundColor)
            .scaleEffect(rideType == selectedRideType ? 1.2 : 1.0)
            .cornerRadius(10)
            .onTapGesture {
              withAnimation(.spring()) {
                selectedRideType = rideType
              }
            }
          }
        }
      }
      .padding(.horizontal)

      Divider()
        .padding(.vertical, 8)

      HStack(spacing: 12) {
        Text("Visa")
          .font(.subheadline)
          .fontWeight(.semibold)
          .padding(6)
          .background(.blue)
          .cornerRadius(4)
          .foregroundColor(.white)
          .padding(.leading)

        Text("**** 1234")
          .fontWeight( /*@START_MENU_TOKEN@*/.bold /*@END_MENU_TOKEN@*/)

        Spacer()

        Image(systemName: "chevron.right")
          .imageScale( /*@START_MENU_TOKEN@*/.medium /*@END_MENU_TOKEN@*/)
          .padding()
      }.frame(height: 50)
        .background(Color.theme.secondaryBackgroundColor)
        .cornerRadius(10)
        .padding(.horizontal)

      Button {
          homeViewModel.requestTrip()
      } label: {
        Text("CONFIRM RIDE")
          .fontWeight( /*@START_MENU_TOKEN@*/.bold /*@END_MENU_TOKEN@*/)
          .frame(width: UIScreen.main.bounds.width - 32, height: 50)
          .background(.blue)
          .cornerRadius(10)
          .foregroundColor(.white)
      }
    }
    .padding(.bottom, 24)
    .background(Color.theme.backgroundColor)
    .cornerRadius(16)
  }
}

#Preview {
  RideRequestView()
}
