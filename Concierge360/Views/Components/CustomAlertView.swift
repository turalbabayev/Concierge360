import SwiftUI

struct CustomAlertView: View {
    let bookingDetails: BookingDetails
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Arkaplan overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            
            // Alert içeriği
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    Text("Booking Confirmed!")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Your tour has been successfully reserved")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 24)
                
                Divider()
                
                // Booking Details
                VStack(alignment: .leading, spacing: 20) {
                    detailRow(icon: "ticket.fill", title: "Tour", value: bookingDetails.tourName)
                    detailRow(icon: "calendar", title: "Date", value: bookingDetails.date)
                    detailRow(icon: "clock.fill", title: "Time", value: bookingDetails.sessionTime)
                    detailRow(icon: "person.2.fill", title: "Guests", value: "\(bookingDetails.numberOfPeople) Person(s)")
                    detailRow(icon: "dollarsign.circle.fill", title: "Total Price", value: bookingDetails.totalPrice)
                }
                .padding(24)
                
                Divider()
                
                // Payment Notice
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                            .symbolEffect(.pulse, options: .repeating)
                        Text("Important Payment Notice")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    VStack(spacing: 16) {
                        paymentStep(number: 1, text: "Visit hotel reception", icon: "building.2.fill")
                        paymentStep(number: 2, text: "Make payment", icon: "creditcard.fill")
                        paymentStep(number: 3, text: "Get confirmation", icon: "checkmark.seal.fill")
                    }
                    
                    Text("Your reservation will be confirmed after payment is completed")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                .padding(24)
                
                Divider()
                
                // Close Button
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                        onDismiss()
                    }
                }) {
                    Text("Close")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.mainColor)
                        .cornerRadius(12)
                }
                .padding(24)
            }
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 20)
            .padding(.horizontal, 24)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.mainColor)
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .medium))
        }
    }
    
    private func paymentStep(number: Int, text: String, icon: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 24, height: 24)
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.orange)
            }
            
            Image(systemName: icon)
                .foregroundColor(.orange)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct BookingDetails {
    let tourName: String
    let date: String
    let numberOfPeople: Int
    let totalPrice: String
    let sessionTime: String
} 