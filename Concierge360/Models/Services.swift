//
//  Services.swift
//  Concierge360
//
//  Created by Tural Babayev on 8.02.2025.
//

import SwiftUI

struct Services: Identifiable {
    let id = UUID()
    let name: String
    let location: String? = "Istanbul"
    let price: Int
    let rating: Double
    let category: ServiceCategory
    let imageName: String
    let vehicleType: VehicleType
    let maxPassengers: Int
    let features: [String]
    
    enum VehicleType: String {
        case vip = "VIP"
        case standard = "Standard"
        case airport = "Airport"
    }
}

enum ServiceCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case taxi = "Taxi Services"
    case transfer = "Transfer Services"
    
    var title: String { rawValue }
    var id: String { rawValue }
}

// HomeContentViewModel'deki örnek verileri güncelleyelim
extension Services {
    static let sampleServices = [
        // VIP Transfer
        Services(
            name: "VIP Airport Transfer",
            price: 50,
            rating: 4.8,
            category: .transfer,
            imageName: "transfer",
            vehicleType: .vip,
            maxPassengers: 4,
            features: ["Meet & Greet", "Flight Tracking", "Free Waiting Time"]
        ),
        
        // Airport Taxi
        Services(
            name: "Airport Taxi",
            price: 30,
            rating: 4.5,
            category: .taxi,
            imageName: "taxi",
            vehicleType: .airport,
            maxPassengers: 4,
            features: ["Metered Price", "Flight Tracking", "24/7 Service"]
        ),
        
        // City Taxi
        Services(
            name: "City Taxi",
            price: 20,
            rating: 4.3,
            category: .taxi,
            imageName: "taxi",
            vehicleType: .standard,
            maxPassengers: 4,
            features: ["Metered Price", "Local Driver", "24/7 Service"]
        )
    ]
}



