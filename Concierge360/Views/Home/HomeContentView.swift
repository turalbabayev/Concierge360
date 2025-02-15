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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    HeaderView(viewModel: viewModel)
                        .padding(.top, 10)
                    
                    HotelChangeView(viewModel: viewModel)
                    
                    PopularToursSection()
                    
                    ServicesSection(viewModel: viewModel)
                    
                    NearPlacesSection()
                    
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 50)
                }
            }
            .scrollIndicators(.hidden)
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Header View
private struct HeaderView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var hotelManager: HotelManager
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        HStack {
            HotelProfileSection()
            Spacer()
            ActionButtonsSection(viewModel: viewModel)
        }
        .padding(.horizontal, 20)
    }
}

private struct HotelProfileSection: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var hotelManager: HotelManager
    
    var body: some View {
        HStack {
            ProfileImageView()
            VStack(alignment: .leading) {
                Text(authManager.currentRole == .manager ? "Manager Access" : "Guest")
                    .font(.caption)
                Text(hotelManager.selectedHotel?.toString() ?? "Sayeban Gold Hotel")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

private struct ProfileImageView: View {
    @EnvironmentObject var hotelManager: HotelManager
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 40, height: 40)
                .overlay {
                    Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1)
                }
            Image(hotelManager.selectedHotel?.logo ?? "sayebangold")
                .resizable()
                .scaledToFill()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .foregroundStyle(.black)
        }
    }
}

// MARK: - Hotel Change View
private struct HotelChangeView: View {
    @ObservedObject var viewModel: HomeContentViewModel
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationLink(destination: HotelSelectionView(
            destinationType: authManager.currentRole == .manager ? .managerLogin : .guestHome
        )) {
            HStack(spacing: 12) {
                LocationIcon()
                ChangeHotelText()
                Spacer()
                ChevronIcon()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Color.mainColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

// MARK: - Popular Tours Section
private struct PopularToursSection: View {
    var body: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Most Popular Tours", destination: .tours, destionationText: "See All")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tourList) { tour in
                        NavigationLink(destination: TourDetailView(tour: tour)) {
                            TourCardView(card: tour)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Services Section
private struct ServicesSection: View {
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            SectionHeader(title: "Our Services", destination: .services, destionationText: "See All")
            
            CategorySelector(viewModel: viewModel)
            
            ServicesList(viewModel: viewModel)
        }
    }
}

// MARK: - Near Places Section
private struct NearPlacesSection: View {
    var body: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Places Near You", destination: .tours, destionationText: "Open Map")
            
            GeometryReader { geometry in
                Image("nearyou")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 40) // ekran genişliğinden 40pt padding çıkarıyoruz
                    .frame(height: 180) // sabit height veya dinamik yapabilirsiniz
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
            }
            .frame(height: 180) // GeometryReader için height
            .padding(.bottom, 20)

        }
    }
}

// MARK: - Reusable Components
private struct SectionHeader: View {
    let title: String
    let destination: SeeAllDestination
    let destionationText: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.black)
                .bold()
            Spacer()
            NavigationLink(destination: destinationView) {
                Text(destionationText)
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch destination {
        case .tours:
            ToursView() // ToursView'a yönlendirme
        case .services:
            Text("All Services View") // Şimdilik bekletiyoruz
        }
    }
}

// Enum'u güncelleyelim
enum SeeAllDestination {
    case tours
    case services
}

struct ServiceRow: View {
    var service: Services
    
    var body: some View {
        NavigationLink(destination: ServiceBookingView(service: service)) {
            HStack(spacing: 12) {
                // Sol taraftaki resim
                Image(service.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)

                // Orta kısım - Bilgiler
                VStack(alignment: .leading, spacing: 6) {
                    Text(service.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    
                    // Rating ve fiyat bilgisi
                    HStack(spacing: 12) {
                        // Rating
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            Text(String(format: "%.1f", service.rating))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.yellow.opacity(0.15))
                        .clipShape(Capsule())
                        
                        // Fiyat
                        HStack(spacing: 2) {
                            Text("$\(service.price)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.mainColor)
                            Text("/one way")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Özellikler
                    HStack(spacing: 8) {
                        FeatureTag(text: "24/7")
                        FeatureTag(text: "Free Wifi")
                    }
                }
                
                Spacer()
                
                // Sağ taraf - Ok işareti
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
            )
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// Özellik tag'i için yardımcı view
private struct FeatureTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.gray)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.1))
            .clipShape(Capsule())
    }
}

// MARK: - Action Buttons Section
private struct ActionButtonsSection: View {
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            ActionButton(icon: "magnifyingglass", action: viewModel.handleSearchTap)
            ActionButton(icon: "gearshape", action: viewModel.handleSettingsTap)
        }
    }
}

private struct ActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    }
                Image(systemName: icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
    }
}

// MARK: - Hotel Change Components
private struct LocationIcon: View {
    var body: some View {
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
    }
}

private struct ChangeHotelText: View {
    var body: some View {
        Text("You Can Change Your Hotel to different hotel.")
            .font(.system(size: 13, weight: .light))
            .foregroundColor(.black)
            .lineLimit(1)
    }
}

private struct ChevronIcon: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.black.opacity(0.7))
    }
}

// MARK: - Services Components
private struct CategorySelector: View {
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ServiceCategory.allCases) { category in
                    CategoryButton(
                        category: category,
                        isSelected: viewModel.selectedServiceCategory == category,
                        action: { viewModel.selectCategory(category) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
}

private struct CategoryButton: View {
    let category: ServiceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .padding(.horizontal, 15)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.mainColor : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .black)
                .font(.system(size: 15))
        }
    }
}

private struct ServicesList: View {
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredServices) { service in
                ServiceRow(service: service)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 8)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.selectedServiceCategory)
    }
}

#Preview {
    HomeContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
