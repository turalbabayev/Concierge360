//
//  ServiceCards.swift
//  Concierge360
//
//  Created by Tural Babayev on 6.02.2025.
//

import SwiftUI

struct ServiceCards:Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

var serviceCards: [ServiceCards] = [
    .init(title: "Transfer", subTitle: "Okyanus Turizm", image: "transfer"),
    .init(title: "Taksi", subTitle: "Okyanus Turizm", image: "taxi"),
    .init(title: "Ozel sofer", subTitle: "Okyanus Turizm", image: "sayebangold")
]
