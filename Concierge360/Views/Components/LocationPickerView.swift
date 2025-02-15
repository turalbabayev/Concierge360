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
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding()
            
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

// MARK: - Supporting Views
private struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search location", text: $text)
                .autocapitalization(.none)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
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