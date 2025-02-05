//
//  HotelManager.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

class HotelManager: ObservableObject {
    @Published var selectedHotel: Hotel?
    @Published var filteredHotels: [Hotel] = hotelList
    @Published var searchText: String = ""
    
    func filterHotels(with searchText: String) {
        if searchText.isEmpty {
            filteredHotels = hotelList
        } else {
            filteredHotels = hotelList.filter { hotel in
                hotel.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
