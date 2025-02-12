import Foundation
import SwiftUI

class TourDetailViewModel: ObservableObject {
    let tour: Tour
    
    @Published var selectedImageIndex = 0
    @Published var isDarkImage: Bool = false
    @Published var showGallery = false
    @Published var showFullMap = false
    
    init(tour: Tour) {
        self.tour = tour
    }
    
    var images: [String] {
        tour.gallery.isEmpty ? [tour.image] : tour.gallery
    }
    
    // Diğer mantıksal işlemler buraya eklenebilir
} 