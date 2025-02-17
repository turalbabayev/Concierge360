import SwiftUI

struct ToursView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ToursViewModel()
    @State private var showSearchBar = false
    @State private var selectedFilter: TourFilter = .all
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "Discover Tours",
                rightButton: NavigationBarButton(
                    title: "", icon: showSearchBar ? "xmark" : "magnifyingglass",
                    action: { showSearchBar.toggle() }
                ),
                color: .black
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // MARK: - Subtitle
                    if !showSearchBar {
                        Text("Find your perfect Istanbul experience")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    
                    // MARK: - Search & Filter
                    searchAndFilterSection
                    
                    // MARK: - Content
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredTours.isEmpty {
                        emptyStateView
                    } else {
                        toursList
                    }
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
        .navigationBarHidden(true)
        .onTapGesture {
            isSearchFocused = false // Klavyeyi kapat
        }
    }
    
    // MARK: - Search & Filter Section
    private var searchAndFilterSection: some View {
        VStack(spacing: 16) {
            if showSearchBar {
                CommonSearchBar(
                    text: $viewModel.searchText,
                    placeholder: "Search amazing tours..."
                )
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TourFilter.allCases) { filter in
                        FilterChip(
                            title: filter.title,
                            isSelected: selectedFilter == filter,
                            action: { withAnimation(.spring()) { selectedFilter = filter } }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Tours List
    private var toursList: some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel.filteredTours) { tour in
                TourCard(tour: tour)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerTourCard()
            }
        }
        .padding()
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 100, height: 100)
                )
                .scaleEffect(showSearchBar ? 1.1 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showSearchBar)
            
            Text("No Tours Found")
                .font(.system(size: 20, weight: .bold))
            
            Text("Try adjusting your search or filters to find what you're looking for.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 50)
    }
}

// MARK: - Supporting Views
private struct CustomSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(.gray)
            
            TextField("Search amazing tours...", text: $text)
                .font(.system(size: 16))
                .textFieldStyle(.plain)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: { 
                    withAnimation(.spring()) {
                        text = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.mainColor : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
        .animation(.spring(response: 0.3), value: isFocused)
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.mainColor : Color.white)
                        .shadow(
                            color: isSelected ? Color.mainColor.opacity(0.2) : Color.black.opacity(0.05),
                            radius: isSelected ? 8 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2
                        )
                )
        }
    }
}

private struct TourCard: View {
    let tour: Tour
    
    var body: some View {
        NavigationLink(destination: TourDetailView(tour: tour)) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Section
                ZStack(alignment: .bottomLeading) {
                    Image(tour.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                    
                    // Gradient Overlay
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    // Content Overlay
                    VStack(alignment: .leading, spacing: 12) {
                        // Price Tag
                        HStack(spacing: 4) {
                            Text(tour.price)
                                .font(.system(size: 18, weight: .bold))
                            Text("/ person")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.mainColor)
                        .clipShape(Capsule())
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tour.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            HStack {
                                // Duration & Rating
                                HStack(spacing: 16) {
                                    Label(tour.duration, systemImage: "clock.fill")
                                    Label(String(format: "%.1f", tour.rating), systemImage: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                                
                                Spacer()
                                
                                // Book Now Button
                                Text("Book Now")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.mainColor)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        }
    }
}

private struct ShimmerTourCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: isAnimating ? 200 : -200)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 20)
                    .frame(width: 200)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 16)
                        .frame(width: 100)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 16)
                        .frame(width: 60)
                }
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
} 
