import SwiftUI
import MapKit

struct TourMapView: View {
    let places: [Place]
    @State private var region: MKCoordinateRegion
    
    init(places: [Place]) {
        self.places = places
        
        // İlk lokasyonu merkez al
        if let firstPlace = places.first {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstPlace.latitude,
                    longitude: firstPlace.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion())
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapAnnotation(coordinate: CLLocationCoordinate2D(
                latitude: place.latitude,
                longitude: place.longitude
            )) {
                VStack {
                    // Sıra numarası ekledik
                    ZStack {
                        Circle()
                            .fill(Color.mainColor)
                            .frame(width: 30, height: 30)
                        
                        if let index = places.firstIndex(where: { $0.id == place.id }) {
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(place.name)
                        .font(.caption)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(4)
                        .shadow(radius: 2)
                }
            }
        }
    }
}

#Preview {
    TourMapView(places: [
        Place(name: "Dolmabahce Palace", 
              latitude: 41.0392,
              longitude: 29.0007,
              description: "Ottoman palace"),
        Place(name: "Maiden's Tower",
              latitude: 41.0211,
              longitude: 29.0041,
              description: "Historic tower")
    ])
    .frame(height: 200)
} 