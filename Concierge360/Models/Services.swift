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
}

enum ServiceCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case transfer = "Transfer Service"
    case taxi = "Taxi Service"

    var id: String { self.rawValue }
}



