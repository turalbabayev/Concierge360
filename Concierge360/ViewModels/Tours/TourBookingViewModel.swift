import Foundation
import SwiftUI

class TourBookingViewModel: ObservableObject {
    let tour: Tour
    private var hotelManager: HotelManager?
    private let calendar = Calendar.current
    
    // Form States
    @Published var fullName = ""
    @Published var numberOfPeople = 1
    @Published var guestNames: [String] = [""]
    @Published var roomNumbers: [String] = [""]
    @Published var selectedDate: Date
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showingErrors = false
    @Published var showBookingConfirmation = false
    @Published var selectedSession: TourSession? // Seçilen seans
    
    init(tour: Tour) {
        self.tour = tour
        self.selectedDate = Self.findFirstAvailableDate(for: tour)
        // Varsayılan olarak ilk seansı seç
        self.selectedSession = tour.schedule?.sessions.first
    }
    
    // İlk müsait tarihi bulan static helper fonksiyon
    private static func findFirstAvailableDate(for tour: Tour) -> Date {
        guard let availableDays = tour.schedule?.availableDays else { return Date() }
        
        let calendar = Calendar.current
        var currentDate = Date()
        
        // Maksimum 30 gün ileriye bakıyoruz
        for dayOffset in 0...30 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            
            let isAvailable = availableDays.contains { day in
                switch day {
                case .sunday: return weekday == 1
                case .monday: return weekday == 2
                case .tuesday: return weekday == 3
                case .wednesday: return weekday == 4
                case .thursday: return weekday == 5
                case .friday: return weekday == 6
                case .saturday: return weekday == 7
                }
            }
            
            if isAvailable {
                return date
            }
        }
        
        return currentDate // Eğer müsait tarih bulunamazsa bugünü döndür
    }
    
    func setHotelManager(_ manager: HotelManager) {
        self.hotelManager = manager
    }
    
    // MARK: - Computed Properties
    var totalPrice: String {
        if let priceValue = Double(tour.price.replacingOccurrences(of: "$", with: "")) {
            let total = priceValue * Double(numberOfPeople)
            return String(format: "$%.2f", total)
        }
        return tour.price
    }
    
    var availableDates: [Date] {
        guard let availableDays = tour.schedule?.availableDays else { return [] }
        
        var dates: [Date] = []
        
        for dayOffset in 0...30 {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
            let weekday = calendar.component(.weekday, from: date)
            
            let isAvailable = availableDays.contains { day in
                switch day {
                case .sunday: return weekday == 1
                case .monday: return weekday == 2
                case .tuesday: return weekday == 3
                case .wednesday: return weekday == 4
                case .thursday: return weekday == 5
                case .friday: return weekday == 6
                case .saturday: return weekday == 7
                }
            }
            
            if isAvailable {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    // MARK: - Form Validation
    var isFormValid: Bool {
        let isBasicInfoValid = !fullName.isEmpty && 
            !roomNumbers.contains(where: { $0.isEmpty }) &&
            !phoneNumber.isEmpty
        
        let areGuestNamesValid = numberOfPeople == 1 || 
            !guestNames.dropFirst().contains(where: { $0.isEmpty })
        
        let isSessionSelected = selectedSession != nil
        
        return isBasicInfoValid && areGuestNamesValid && isSessionSelected
    }
    
    func validateField(_ text: String) -> Bool {
        !text.isEmpty
    }
    
    func validateForm() {
        showingErrors = true
        
        if fullName.isEmpty {
            showError = true
            errorMessage = "Please enter your full name"
            return
        }
        
        if roomNumbers.contains(where: { $0.isEmpty }) {
            showError = true
            errorMessage = "Please enter your room number"
            return
        }
        
        if phoneNumber.isEmpty {
            showError = true
            errorMessage = "Please enter your phone number"
            return
        }
        
        if numberOfPeople > 1 && guestNames.dropFirst().contains(where: { $0.isEmpty }) {
            showError = true
            errorMessage = "Please enter all guest names"
            return
        }
        
        if selectedSession == nil {
            showError = true
            errorMessage = "Please select a tour time"
            return
        }
    }
    
    // MARK: - Guest Management
    func addGuest() {
        numberOfPeople += 1
        guestNames.append("")
    }
    
    func removeGuest() {
        if numberOfPeople > 1 {
            numberOfPeople -= 1
            guestNames = Array(guestNames.prefix(numberOfPeople))
        }
    }
    
    // MARK: - Date Management
    func isDateAvailable(_ date: Date) -> Bool {
        availableDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    func findNextAvailableDate(from date: Date) -> Date {
        availableDates.first { $0 >= date } ?? availableDates.first ?? date
    }
    
    func backgroundColor(for date: Date, isAvailable: Bool, isSelected: Bool, isToday: Bool) -> Color {
        if isSelected {
            return Color.mainColor
        } else if date < Date() {
            return Color.gray.opacity(0.1)
        } else if isAvailable {
            return Color.green.opacity(0.2)
        } else {
            return Color.red.opacity(0.1)
        }
    }
    
    func textColor(isSelected: Bool, isAvailable: Bool) -> Color {
        if isSelected {
            return .white
        } else if !isAvailable {
            return .gray
        }
        return .primary
    }
    
    var bookingDetails: BookingDetails {
        let sessionTimeText: String
        if let session = selectedSession {
            if let title = session.title {
                sessionTimeText = "\(title) (\(session.startTime) - \(session.endTime))"
            } else {
                sessionTimeText = "\(session.startTime) - \(session.endTime)"
            }
        } else {
            sessionTimeText = "Not selected"
        }
        
        return BookingDetails(
            tourName: tour.title,
            date: selectedDate.formatted(date: .long, time: .omitted),
            numberOfPeople: numberOfPeople,
            totalPrice: totalPrice,
            sessionTime: sessionTimeText
        )
    }
    
    // MARK: - Booking Actions
    func completeBooking() {
        // Eğer seçili tarih müsait değilse, ilk müsait tarihe otomatik geç
        if !isDateAvailable(selectedDate) {
            selectedDate = Self.findFirstAvailableDate(for: tour)
        }
        
        // Tüm rezervasyon bilgilerini yazdıralım
        print("\n=== TOUR BOOKING DETAILS ===")
        print("Tour Name: \(tour.title)")
        print("Tour Price: \(tour.price)")
        print("\n--- Customer Information ---")
        print("Full Name: \(fullName)")
        print("Email: \(email)")
        print("Phone: \(phoneNumber)")
        print("\n--- Booking Details ---")
        print("Selected Date: \(selectedDate.formatted(date: .long, time: .omitted))")
        print("Number of People: \(numberOfPeople)")
        print("Room Number: \(roomNumbers[0])")
        
        if numberOfPeople > 1 {
            print("\n--- Additional Guests ---")
            for (index, name) in guestNames.enumerated() where index > 0 {
                print("Guest \(index + 1): \(name)")
            }
        }
        
        print("\n--- Hotel Information ---")
        print("Hotel Name: \(hotelManager?.selectedHotel?.title ?? "Unknown")")
        
        print("\nTotal Price: \(totalPrice)")
        print("============================\n")
        
        // Booking confirmation alert'ını göster
        showBookingConfirmation = true
    }
} 