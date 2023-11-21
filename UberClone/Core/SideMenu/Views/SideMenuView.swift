//
//  SideMenuView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/15/23.
//

import SwiftUI

struct SideMenuView: View {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 32) {
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
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Do more with your account")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "dollarsign.square")
                                .font(.title2)
                                .imageScale(.medium)
                            
                            Text("Make Money Driving")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(6)
                            
                        }
                    }
                    
                    Rectangle()
                        .frame(width: 296, height: 0.75)
                        .opacity(0.7)
                        .foregroundColor(Color(.separator))
                        .shadow(color: .black.opacity(0.7), radius: 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                
                VStack {
                    ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                        NavigationLink(value: viewModel) { SideMenuOptionView(viewModel: viewModel)
                            .padding() }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                    Text(viewModel.title)
                    
                }
                Spacer()

            }
            .padding(.top, 32)
    }
}

#Preview {
    SideMenuView(user: User(fullName: "John Doe", email: "johndoe@gmail.com", uid: "1234567"))
}