//
//  AcceptTripView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/30/23.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
    @State private var cameraPosition =  MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)))
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        
        
        self.cameraPosition =          MapCameraPosition.region( MKCoordinateRegion(center: center, span: span))
    }
    
    var body: some View {
        VStack {
            Capsule()
              .foregroundColor(Color(.systemGray5))
              .frame(width: 48, height: 6)
              .padding(.top, 8)
            
            VStack {
                HStack {
                    Text("Woulf you like to pick up this passenger")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: 44)
                    
                    Spacer()
                    
                    VStack {
                        Text("10")
                        Text("min")
                            .bold()
                    }
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                }
                .padding()
                
                Divider()
                
            }
            
            VStack {
                HStack {
                    Image("male-profile-photo-2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("STEPHAN")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(.systemYellow))
                                .imageScale(.small)
                            
                            Text("4.8")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("Earnings")
                        Text("$22.04")
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                
                Divider()
            }
            .padding()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Apple Campus")
                            .font(.headline)
                        Text("Infinite Loop 1, Santa Clara County")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack {
                        Text("5.2")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("mi")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Map(position: $cameraPosition, bounds: nil, interactionModes: .all, scope: nil)
                    .frame(height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.6), radius: 10)
                    .padding()
                Divider()
            }
            HStack {
                Button{
                    
                } label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemRed))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button{
                } label: {
                    Text("Accept")
                        .font(.headline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

#Preview {
    AcceptTripView()
}
