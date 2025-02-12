import SwiftUI

struct TourBookingView: View {
    @StateObject private var viewModel: TourBookingViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var hotelManager: HotelManager
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, roomNumber, phone, email, guestName
    }
    
    init(tour: Tour) {
        _viewModel = StateObject(wrappedValue: TourBookingViewModel(tour: tour))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            CustomNavigationBar(
                title: "Book Tour",
                color: .black
            )
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            
            // MARK: - Content
            mainContent
        }
        .overlay(alignment: .bottom) { bottomBar }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            viewModel.setHotelManager(hotelManager)
        }
    }
    
    // MARK: - View Components
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                personalInformationSection
                if viewModel.numberOfPeople > 1 { guestNamesSection }
                hotelInformationSection
                dateSelectionSection
                contactInformationSection
            }
            .padding(20)
            .padding(.bottom, 100)
        }
    }
    
    private var personalInformationSection: some View {
        FormSection(title: "Personal Information") {
            VStack(spacing: 20) {
                ValidatedTextField(
                    title: "Full Name",
                    text: $viewModel.fullName,
                    placeholder: "Enter your full name",
                    isValid: !viewModel.showingErrors || viewModel.validateField(viewModel.fullName),
                    errorMessage: "Full name is required",
                    type: .name
                )
                .focused($focusedField, equals: .fullName)
                
                numberOfPeopleSelector
            }
        }
    }
    
    private var numberOfPeopleSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Number of People")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                Button(action: { 
                    if viewModel.numberOfPeople > 1 {
                        viewModel.numberOfPeople -= 1
                        viewModel.guestNames = Array(viewModel.guestNames.prefix(viewModel.numberOfPeople))
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(viewModel.numberOfPeople > 1 ? .mainColor : .gray)
                        .font(.title2)
                }
                
                Text("\(viewModel.numberOfPeople)")
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 40)
                
                Button(action: { 
                    viewModel.numberOfPeople += 1
                    viewModel.guestNames.append("")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.mainColor)
                        .font(.title2)
                }
                
                Spacer()
            }
        }
    }
    
    private var guestNamesSection: some View {
        FormSection(title: "Guest Names") {
            VStack(spacing: 20) {
                ForEach(1..<viewModel.numberOfPeople, id: \.self) { index in
                    ValidatedTextField(
                        title: "Guest \(index + 1)",
                        text: $viewModel.guestNames[index],
                        placeholder: "Enter guest name",
                        isValid: !viewModel.showingErrors || viewModel.validateField(viewModel.guestNames[index]),
                        errorMessage: "Guest name is required",
                        type: .name
                    )
                    .focused($focusedField, equals: .guestName)
                }
            }
        }
    }
    
    private var hotelInformationSection: some View {
        FormSection(title: "Hotel Information") {
            VStack(spacing: 20) {
                hotelNameField
                roomNumbersField
            }
        }
    }
    
    private var hotelNameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hotel")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(hotelManager.selectedHotel?.title ?? "")
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var roomNumbersField: some View {
        ValidatedTextField(
            title: "Room Number",
            text: $viewModel.roomNumbers[0],
            placeholder: "Enter your room number",
            isValid: !viewModel.showingErrors || viewModel.validateField(viewModel.roomNumbers[0]),
            errorMessage: "Room number is required",
            type: .roomNumber
        )
        .focused($focusedField, equals: .roomNumber)
    }
    
    private var dateSelectionSection: some View {
        FormSection(title: "Tour Date") {
            VStack(alignment: .leading, spacing: 12) {
                // Ay ve Yıl gösterimi + Ay değiştirme butonları
                HStack {
                    Text(viewModel.selectedDate.formatted(.dateTime.month(.wide).year()))
                        .font(.headline)
                    
                    Spacer()
                    
                    // Önceki ve Sonraki ay butonları
                    HStack(spacing: 16) {
                        Button(action: {
                            if let newDate = calendar.date(byAdding: .month, value: -1, to: viewModel.selectedDate) {
                                viewModel.selectedDate = newDate
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                        }
                        .disabled(calendar.isDate(viewModel.selectedDate, equalTo: Date(), toGranularity: .month))
                        
                        Button(action: {
                            if let newDate = calendar.date(byAdding: .month, value: 1, to: viewModel.selectedDate) {
                                viewModel.selectedDate = newDate
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .disabled(calendar.isDate(viewModel.selectedDate, equalTo: calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date(), toGranularity: .month))
                    }
                }
                .padding(.bottom, 8)
                
                // Available Days
                if let schedule = viewModel.tour.schedule,
                   let availableDays = schedule.availableDays {
                    HStack(spacing: 8) {
                        Text("Available:")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(availableDays, id: \.self) { day in
                                Text(day.rawValue.prefix(3))
                                    .font(.system(size: 12))
                                    .foregroundColor(.mainColor)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.mainColor.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                
                // Haftanın günleri başlıkları
                HStack {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                }
                
                // Takvim grid'i
                let days = calendar.daysInMonth(for: viewModel.selectedDate)
                let firstWeekday = calendar.firstWeekdayOfMonth(for: viewModel.selectedDate) - 1
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    // Boş günler için spacer
                    ForEach(0..<firstWeekday, id: \.self) { _ in
                        Color.clear
                            .aspectRatio(1, contentMode: .fill)
                    }
                    
                    // Ayın günleri
                    ForEach(days, id: \.self) { date in
                        let isAvailable = viewModel.isDateAvailable(date)
                        let isSelected = calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
                        let isToday = calendar.isDateInToday(date)
                        
                        Button(action: {
                            viewModel.selectedDate = date
                        }) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 16))
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(viewModel.backgroundColor(for: date, isAvailable: isAvailable, isSelected: isSelected, isToday: isToday))
                                        .frame(width: 32, height: 32)
                                )
                                .foregroundColor(viewModel.textColor(isSelected: isSelected, isAvailable: isAvailable))
                        }
                        .disabled(!isAvailable || date < Date())
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    // Helper functions for date styling
    private func backgroundColor(for date: Date, isAvailable: Bool, isSelected: Bool, isToday: Bool) -> Color {
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
    
    private func textColor(isSelected: Bool, isAvailable: Bool) -> Color {
        if isSelected {
            return .white
        } else if !isAvailable {
            return .gray
        }
        return .primary
    }
    
    private var contactInformationSection: some View {
        FormSection(title: "Contact Information") {
            VStack(spacing: 20) {
                ValidatedTextField(
                    title: "Phone Number",
                    text: $viewModel.phoneNumber,
                    placeholder: "Enter your phone number",
                    isValid: !viewModel.showingErrors || viewModel.validateField(viewModel.phoneNumber),
                    errorMessage: "Phone number is required",
                    type: .phone
                )
                .focused($focusedField, equals: .phone)
                
                ValidatedTextField(
                    title: "Email",
                    text: $viewModel.email,
                    placeholder: "Enter your email",
                    isValid: !viewModel.showingErrors || viewModel.validateField(viewModel.email),
                    errorMessage: "Email is required",
                    type: .email
                )
                .focused($focusedField, equals: .email)
            }
        }
    }
    
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(viewModel.totalPrice)
                        .font(.system(size: 18, weight: .bold))
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.validateForm()
                    if viewModel.isFormValid {
                        viewModel.completeBooking()
                    } else {
                        viewModel.showError = true
                        viewModel.errorMessage = "Please fill in all required fields"
                    }
                }) {
                    Text("Complete Booking")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.mainColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
    }
    
    // MARK: - Helper Methods
    private func isDateAvailable(_ date: Date) -> Bool {
        viewModel.availableDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    private func findNextAvailableDate(from date: Date) -> Date {
        viewModel.availableDates.first { $0 >= date } ?? viewModel.availableDates.first ?? date
    }
    
    private let calendar = Calendar.current
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

private struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

private struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isValid: Bool
    let errorMessage: String
    let type: TextFieldType
    
    enum TextFieldType {
        case name
        case phone
        case email
        case roomNumber
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
                )
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .onChange(of: text) { newValue in
                    text = formatText(newValue)
                }
            
            if !isValid {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch type {
        case .phone:
            return .phonePad
        case .email:
            return .emailAddress
        case .roomNumber:
            return .numberPad
        case .name:
            return .default
        }
    }
    
    private var textContentType: UITextContentType? {
        switch type {
        case .name:
            return .name
        case .phone:
            return .telephoneNumber
        case .email:
            return .emailAddress
        case .roomNumber:
            return nil
        }
    }
    
    private func formatText(_ input: String) -> String {
        switch type {
        case .phone:
            return input.filter { $0.isNumber || $0 == "+" }
        case .name:
            return input.filter { $0.isLetter || $0.isWhitespace }
        case .roomNumber:
            return input.filter { $0.isNumber }
        case .email:
            return input.filter { !$0.isWhitespace }
        }
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        return CGSize(
            width: proposal.width ?? 0,
            height: rows.last?.maxY ?? 0
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        
        for row in rows {
            for element in row.elements {
                element.subview.place(
                    at: CGPoint(x: bounds.minX + element.x, y: bounds.minY + row.y),
                    proposal: ProposedViewSize(width: element.width, height: element.height)
                )
            }
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row(y: 0)
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(
                ProposedViewSize(width: maxWidth, height: nil)
            )
            
            if x + size.width > maxWidth && !currentRow.elements.isEmpty {
                rows.append(currentRow)
                currentRow = Row(y: rows.last?.maxY ?? 0 + spacing)
                x = 0
            }
            
            currentRow.elements.append(
                Element(subview: subview, x: x, width: size.width, height: size.height)
            )
            x += size.width + spacing
        }
        
        if !currentRow.elements.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private struct Row {
        var elements: [Element] = []
        var y: CGFloat
        
        var maxY: CGFloat {
            y + (elements.map(\.height).max() ?? 0)
        }
    }
    
    private struct Element {
        let subview: LayoutSubview
        let x: CGFloat
        let width: CGFloat
        let height: CGFloat
    }
}

// Calendar extension
extension Calendar {
    func getCurrentMonthDays(for date: Date) -> [Date] {
        guard let monthInterval = self.dateInterval(of: .month, for: date),
              let monthFirstWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        
        var dates: [Date] = []
        self.enumerateDates(
            startingAfter: dateInterval.start,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            if date >= dateInterval.end {
                stop = true
                return
            }
            dates.append(date)
        }
        
        return dates
    }
    
    func daysInMonth(for date: Date) -> [Date] {
        guard let range = self.range(of: .day, in: .month, for: date),
              let firstDayOfMonth = self.date(from: self.dateComponents([.year, .month], from: date))
        else { return [] }
        
        return range.compactMap { day -> Date? in
            self.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }
    
    func firstWeekdayOfMonth(for date: Date) -> Int {
        guard let firstDayOfMonth = self.date(from: self.dateComponents([.year, .month], from: date))
        else { return 1 }
        
        return self.component(.weekday, from: firstDayOfMonth)
    }
} 