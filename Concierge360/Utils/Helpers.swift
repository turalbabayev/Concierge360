//
//  Helpers.swift
//  Concierge360
//
//  Created by Tural Babayev on 4.02.2025.
//

import SwiftUI

struct Helpers: View {
    var body: some View {
        Text("sdhdhs")
    }
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

struct NavigationBarButton {
    let title: String
    let action: () -> Void
}

struct CustomNavigationBar: View {
    @Environment(\.dismiss) var dismiss
    var title: String? = nil
    var centerText: String? = nil
    var rightButton: NavigationBarButton? = nil
    var color: Color = Color.white
    var isOpacity: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Leading - Sol kısım (Geri butonu)
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(color)
                }
                .frame(width: 44)
                
                // Middle - Orta kısım (Başlık veya metin)
                if let title = title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(color)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                } else if let centerText = centerText {
                    Text(centerText)
                        .foregroundColor(isOpacity ? color.opacity(0.8) : color)
                        .font(.system(size: 14))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                } else {
                    Spacer()
                }
                
                // Trailing - Sağ kısım (Opsiyonel buton)
                if let button = rightButton {
                    Button(action: button.action) {
                        Text(button.title)
                            .font(.system(size: 14))
                            .foregroundColor(color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .lineLimit(1)
                    }
                    .frame(minWidth: 44)
                } else {
                    Color.clear
                        .frame(width: 44) // Dengeleme için boş alan
                }
            }
            .padding(.horizontal, 16)
            .frame(width: geometry.size.width, height: 50)
        }
        .frame(height: 50)
    }
}

struct SearchField: View {
    @Binding var show: Bool
    @Binding var text: String
    @FocusState var isTyping: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Arka plan
            RoundedRectangle(cornerRadius: show ? 15 : 30)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.95),
                            .white.opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: show ? 15 : 30)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            
            HStack(spacing: 12) {
                // İkon
                Button(action: {
                    if show {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            text = ""
                            show = false
                            isTyping = false
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            show = true
                            isTyping = true
                        }
                    }
                }) {
                    Image(systemName: show ? "xmark" : "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 24, height: 24)
                }
                
                // TextField
                TextField("Search Hotel...", text: $text)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.black.opacity(0.8))
                    .focused($isTyping)
                    .tint(.purple)
                    .opacity(show ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: show)
            }
            .padding(.horizontal, 16)
        }
        .animation(.easeInOut(duration: 0.2), value: show)
        .frame(width: show ? 300 : 50, height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 35)
    }
}
