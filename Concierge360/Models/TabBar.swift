//
//  TabBar.swift
//  Concierge360
//
//  Created by Tural Babayev on 6.02.2025.
//

import SwiftUI

struct TabBar : Identifiable {
    var id = UUID()
    var iconname: String
    var tab : TabIcon
    var index : Int
}

enum TabIcon: String {
    case Home
    case bell
    case message
    case like
    case person
}

let tabItems = [
    TabBar(iconname: "house.fill", tab: .Home, index: 0),
    TabBar(iconname: "bell.fill", tab: .bell, index: 1),
    TabBar(iconname: "message.fill", tab: .message, index: 2),
    TabBar(iconname: "star.fill", tab: .like, index: 3),
    TabBar(iconname: "person.fill", tab: .person, index: 4)
]
