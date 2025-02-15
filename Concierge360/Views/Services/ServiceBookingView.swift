import SwiftUI

struct ServiceBookingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var hotelManager: HotelManager
    @StateObject private var viewModel: ServiceBookingViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, roomNumber, phone, email, guestName, passportNumber
    }
    
    init(service: Services) {
        _viewModel = StateObject(wrappedValue: ServiceBookingViewModel(service: service))
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: viewModel.service.name, color: .black)
                .padding(.top, getSafeAreaTop())
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Kişisel Bilgiler
                    FormSection(title: "Personal Information") {
                        VStack(spacing: 20) {
                            ValidatedTextField(
                                title: "Full Name",
                                text: $viewModel.fullName,
                                placeholder: "Enter your full name",
                                isValid: true,
                                errorMessage: "",
                                type: .name
                            )
                            
                            // Pasaport numarası sadece transfer servisi için
                            if !viewModel.isAirportTaxi && !viewModel.isCityTaxi {
                                ValidatedTextField(
                                    title: "Passport Number",
                                    text: $viewModel.passportNumber,
                                    placeholder: "Enter passport number",
                                    isValid: true,
                                    errorMessage: "",
                                    type: .passport
                                )
                            }
                            
                            // Kişi sayısı seçici sadece transfer servisi için
                            if !viewModel.isAirportTaxi && !viewModel.isCityTaxi {
                                PassengerCountSelector(count: $viewModel.numberOfPeople)
                            }
                        }
                    }
                    
                    // Misafir bilgileri sadece transfer servisi için
                    if !viewModel.isAirportTaxi && !viewModel.isCityTaxi && viewModel.numberOfPeople > 1 {
                        ForEach(1..<viewModel.numberOfPeople, id: \.self) { index in
                            FormSection(title: "Guest \(index + 1) Information") {
                                VStack(spacing: 20) {
                                    ValidatedTextField(
                                        title: "Full Name",
                                        text: $viewModel.guestNames[index],
                                        placeholder: "Enter guest name",
                                        isValid: true,
                                        errorMessage: "",
                                        type: .name
                                    )
                                    
                                    ValidatedTextField(
                                        title: "Passport Number",
                                        text: $viewModel.passportNumbers[index],
                                        placeholder: "Enter passport number",
                                        isValid: true,
                                        errorMessage: "",
                                        type: .name
                                    )
                                }
                            }
                        }
                    }
                    
                    // Lokasyon Bilgileri
                    FormSection(title: "Location Information") {
                        VStack(spacing: 20) {
                            // Alış yeri (disabled)
                            ValidatedTextField(
                                title: "Pickup Location",
                                text: $viewModel.pickupLocation,
                                placeholder: "",
                                isValid: true,
                                errorMessage: "",
                                type: .name
                            )
                            .disabled(true)
                            .opacity(0.8)
                            
                            ValidatedTextField(
                                title: "Room Number",
                                text: $viewModel.roomNumber,
                                placeholder: "Enter room number",
                                isValid: true,
                                errorMessage: "",
                                type: .roomNumber
                            )
                            
                            // City Taxi için varış noktası
                            if viewModel.isCityTaxi {
                                DestinationSelector(
                                    destination: $viewModel.destinationLocation,
                                    showMap: $viewModel.showLocationPicker
                                )
                            }
                            
                            // Airport Taxi için havalimanı seçimi
                            if viewModel.isAirportTaxi {
                                AirportSelector(selectedAirport: $viewModel.selectedAirport)
                            }
                        }
                    }
                    
                    // Tarih ve Saat
                    dateAndTimeSection
                    
                    // Müşteri Mesajı
                    MessageSection(message: $viewModel.customerMessage)
                    
                    // İletişim Bilgileri
                    FormSection(title: "Contact Information") {
                        VStack(spacing: 20) {
                            ValidatedTextField(
                                title: "Phone Number",
                                text: $viewModel.phoneNumber,
                                placeholder: "Enter phone number",
                                isValid: true,
                                errorMessage: "",
                                type: .phone
                            )
                            
                            ValidatedTextField(
                                title: "Email (Optional)",
                                text: $viewModel.email,
                                placeholder: "Enter email address",
                                isValid: true,
                                errorMessage: "",
                                type: .email
                            )
                        }
                    }
                    
                    // Fiyat Özeti
                    FormSection(title: "Price Summary") {
                        PriceSummaryView(
                            priceDisplay: viewModel.priceDisplay,
                            note: viewModel.priceNote
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            if !viewModel.isCityTaxi {
                bookingButton
                    .transition(.move(edge: .bottom))
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        .background(Color(uiColor: .systemBackground))
        // Klavyeyi kapatmak için gesture ekleyelim
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                         to: nil, from: nil, for: nil)
        }
        .onAppear {
            // HotelManager'ı viewModel'e aktaralım
            viewModel.setHotelManager(hotelManager)
        }
        .sheet(isPresented: $viewModel.showLocationPicker) {
            LocationPickerView(selectedLocation: $viewModel.destinationLocation)
        }
    }
    
    // Helper views...
    private var bookingButton: some View {
        VStack {
            HStack {
                // Sol taraf - Fiyat
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(viewModel.priceDisplay)
                        .font(.system(size: viewModel.isAirportTaxi ? 18 : 24, weight: .bold))
                        .foregroundColor(viewModel.isAirportTaxi ? .orange : .mainColor)
                    
                    if viewModel.isAirportTaxi {
                        Text("Price will be calculated by taximeter")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Sağ taraf - Buton
                Button(action: {
                    // Rezervasyon işlemi
                }) {
                    Text("Complete Booking")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 16)
                        .background(viewModel.isValidForm ? Color.mainColor : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!viewModel.isValidForm)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }
    
    private func getSafeAreaTop() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets.top
        }
        return 0
    }
    
    private var dateAndTimeSection: some View {
        FormSection(title: "Date & Time") {
            VStack(spacing: 20) {
                DatePicker("Select Date",
                          selection: $viewModel.selectedDate,
                          in: Date()...,
                          displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                DatePicker("Select Time",
                          selection: $viewModel.selectedTime,
                          in: viewModel.minimumTime...,
                          displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
        }
    }
}

// MARK: - Supporting Views
private struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

private struct PassengerCountSelector: View {
    @Binding var count: Int
    
    var body: some View {
        HStack {
            Text("Number of Passengers")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            HStack(spacing: 20) {
                Button(action: { if count > 1 { count -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(count > 1 ? .blue : .gray)
                }
                
                Text("\(count)")
                    .font(.system(size: 16, weight: .medium))
                
                Button(action: { if count < 4 { count += 1 } }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(count < 4 ? .blue : .gray)
                }
            }
        }
    }
}

private struct AirportSelector: View {
    @Binding var selectedAirport: ServiceBookingViewModel.Airport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Airport")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                ForEach(ServiceBookingViewModel.Airport.allCases, id: \.self) { airport in
                    AirportCard(
                        airport: airport,
                        isSelected: selectedAirport == airport,
                        action: { selectedAirport = airport }
                    )
                }
            }
        }
    }
}

private struct AirportCard: View {
    let airport: ServiceBookingViewModel.Airport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .mainColor)
                
                Text(airport.rawValue)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isSelected ? .white : .black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.mainColor : Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

private struct InfoBox: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.orange)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
    }
}

private struct PriceSummaryView: View {
    let priceDisplay: String
    let note: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(priceDisplay)
                    .font(.system(size: 24, weight: .bold))
            }
            
            Spacer()
            
            Text(note)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

// Mesaj bölümünü güncelleyelim
private struct MessageSection: View {
    @Binding var message: String
    
    var body: some View {
        FormSection(title: "Additional Information") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.gray)
                    Text("Message (Optional)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $message)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                
                // Karakter sayacı
                HStack {
                    Spacer()
                    Text("\(message.count)/500")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// Varış noktası seçici
private struct DestinationSelector: View {
    @Binding var destination: String
    @Binding var showMap: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Destination")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            HStack {
                TextField("Enter destination or select from map", text: $destination)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button(action: { showMap = true }) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.mainColor)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

// Harita seçici view (örnek)
private struct LocationPickerView2: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: String
    
    var body: some View {
        NavigationView {
            Text("Map View will be implemented here")
                .navigationTitle("Select Location")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
} 
