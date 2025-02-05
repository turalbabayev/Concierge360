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
    @State private var showSearch: Bool = false
    @FocusState private var isSearchFieldFocused: Bool

    
    var body: some View {
        VStack {
            Spacer()
            
            CustomNavigationBar(title: "Hotel Selection")
            
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
                
                VStack {
                    SearchField(show: $showSearch, text: $hotelManager.searchText)
                        .padding(.top, 20)
                        .onChange(of: hotelManager.searchText) {
                            hotelManager.filterHotels(with: hotelManager.searchText)
                        }
                        .focused($isSearchFieldFocused)
                    
                    if hotelManager.filteredHotels.isEmpty {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No hotels found")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Try a different search term")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(hotelManager.filteredHotels) { hotel in
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
                .frame(height: 600)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
        )
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            isSearchFieldFocused = false
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
        HStack(spacing: 16) {
            // Sol taraftaki resim container'ı
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Image(hotel.logo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
            
            // Otel bilgileri
            VStack(alignment: .leading, spacing: 4) {
                Text(hotel.title)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text("5 Star Hotel")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // Sağ taraftaki ok işareti
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    HotelSelectionView(destinationType: .managerLogin)
}
