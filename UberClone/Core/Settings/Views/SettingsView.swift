//
//  SettingsView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/21/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        Image("male-profile-photo-1")
                            .resizable()
                            .scaledToFill()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullName)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                            
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                }
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(
                                config: viewModel)
                        } label: {
                            SavedLocationRowView(viewModel: viewModel, user: user)
                        }
                    }
                }
                Section("Settings") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "Notifications", tintColor:  Color(.systemPurple))
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "Payment Methods", tintColor:  Color(.systemBlue))
                }
                Section("Account") {
                    SettingsRowView(imageName: "dollarsign.circle.fill", title: "Make Money Driving", tintColor:  Color(.systemGreen))
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out", tintColor:  Color(.systemRed))
                        .onTapGesture {
                            authViewModel.signOut()
                        }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SettingsView(user: User.mockUser)
    }
}
