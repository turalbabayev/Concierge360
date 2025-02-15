//
//  HomeContentViewModel.swift
//  Concierge360
//
//  Created by Tural Babayev on 8.02.2025.
//

import SwiftUI

class HomeContentViewModel: ObservableObject {
    @Published var selectedServiceCategory: ServiceCategory = .all
    @Published var filteredServices: [Services] = []
    @Published var searchText: String = ""
    @Published var isTextFieldFocused: Bool = false
    
    // Örnek servis verileri
    private let allServices = Services.sampleServices
    
    init() {
        filterServices()
    }
    
    func selectCategory(_ category: ServiceCategory) {
        withAnimation {
            selectedServiceCategory = category
            filterServices()
        }
    }
    
    func filterServices() {
        let services = if selectedServiceCategory == .all {
            // All kategorisi için rastgele 3 servis seç
            allServices.shuffled().prefix(3)
        } else {
            // Belirli kategori için filtreleme
            allServices.filter { $0.category == selectedServiceCategory }.prefix(3)
        }
        
        // Servisleri ata
        filteredServices = Array(services)
    }
    
    // Yeni fonksiyonlar
    func handleSearchTap() {
        print("Search tapped")
    }
    
    func handleSettingsTap() {
        print("Settings tapped")
    }
    
    func handleHotelChange() {
        print("Hotel change tapped")
    }
    
    func handleSeeAllServices() {
        print("See All Services tapped")
    }
}
