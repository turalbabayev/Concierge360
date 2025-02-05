//
//  HotelView.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

enum HotelSelectionDestination {
    case managerLogin
    case guestHome
}

struct HotelSelectionView: View {
    @EnvironmentObject var hotelManager: HotelManager
    let destinationType: HotelSelectionDestination

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
                
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(height: 600)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(radius: 10)
                    
                    HotelView(destinationType: destinationType)
                        .frame(height: 600)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct HotelView: View {
    @EnvironmentObject var hotelManager: HotelManager
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var hotels: [Hotel] = hotelList
    let destinationType: HotelSelectionDestination
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach($hotels) { $hotel in
                    NavigationLink(
                        destination: destinationType == .managerLogin ? 
                            AnyView(LoginView()) : 
                            AnyView(HomeView())
                    ) {
                        HotelItemView(hotel: hotel)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        hotelManager.selectedHotel = hotel
                    })
                }
            }
            .padding(25)
        }
    }
}

struct HotelItemView: View {
    var hotel: Hotel
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: hotel.logo)
                .font(.title3)
            
            Text(hotel.title)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 15)
        .foregroundStyle(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    HotelSelectionView(destinationType: .managerLogin)
}
