import SwiftUI

struct TourDetailView: View {
    let tour: Tour
    @Environment(\.dismiss) private var dismiss
    @State private var scrollOffset: CGFloat = .zero
    @State private var selectedImageIndex = 0
    @State private var isDarkImage: Bool = false
    @State private var showGallery = false
    @State private var showFullMap = false
    
    var images: [String] {
        tour.gallery.isEmpty ? [tour.image] : tour.gallery
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // MARK: - Hero Section
                ZStack(alignment: .bottomTrailing) {
                    // Image Gallery
                    TabView(selection: $selectedImageIndex) {
                        ForEach(images, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 350)
                                .clipped()
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        showGallery = true
                                    }
                                }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 350)
                    
                    // Image Counter
                    Text("\(selectedImageIndex + 1)/\(tour.gallery.isEmpty ? 1 : tour.gallery.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 35)
                        .padding(.trailing, 16)
                }
                
                // MARK: - Content Section
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(tour.title)
                                .font(.system(size: 22, weight: .bold))
                            Spacer()
                            PriceTag(price: tour.price)
                        }
                        
                        HStack(spacing: 16) {
                            InfoBadge(icon: "clock", text: tour.duration)
                            RatingBadge(rating: tour.rating)
                        }
                    }
                    
                    if !tour.shortDescription.isEmpty {
                        DescriptionSection(title: "About", content: tour.shortDescription)
                    }
                    
                    if !tour.tourProgram.isEmpty {
                        TourProgramSection(program: tour.tourProgram)
                        
                        // Program rotası haritası
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Tour Route")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        showFullMap = true
                                    }
                                }) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.gray)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(Circle())
                                }
                            }
                            
                            TourMapView(places: tour.tourProgram.map { $0.location })
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    
                    if let included = tour.includedServices, !included.isEmpty {
                        ServicesList(title: "What's Included", items: included, iconName: "checkmark.circle.fill")
                    }
                    
                    if let excluded = tour.excludedServices, !excluded.isEmpty {
                        ServicesList(title: "What's Not Included", items: excluded, iconName: "xmark.circle.fill")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 100)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .offset(y: -25)
            }
        }
        .overlay(alignment: .top) {
            CustomNavigationBar(
                title: tour.title,
                color: .white
            )
            .padding(.top, 48)
            .zIndex(2)
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 0) {
                Divider()
                BookNowButton(price: tour.price)
                    .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .background(Color.white)
        .onAppear {
            // Burada resmin rengini analiz edip isDarkImage'i ayarlayabiliriz
            // UIImage(named: tour.image)?.averageBrightness() gibi
        }
        .overlay {
            if showGallery {
                ImageGalleryView(
                    images: images,
                    selectedIndex: selectedImageIndex,
                    isPresented: $showGallery
                )
                .transition(.opacity.animation(.easeInOut))
            }
            
            if showFullMap {
                FullScreenMapView(
                    places: tour.tourProgram.map { $0.location },
                    isPresented: $showFullMap
                )
                .transition(.opacity.animation(.easeInOut))
            }
        }
    }
}

// MARK: - Supporting Views
private struct PriceTag: View {
    let price: String
    
    var body: some View {
        Text(price)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.mainColor)
            .clipShape(Capsule())
    }
}

private struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(text)
                .font(.system(size: 14))
        }
        .foregroundColor(.gray)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .clipShape(Capsule())
    }
}

private struct RatingBadge: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(String(format: "%.1f", rating))
        }
        .font(.system(size: 14))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.yellow.opacity(0.1))
        .clipShape(Capsule())
    }
}

private struct DescriptionSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Text(content)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }
}

private struct ServicesList: View {
    let title: String
    let items: [String]
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            
            VStack(spacing: 12) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        // İkon Container
                        Circle()
                            .fill(iconName.contains("checkmark") ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: iconName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(iconName.contains("checkmark") ? .green : .red)
                            )
                        
                        Text(item)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                            .padding(.vertical, 6)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

// Kullanımı daha kolay olması için extension ekleyelim
extension ServicesList {
    static func included(items: [String]) -> some View {
        ServicesList(
            title: "What's Included",
            items: items,
            iconName: "checkmark.circle.fill"
        )
    }
    
    static func excluded(items: [String]) -> some View {
        ServicesList(
            title: "What's Not Included",
            items: items,
            iconName: "xmark.circle.fill"
        )
    }
}

private struct TourProgramSection: View {
    let program: [TourProgramItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Program")
                .font(.system(size: 18, weight: .semibold))
            
            VStack(spacing: 0) {
                ForEach(Array(program.enumerated()), id: \.element.id) { index, item in
                    ProgramItem(item: item, index: index, isLast: index == program.count - 1)
                }
            }
            .padding(.leading, 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

private struct ProgramItem: View {
    let item: TourProgramItem
    let index: Int
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Sıra numarası ve çizgi
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.mainColor)
                        .frame(width: 30, height: 30)
                    
                    Text("\(index + 1)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.mainColor.opacity(0.2))
                        .frame(width: 2, height: 40)
                }
            }
            
            // İçerik
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            .padding(.bottom, 20)
        }
    }
}

private struct BookNowButton: View {
    let price: String
    
    var body: some View {
        Button(action: {
            // Booking action
        }) {
            Text("Book Now")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.mainColor)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
    }
}

#Preview {
    TourDetailView(tour: .init(
        title: "The Horizon Retreat",
        price: "From/$100",
        rating: 4.5,
        duration: "3 Hours",
        image: "buta-vip",
        gallery: ["buta-vip", "buta-vip", "buta-vip"],
        shortDescription: "Experience luxury and comfort with our VIP retreat service. Perfect for those seeking an exclusive and memorable journey.",
        tourProgram: [
            TourProgramItem(
                title: "Dolmabahçe Palace",
                description: "Visit the magnificent Dolmabahce Palace, home to Ottoman sultans. Explore the grand halls and beautiful gardens of this historic palace.",
                location: Place(
                    name: "Dolmabahçe Palace",
                    latitude: 41.0392,
                    longitude: 29.0007,
                    description: "Ottoman palace with stunning architecture"
                )
            ),
            TourProgramItem(
                title: "Bosphorus Bridge",
                description: "Cross between two continents and enjoy panoramic views of Istanbul. Perfect photo opportunity of the city's unique geography.",
                location: Place(
                    name: "Bosphorus Bridge",
                    latitude: 41.0451,
                    longitude: 29.0341,
                    description: "Bridge connecting Europe and Asia"
                )
            ),
            TourProgramItem(
                title: "Çamlıca Hill",
                description: "Enjoy lunch with breathtaking city views. The highest point in Istanbul offering 360-degree panoramic views of the city and Bosphorus.",
                location: Place(
                    name: "Çamlıca Hill",
                    latitude: 41.0278,
                    longitude: 29.0717,
                    description: "Highest point in Istanbul"
                )
            ),
            TourProgramItem(
                title: "Maiden's Tower",
                description: "Visit the legendary tower and learn its history. This historic tower sits at the confluence of the Bosphorus strait, offering unique views.",
                location: Place(
                    name: "Maiden's Tower",
                    latitude: 41.0211,
                    longitude: 29.0041,
                    description: "Historic tower on a small islet"
                )
            )
        ],
        startTime: "09:00",
        meetingPoint: "Hotel Lobby",
        includedServices: [
            "Luxury vehicle",
            "Professional guide",
            "Entrance fees",
            "Lunch"
        ],
        excludedServices: [
            "Personal expenses",
            "Additional activities",
            "Gratuities"
        ],
        visitingPlaces: nil
    ))
}
