import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: String
    @StateObject private var viewModel = LocationPickerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: viewModel.searchResults) { place in
                    MapMarker(coordinate: place.coordinate)
                }
                .ignoresSafeArea(edges: .bottom)
                
                searchOverlay
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Search overlay'i ayrı bir view olarak tanımlayalım
    private var searchOverlay: some View {
        VStack(spacing: 0) {
            CommonSearchBar(
                text: $viewModel.searchText,
                placeholder: "Search location"
            )
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            if !viewModel.searchResults.isEmpty {
                searchResultsList
            }
            
            Spacer()
        }
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.searchResults) { place in
                    LocationRow(place: place) {
                        selectedLocation = place.name
                        dismiss()
                    }
                    Divider()
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .background(Color.black.opacity(0.4))
    }
}



private struct LocationRow: View {
    let place: MapPlace
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.mainColor)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    if let address = place.address {
                        Text(address)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .foregroundColor(.primary)
    }
} 
