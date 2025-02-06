//
//  OnboardingView.swift
//  Concierge360
//
//  Created by Tural Babayev on 2.02.2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var hotelManager: HotelManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Concierge360")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(Color.white.opacity(0.6))
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(Color.white.opacity(1))
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    .padding(.top, 8)
                    
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
                        
                        VStack(spacing: 20) {
                            Image("OnboardingIllustration")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .foregroundColor(Color.purple.opacity(0.8))
                                .padding(.top, 30)
                            
                            Text("Concierge360 Enterprise")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("Transformative collaboration for larger teams")
                                .font(.system(size: 20, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal, 40)
                            
                            VStack(spacing: 15){
                                NavigationLink(destination: HotelSelectionView(destinationType: .managerLogin)) {
                                    Text("Manager Login")
                                }
                                .buttonStyle(GradientButtonStyle())
                                
                                NavigationLink(destination: HotelSelectionView(destinationType: .guestHome)) {
                                    Text("Guest Login")
                                }
                                .buttonStyle(GradientButtonStyle())
                                .simultaneousGesture(TapGesture().onEnded {
                                    authManager.loginAsGuest()
                                })
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}


#Preview {
    OnboardingView()
}
