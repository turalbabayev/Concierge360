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
            ScrollView {
                VStack {
                    HeaderView(viewModel: viewModel)
                    HotelChangeView(viewModel: viewModel)
                    PopularToursSection()
                    ServicesSection(viewModel: viewModel)
                }
            }
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
    
    var body: some View {
        HStack(spacing: 12) {
            LocationIcon()
            ChangeHotelText()
            Spacer()
            ChevronIcon()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .onTapGesture {
            viewModel.handleHotelChange()
        }
    }
}

// MARK: - Popular Tours Section
private struct PopularToursSection: View {
    var body: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Most Popular Tours", action: {
                print("See All Tours tapped")
            })
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tourList) { card in
                        NavigationLink(destination: LoginView()) {
                            TourCardView(card: card)
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
        VStack(spacing: 10) {
            SectionHeader(title: "Our Services", action: viewModel.handleSeeAllServices)
            
            CategorySelector(viewModel: viewModel)
            
            ServicesList(viewModel: viewModel)
            
        }
    }
}

// MARK: - Reusable Components
private struct SectionHeader: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.black)
                .bold()
            Spacer()
            Button(action: action) {
                Text("See All")
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 20)
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
            .lineLimit(2)
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
    }
}

private struct ServicesList: View {
    @ObservedObject var viewModel: HomeContentViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredServices) { service in
                    ServiceRow(service: service)
                        .padding(.horizontal)
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    HomeContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(HotelManager())
}
