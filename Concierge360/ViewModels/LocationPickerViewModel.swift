import SwiftUI
import MapKit
import Combine

struct MapPlace: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String?
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: MapPlace, rhs: MapPlace) -> Bool {
        lhs.id == rhs.id
    }
}

class LocationPickerViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText = ""
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784), // Istanbul
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var searchResults: [MapPlace] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let searchCompleter = MKLocalSearchCompleter()
    
    private var currentSearchTask: MKLocalSearch?
    private var searchDebounceTimer: Timer?
    
    override init() {
        super.init()
        searchCompleter.resultTypes = .pointOfInterest
        searchCompleter.delegate = self
        
        // Debounce süresini artırarak gereksiz aramaları azaltalım
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard !text.isEmpty else {
                    self?.searchResults.removeAll()
                    return
                }
                self?.searchCompleter.queryFragment = text
            }
            .store(in: &cancellables)
    }
    
    private func updateRegion(for coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async { [weak self] in
            self?.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    private func convertToPlace(_ completion: MKLocalSearchCompletion) {
        currentSearchTask?.cancel()
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = completion.title
        
        currentSearchTask = MKLocalSearch(request: searchRequest)
        currentSearchTask?.start { [weak self] response, error in
            guard let self = self,
                  let response = response,
                  let item = response.mapItems.first else { return }
            
            let place = MapPlace(
                id: UUID().uuidString,
                name: completion.title,
                address: completion.subtitle,
                coordinate: item.placemark.coordinate
            )
            
            DispatchQueue.main.async {
                if !self.searchResults.contains(place) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.searchResults.append(place)
                    }
                    self.updateRegion(for: place.coordinate)
                }
            }
        }
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        withAnimation(.easeInOut(duration: 0.3)) {
            searchResults.removeAll()
        }
        completer.results.forEach { completion in
            convertToPlace(completion)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed with error: \(error.localizedDescription)")
    }
} 