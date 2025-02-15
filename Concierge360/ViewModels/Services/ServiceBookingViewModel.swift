import Foundation
import SwiftUI

class ServiceBookingViewModel: ObservableObject {
    private var hotelManager: HotelManager?
    let service: Services
    
    // Form States
    @Published var fullName = ""
    @Published var numberOfPeople = 1
    @Published var guestNames: [String] = []
    @Published var passportNumbers: [String] = []
    @Published var roomNumber = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var selectedAirport: Airport = .istanbulAirport
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var passportNumber = ""  // Ana misafir için pasaport numarası
    @Published var pickupLocation = ""  // Alış yeri (otel)
    @Published var customerMessage = "" // Müşteri mesajı
    @Published var destinationLocation = "" // Varış noktası için
    @Published var showLocationPicker = false // Harita seçimi için
    
    // Validation States
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showBookingConfirmation = false
    
    enum Airport: String, CaseIterable {
        case istanbulAirport = "Istanbul Airport"
        case sabihaGokcen = "Sabiha Gokcen Airport"
    }
    
    init(service: Services) {
        self.service = service
        self.guestNames = Array(repeating: "", count: 4)
        self.passportNumbers = Array(repeating: "", count: 4)
    }
    
    func setHotelManager(_ manager: HotelManager) {
        self.hotelManager = manager
        // Pickup location'ı otomatik doldur
        if let hotelName = manager.selectedHotel?.title {
            self.pickupLocation = hotelName
        }
    }
    
    var isCityTaxi: Bool {
        service.category == .taxi && service.vehicleType == .standard
    }
    
    var isAirportTaxi: Bool {
        service.category == .taxi && service.vehicleType == .airport
    }
    
    // Validation ve business logic
    var isValidForm: Bool {
        let mainFieldsValid = !fullName.isEmpty &&
        !roomNumber.isEmpty &&
        !phoneNumber.isEmpty
        
        // City Taxi için ek kontrol
        if isCityTaxi {
            return mainFieldsValid && !destinationLocation.isEmpty
        }
        
        // Airport Taxi için
        if isAirportTaxi {
            return mainFieldsValid
        }
        
        // Transfer servisi için ek kontroller
        let passportValid = !passportNumber.isEmpty
        let guestFieldsValid = (1..<numberOfPeople).allSatisfy { index in
            !guestNames[index].isEmpty && !passportNumbers[index].isEmpty
        }
        
        return mainFieldsValid && passportValid && guestFieldsValid
    }
    
    func updateNumberOfPeople(_ count: Int) {
        guard count >= 1 && count <= 4 else { return }
        numberOfPeople = count
    }
    
    var recommendedTimeNote: String {
        if isCityTaxi {
            return "" // City taxi için not yok
        }
        
        switch selectedAirport {
        case .istanbulAirport, .sabihaGokcen:
            return "For international flights, it's recommended to book transfer at least 4 hours before flight time. For domestic flights, 3 hours is recommended."
        }
    }
    
    // Minimum saat için hesaplama
    var minimumTime: Date {
        let calendar = Calendar.current
        let now = Date()
        
        // Eğer seçili tarih bugünse, şu anki saatten başla
        if calendar.isDate(selectedDate, inSameDayAs: now) {
            return now
        }
        
        // Seçili tarih bugünden farklıysa, o günün başlangıcından başla
        return calendar.startOfDay(for: selectedDate)
    }
    
    // Tarih değiştiğinde saati kontrol et ve güncelle
    func validateAndUpdateTime() {
        let calendar = Calendar.current
        let now = Date()
        
        // Eğer seçili tarih bugünse ve seçili saat şu andan önceyse
        if calendar.isDate(selectedDate, inSameDayAs: now) && selectedTime < now {
            selectedTime = now // Saati şu ana güncelle
        }
    }
    
    // Fiyat gösterimi için yeni computed property
    var priceDisplay: String {
        if isAirportTaxi || isCityTaxi {
            return "Metered Price"
        } else {
            return "$\(service.price)"
        }
    }
    
    var priceNote: String {
        if isAirportTaxi || isCityTaxi {
            return "Price will be calculated by taximeter"
        } else {
            return "Up to 4 passengers"
        }
    }
    
    // Daha sonra eklenecek özellikler ve fonksiyonlar
} 