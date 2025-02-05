//
//  LoginView.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var hotelManager: HotelManager
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var viewModel: LoginViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init() {
        self._viewModel = StateObject(wrappedValue: LoginViewModel())
    }
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
            
            VStack{
                Spacer()
                
                CustomNavigationBar()
                
                Text("Concierge360")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(height: 600)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(radius: 10)
                                        
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Enter your details below for the\n\(hotelManager.selectedHotel?.title ?? "Selected Hotel")")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Email Address")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("Email", text: $viewModel.email)
                                    .foregroundStyle(.black)
                                    .focused($isTextFieldFocused)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                HStack {
                                    if viewModel.isPasswordVisible {
                                        TextField("", text: $viewModel.password)
                                            .focused($isTextFieldFocused)
                                            .foregroundStyle(.black)
                                    } else {
                                        SecureField("", text: $viewModel.password)
                                            .focused($isTextFieldFocused)
                                            .foregroundStyle(.black)

                                    }
                                    Button(action: {
                                        viewModel.isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            }
                            
                            Button(action: {
                                Task {
                                    await viewModel.loginAsManager(using: authManager)
                                }
                            }) {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Text("Sign in")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            .disabled(viewModel.isLoading)
                            
                            if let error = authManager.authError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .padding(.top, 10)
                            }
                            
                            Text("Forgot your password?")
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                            
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.gray.opacity(0.3))
                                Text("Or")
                                    .foregroundColor(.gray)
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.gray.opacity(0.3))
                            }
                            .padding(.vertical, 5)
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    print("Google login tapped")
                                }) {
                                    HStack {
                                        Image(systemName: "globe")
                                        Text("Google")
                                    }
                                    .frame(width: 140, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                }
                                
                                Button(action: {
                                    print("Facebook login tapped")
                                }) {
                                    HStack {
                                        Image(systemName: "f.square.fill")
                                        Text("Facebook")
                                    }
                                    .frame(width: 140, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                }
                            }
                            
                            //Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                .frame(height: 600)                           // Limit the height
                .clipShape(RoundedRectangle(cornerRadius: 30)) // Clip to the same shape
                .shadow(radius: 10)
            }
            .edgesIgnoringSafeArea(.all)

            // Başarılı login sonrası HomeView'a yönlendirme
            NavigationLink(destination: HomeView(), isActive: $viewModel.navigateToHome) {
                EmptyView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
