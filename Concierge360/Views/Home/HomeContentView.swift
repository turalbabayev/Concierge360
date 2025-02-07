//
//  HomeContentView.swift
//  Concierge360
//
//  Created by Tural Babayev on 6.02.2025.
//

import SwiftUI

struct HomeContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var hotelManager: HotelManager
    @State private var shouldNavigateToRoot = false
    @State private var searchText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    
    var body: some View {
        ScrollView {
            VStack {
                HStack{
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .overlay {
                                Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1) // İnce sınır çizgisi

                            }
                        Image(hotelManager.selectedHotel?.logo ?? "sayebangold")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        print("tiklandi")
                    }
                    Spacer()
                    VStack{
                        Text(authManager.currentRole == .manager ? "Manager Access" : "Guest")
                            .font(.caption)
                        Text(hotelManager.selectedHotel?.toString() ?? "Sayeban Gold Hotel")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .overlay {
                                Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1) // İnce sınır çizgisi

                            }
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        print("tiklandi")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                SearchBar()
                                
                CustomCarousel()
                
                Spacer()
            }
        }
        .preferredColorScheme(.light)
        .onTapGesture {
            isTextFieldFocused = false
        }
        .navigationBarBackButtonHidden(true)

    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        VStack(spacing: 10){
            HStack(spacing: 12){
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                
                TextField("Search for hotels", text: $searchText)
                    .focused($isTextFieldFocused)
            }
            .padding(.vertical, 10)
            .padding(.horizontal,15)
            .frame(height: 45)
            .background{
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.25), radius: 8 ,x: 5, y: 10)
            }
        }
        .padding(.horizontal,20)
        .padding(.top, 16)
    }
}

#Preview {
    HomeContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
