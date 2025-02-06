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
                        .foregroundStyle(selectedTab == item.tab ? .blue : .gray)
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
            .frame(width: 365, height: 70)
            .background(
                CustomShape(xAxis: xOffset + 12)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .overlay(alignment: .topLeading) {
                Circle().frame(width: 10, height: 10)
                    .offset(x:36)
                    .offset(x: xOffset)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(selectedTab: .constant(.Home))
}
