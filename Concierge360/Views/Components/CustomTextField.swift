import SwiftUI

struct CustomTextField2: View {
    let title: String
    @Binding var text: String
    let icon: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                if isSecure {
                    SecureField("", text: $text)
                        .textFieldStyle(.plain)
                } else {
                    TextField("", text: $text)
                        .textFieldStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(
            title: "Full Name",
            text: .constant(""),
            placeholder: "person.fill"
        )
        
        CustomTextField(
            title: "Password",
            text: .constant(""),
            placeholder: "lock.fill"
        )
    }
    .padding()
} 
