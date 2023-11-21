//
//  LoginView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/10/23.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack {
                    VStack(spacing: -16) {
                        Image("uber-app-icon")
                            .resizable()
                            .frame(width: 200, height: 200)
                        
                        Text("UBER")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                    VStack(spacing: 32) {
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        
                        Button{
                            
                        }
                               label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top)
                               }.frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    
                    VStack {
                        HStack(spacing: 24) {
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                            Text("Sign in with social")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                        
                        HStack(spacing: 24) {
                            Button {
                                
                            } label: {
                                Image("facebook-sign-in-icon")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                            }
             
                            Button {
                                
                            } label: {
                                Image("google-sign-in-icon")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    Button{
                        viewModel.signIn(withEmail: email, password: password)
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    Spacer()

                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Don't have an account")
                                .font(.system(size: 14))
                            Text("Sign up")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
