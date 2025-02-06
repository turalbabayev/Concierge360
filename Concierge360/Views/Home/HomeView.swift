//
//  SwiftUIView.swift
//  Concierge360
//
//  Created by Tural Babayev on 5.02.2025.
//

import SwiftUI

struct HomeView : View {
    @State private var selectedTab: TabIcon = .Home
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var hotelManager: HotelManager
    @State private var showGetStartedAlert = true

    var body: some View {
        ZStack {
            switch selectedTab {
            case .Home:
                HomeContentView()
            case .bell:
                Text("Sonra Guncellenecek")
            case .message:
                Text("message")
            case .like:
                Text("private")
            case .person:
                if authManager.currentRole == .manager {
                    Text("person") // Yönetici profil sayfası
                } else {
                    CustomAlert(show: $showGetStartedAlert, icon: .error, text: "Access Denied", circleAColor: .red, details: "You must be login as manager.")
                }
            }
            
            ContentView(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}


/*
#Preview {
    NavigationView {
        HomeView()
            .environmentObject(AuthenticationManager())
            .environmentObject(HotelManager())
    }
}
 */


/*
 struct HomeView: View {
     @EnvironmentObject var authManager: AuthenticationManager
     @EnvironmentObject var hotelManager: HotelManager
     @State private var shouldNavigateToRoot = false
     
     var body: some View {
         VStack {
             CustomNavigationBar(title: "Home View",rightButton: NavigationBarButton(
                 title: "Log out",
                 action: {
                     authManager.logout()
                     hotelManager.selectedHotel = nil // Hotel seçimini de temizleyelim
                     shouldNavigateToRoot = true
                 }
             ))

             // Üst kısım - Header
             VStack(alignment: .leading, spacing: 10) {
                 HStack {
                     VStack(alignment: .leading) {
                         Text("Welcome to")
                             .font(.title2)
                         Text(hotelManager.selectedHotel?.title ?? "Hotel")
                             .font(.title)
                             .fontWeight(.bold)
                     }
                     Spacer()
                     
                     // Kullanıcı rolü göstergesi
                     Text(authManager.currentRole == .manager ? "Manager Access" : "Guest Access")
                         .font(.caption)
                         .padding(.horizontal, 12)
                         .padding(.vertical, 6)
                         .background(
                             authManager.currentRole == .manager ?
                                 Color.blue.opacity(0.2) :
                                 Color.green.opacity(0.2)
                         )
                         .foregroundColor(
                             authManager.currentRole == .manager ?
                                 Color.blue :
                                 Color.green
                         )
                         .cornerRadius(8)
                 }
                 .padding()
                 
                 if authManager.currentRole == .manager {
                     Text("You have manager privileges")
                         .font(.subheadline)
                         .foregroundColor(.gray)
                         .padding(.horizontal)
                 }
             }
             .background(Color.white)
             .shadow(radius: 2)
             
             // İçerik alanı
             ScrollView {
                 VStack(spacing: 20) {
                     // Yönetici özel içeriği
                     if authManager.currentRole == .manager {
                         managerContent
                     }
                     
                     // Genel içerik
                     commonContent
                 }
                 .padding()
             }
             
             Spacer()
         }
         .navigationBarBackButtonHidden(true)
         .navigationDestination(isPresented: $shouldNavigateToRoot) {
             OnboardingView()
                 .navigationBarBackButtonHidden(true)
         }
     }
     
     // Yönetici özel içeriği
     private var managerContent: some View {
         VStack(spacing: 15) {
             Text("Manager Dashboard")
                 .font(.headline)
                 .frame(maxWidth: .infinity, alignment: .leading)
             
             HStack(spacing: 15) {
                 dashboardItem(title: "Bookings", icon: "calendar", count: "12")
                 dashboardItem(title: "Staff", icon: "person.2", count: "8")
             }
             
             HStack(spacing: 15) {
                 dashboardItem(title: "Reports", icon: "chart.bar", count: "5")
                 dashboardItem(title: "Settings", icon: "gear", count: nil)
             }
         }
     }
     
     // Genel içerik
     private var commonContent: some View {
         VStack(spacing: 15) {
             Text("Hotel Services")
                 .font(.headline)
                 .frame(maxWidth: .infinity, alignment: .leading)
             
             HStack(spacing: 15) {
                 serviceItem(title: "Room Service", icon: "bed.double")
                 serviceItem(title: "Restaurant", icon: "fork.knife")
             }
             
             HStack(spacing: 15) {
                 serviceItem(title: "Spa", icon: "sparkles")
                 serviceItem(title: "Activities", icon: "figure.run")
             }
         }
     }
     
     // Dashboard öğesi görünümü
     private func dashboardItem(title: String, icon: String, count: String?) -> some View {
         VStack {
             Image(systemName: icon)
                 .font(.title2)
                 .foregroundColor(.blue)
             
             Text(title)
                 .font(.caption)
                 .foregroundColor(.gray)
             
             if let count = count {
                 Text(count)
                     .font(.title3)
                     .fontWeight(.bold)
             }
         }
         .frame(maxWidth: .infinity)
         .padding()
         .background(Color.white)
         .cornerRadius(10)
         .shadow(radius: 2)
     }
     
     // Servis öğesi görünümü
     private func serviceItem(title: String, icon: String) -> some View {
         VStack {
             Image(systemName: icon)
                 .font(.title2)
                 .foregroundColor(.purple)
             
             Text(title)
                 .font(.caption)
                 .foregroundColor(.gray)
         }
         .frame(maxWidth: .infinity)
         .padding()
         .background(Color.white)
         .cornerRadius(10)
         .shadow(radius: 2)
     }
 }
 */
