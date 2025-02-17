import SwiftUI

struct AllServicesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AllServicesViewModel()
    @State private var showSearchBar = false
    @State private var selectedCategory: ServiceCategory = .all
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            CustomNavigationBar(
                title: "All Services",
                rightButton: NavigationBarButton(
                    title: "",
                    icon: showSearchBar ? "xmark" : "magnifyingglass",
                    action: { withAnimation(.spring()) { showSearchBar.toggle() } }
                ),
                color: .black
            )
            
            // MARK: - Search Bar
            if showSearchBar {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ServiceCategory.allCases) { category in
                                CategoryButton(
                                    title: category.title,
                                    isSelected: selectedCategory == category,
                                    action: { withAnimation { selectedCategory = category } }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                    
                    // Services List
                    if viewModel.filteredServices(for: selectedCategory).isEmpty {
                        EmptyStateView()
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.filteredServices(for: selectedCategory)) { service in
                                NavigationLink(destination: ServiceBookingView(service: service)) {
                                    ModernServiceCard(service: service)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .navigationBarHidden(true)
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Supporting Views
private struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search services...", text: $text)
                .font(.system(size: 16))
                .autocapitalization(.none)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

private struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.mainColor : Color.gray.opacity(0.1))
                )
                .animation(.spring(), value: isSelected)
        }
    }
}

private struct ModernServiceCard: View {
    let service: Services
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            Image(service.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 140)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Content
            VStack(alignment: .leading, spacing: 16) {
                // Title and Rating
                HStack {
                    Text(service.name)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", service.rating))
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 14))
                }
                
                // Features
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(service.features.chunked(into: 2), id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(row, id: \.self) { feature in
                                HStack(spacing: 4) {
                                    Image(systemName: getFeatureIcon(for: feature))
                                        .font(.system(size: 12))
                                    Text(feature)
                                        .font(.system(size: 13))
                                        .lineLimit(2)
                                }
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.08))
                                )
                            }
                        }
                    }
                }
                
                // Price and Passengers
                HStack {
                    if service.vehicleType == .standard || service.vehicleType == .airport {
                        PriceTag(text: "Metered Price", color: .orange)
                    } else {
                        PriceTag(text: "$\(service.price)", color: .mainColor)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text("Up to \(service.maxPassengers)")
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
    }
    
    // Her özellik için uygun icon seç
    private func getFeatureIcon(for feature: String) -> String {
        switch feature.lowercased() {
        case _ where feature.contains("24/7"): return "clock.fill"
        case _ where feature.contains("meet"): return "figure.wave"
        case _ where feature.contains("flight"): return "airplane"
        case _ where feature.contains("waiting"): return "timer"
        case _ where feature.contains("price"): return "dollarsign.circle"
        case _ where feature.contains("driver"): return "person.fill"
        case _ where feature.contains("wifi"): return "wifi"
        default: return "checkmark.circle"
        }
    }
}

private struct PriceTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No services found")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
} 