//
//  Helpers.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

struct Helpers: View {
    var body: some View {
        CustomNavigationBar()

    }
}

#Preview {
    Helpers()
}

struct GradientButtonStyle: ButtonStyle {
    @State var isAnimating = false
    let gradientColors = Gradient(colors: [Color.blue, Color.purple])
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .stroke(AngularGradient.init(gradient: gradientColors, center: .center, angle: .degrees(isAnimating ? 360 : 0)), lineWidth: 14)
                .frame(width: 210, height: 30)
                .offset(y: 30)
                .blur(radius: 30)
            configuration.label.bold()
                .foregroundStyle(.white)
                .frame(width: 280, height: 60)
                .background(.black, in: .rect(cornerRadius: 20))
                .overlay {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AngularGradient.init(gradient: gradientColors, center: .center, angle: .degrees(isAnimating ? 360 : 0)), lineWidth: 3)
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 4)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                    }
                }
        }
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.spring, value: configuration.isPressed)
        .onAppear() {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}


struct CustomNavigationBar: View {
    @Environment(\.dismiss) var dismiss // Geri butonu için
    var color: Color = Color.white
    var isOpacity: Bool = true
    
    var body: some View {
        HStack {
            // Geri Butonu
            Button(action: {
                dismiss() // Sayfaya geri döner
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(.leading, 10)
            }
            
            Spacer()

            
            HStack{
                // Açıklama Metni
                Text("Don’t have an account?")
                    .foregroundColor(isOpacity ? color.opacity(0.8) : color)
                    .font(.system(size: 14))
                
                // "Get Started" Butonu
                Button(action: {
                    print("Get Started tapped")
                }) {
                    Text("Get Started")
                        .font(.system(size: 14))
                        .foregroundColor(color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.trailing, 10)
            }
        }
        .frame(height: 50) // Navigation bar yüksekliği
        .padding(.horizontal)
    }
}
