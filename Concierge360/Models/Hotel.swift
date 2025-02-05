//
//  Hotels.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

struct Hotel: Identifiable, Hashable {
    var id: UUID = .init()
    var logo: String = ""
    var title: String = ""
    var frame: CGRect = .zero
    
    func toString() -> String {
        return title
    }
}

var hotelList: [Hotel] = [
    .init(logo: "sayebangold", title: "Sayeban Gold Hotel"),
    .init(logo: "dreambosphorus", title: "Dream Bosphorus Hotel"),
    .init(logo: "erk", title: "Erk Hotel")
]
