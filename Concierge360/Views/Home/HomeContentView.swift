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
    @StateObject private var viewModel = HomeContentViewModel()
    @State private var shouldNavigateToRoot = false
    @State private var searchText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    HStack{
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
                            VStack(alignment: .leading){
                                Text(authManager.currentRole == .manager ? "Manager Access" : "Guest")
                                    .font(.caption)
                                Text(hotelManager.selectedHotel?.toString() ?? "Sayeban Gold Hotel")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        HStack(spacing:5){
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1) // İnce sınır çizgisi

                                    }
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.black.opacity(0.6))
                            }
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
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                        }
                        .onTapGesture {
                            print("tiklandi")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                                                    
                    //CustomCarousel()
                    
                    HStack(spacing: 12) {
                        // Konum İkonu (Mavi Daire İçinde)
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                            
                            Image("location")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(.blue)
                        }
                        
                        // Metin Alanı
                        VStack(alignment: .leading, spacing: 2) {
                            Text("You Can Change Your Hotel to different hotel.")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(.black)
                        }
                        .lineLimit(2)
                        
                        Spacer()
                        
                        // Sağ Ok İkonu
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.blue.opacity(0.1)) // Açık mavi arka plan
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 16) // Ekran kenar boşluğu
                    .padding(.vertical, 16)
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Most Popular Tours")
                                .foregroundStyle(.black)
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                print("See All Tiklandi")
                            } label: {
                                Text("See All")
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(tourList) { card in
                                    NavigationLink(destination: LoginView()) {
                                        TourCardView(card: card) // 🔹 Burada artık iç içe kod kalmadı!
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        //.frame(height: 220)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    }

                    //Spacer()
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Our Services")
                                .foregroundStyle(.black)
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                print("tiklandi")
                            } label: {
                                Text("See All")
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(ServiceCategory.allCases) { category in
                                    Button(action: {
                                        viewModel.selectCategory(category)
                                    }) {
                                        Text(category.rawValue)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 8)
                                            .background(viewModel.selectedServiceCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(viewModel.selectedServiceCategory == category ? .white : .black)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                                                
                        // Servis listesi
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(viewModel.filteredServices) { service in
                                    ServiceRow(service: service)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .frame(height: 300) // Sabit bir yükseklik verdik
                    }
                    
                }
            }
            .preferredColorScheme(.light)
            .onTapGesture {
                isTextFieldFocused = false
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
}

struct ServiceRow: View {
    var service: Services
    
    var body: some View {
        HStack {
            Image(service.imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(service.name)
                    .font(.headline)
                HStack {
                    Text("$\(service.price)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("/night")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", service.rating))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HomeContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
