//
//  ContentView.swift
//  Concierge360
//
//  Created by Tural Babayev on 2.02.2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab:TabIcon
    @State var xOffset = 0 * 70.0
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                ForEach(tabItems) {item in
                    Spacer()
                    Image(systemName: item.iconname)
                        .foregroundStyle(selectedTab == item.tab ? .black : .gray)
                        .onTapGesture {
                            withAnimation {
                                selectedTab = item.tab
                                xOffset = CGFloat(item.index * 70)
                            }
                        }
                    Spacer()
                }
                .frame(width: 23)
            }
            .frame(width: 400, height: 55)
            .background(
                CustomShape(xAxis: xOffset + 30)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
            )
            .overlay(alignment: .topLeading) {
                Circle().frame(width: 10, height: 10)
                    .offset(x:54)
                    .offset(x: xOffset)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)

                
            }
        }
        //.padding()
    }
}

#Preview {
    ContentView(selectedTab: .constant(.Home))
}
