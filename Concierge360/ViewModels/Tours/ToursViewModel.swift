import SwiftUI
import Combine

enum TourFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case popular = "Popular"
    case new = "New"
    case historical = "Historical"
    case cultural = "Cultural"
    
    var id: String { rawValue }
    var title: String { rawValue }
}

class ToursViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter: TourFilter = .all
    @Published var isLoading = false
    @Published var tours: [Tour] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredTours: [Tour] {
        var filtered = tours
        
        // Arama filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { tour in
                tour.title.lowercased().contains(searchText.lowercased()) ||
                tour.shortDescription.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Kategori filtresi
        if selectedFilter != .all {
            filtered = filtered.filter { 
                TourCategory(rawValue: selectedFilter.rawValue) == $0.category
            }
        }
        
        return filtered
    }
    
    init() {
        loadTours()
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                withAnimation {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadTours() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.tours = tourList
                self.isLoading = false
            }
        }
    }
} 