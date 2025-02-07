//
//  Tour.swift
//  Concierge360
//
//  Created by Tural Babayev on 7.02.2025.
//

import SwiftUI

struct Tour:Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var duration: String
    var price: String
    var image: String
    var rating: Double
}


var tourList: [Tour] = [
    .init(title: "The Horizon Retreat", duration: "3 Hours", price: "From/$100", image: "buta-vip", rating: 4.5),
    .init(title: "Panorama of the Bosporus", duration: "3 Hours", price: "From/$30", image: "Panorama of the Bosporus", rating: 4.5),
    .init(title: "Panoramıc Istanbul", duration: "3 Hours", price: "From/$90", image: "Panoramıc Istanbul", rating: 4.5),
]
