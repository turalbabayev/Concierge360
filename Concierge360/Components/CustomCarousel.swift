//
//  CustomCarousel.swift
//  Concierge360
//
//  Created by Tural Babayev on 6.02.2025.
//

import SwiftUI

struct CustomCarousel: View {

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(serviceCards) { card in
                        GeometryReader { proxy in
                            let cardSize = proxy.size
                            
                            Image(card.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: cardSize.width, height: cardSize.height)
                                .clipShape(.rect(cornerRadius: 15))
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                .onTapGesture {
                                    print("tiklandi \(card.title)")
                                }
                        }
                        .frame(width: size.width - 50, height: size.height - 40)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: size.height, alignment: .top)
            }
            .scrollIndicators(.hidden)
        }
        .frame(height: 200)
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
}

#Preview {
    CustomCarousel()
}
