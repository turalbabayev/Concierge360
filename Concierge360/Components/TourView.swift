//
//  TourView.swift
//  Concierge360
//
//  Created by Tural Babayev on 7.02.2025.
//

import SwiftUI

struct TourCardView: View {
    let card: Tour
    var body: some View {
        ZStack(alignment: .bottomLeading) { // Kart içeriği .bottomLeading olmalı
            // 🔹 Arka Plan Görseli
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 15))

            

            // 🔹 Siyah Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            // 🔹 İçerik (Altta kalmalı)
            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .bold()

                Text(card.duration)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))

                HStack {
                    Text(card.price)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .bold()

                    Spacer()

                    // 🔹 Yıldız ve Puan
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(card.rating))
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .medium))
                    }
                }
            }
            .padding()
        }
        .frame(width: 160, height: 250)
        
    }
}
