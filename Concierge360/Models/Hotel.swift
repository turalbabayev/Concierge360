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
    .init(logo: "airplane", title: "Sayeban Gold Hotel"),
    .init(logo: "wifi", title: "Dream Hotel"),
    .init(logo: "personalhotspot", title: "Erk Hotel")
]
