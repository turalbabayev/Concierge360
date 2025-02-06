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
    
    var body: some View {
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
                    Text(authManager.currentRole == .manager ? "Manager Access" : "Guest Access")
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
        }
        .navigationBarBackButtonHidden(true)
        //.navigationDestination(isPresented: $shouldNavigateToRoot) {
            //OnboardingView()
                //.navigationBarBackButtonHidden(true)
        //}

    }
}

#Preview {
    HomeContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
