//
//  Concierge360App.swift
//  Concierge360
//
//  Created by Tural Babayev on 2.02.2025.
//

import SwiftUI

@main
struct Concierge360App: App {
    @StateObject private var hotelManager = HotelManager()
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .preferredColorScheme(.light) // Light mode'u zorla
                .environmentObject(hotelManager)
                .environmentObject(authManager)
                .onAppear {
                    authManager.loadSavedRole()
                }
        }
    }
}
