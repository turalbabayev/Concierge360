import SwiftUI

struct CommonSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Search Icon with Background
            ZStack {
                Circle()
                    .fill(Color.mainColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.mainColor)
            }
            
            // Text Field
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .focused($isFocused)
            
            // Clear Button
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.spring()) {
                        text = ""
                    }
                }) {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                        )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? Color.mainColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
        .animation(.spring(response: 0.3), value: isFocused)
    }
}

// Preview için
#Preview {
    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            CommonSearchBar(text: .constant(""))
            CommonSearchBar(text: .constant("Hello"))
        }
        .padding()
    }
} 