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
    
    // Örnek servis verileri
    private let allServices: [Services] = [
        Services(name: "VIP Transfer", price: 50, rating: 4.8, category: .transfer, imageName: "transfer"),
        Services(name: "Airport Transfer", price: 30, rating: 4.5, category: .transfer, imageName: "transfer"),
        Services(name: "Business Transfer", price: 40, rating: 4.7, category: .transfer, imageName: "transfer"),
        Services(name: "Luxury Transfer", price: 60, rating: 4.9, category: .transfer, imageName: "transfer"),
        
        Services(name: "City Taxi", price: 20, rating: 4.3, category: .taxi, imageName: "taxi"),
        Services(name: "Premium Taxi", price: 25, rating: 4.6, category: .taxi, imageName: "taxi"),
        Services(name: "24/7 Taxi", price: 22, rating: 4.4, category: .taxi, imageName: "taxi"),
        Services(name: "Express Taxi", price: 28, rating: 4.5, category: .taxi, imageName: "taxi")
    ]

    init() {
        filterServices()
    }
    
    func selectCategory(_ category: ServiceCategory) {
        selectedServiceCategory = category
        filterServices()
    }
    
    func filterServices() {
        let services = if selectedServiceCategory == .all {
            allServices // Tüm servisler
        } else {
            allServices.filter { $0.category == selectedServiceCategory } // Kategori bazlı servisler
        }
        
        // Her durumda sadece ilk 3 servisi al
        filteredServices = Array(services.prefix(3))
    }
}
