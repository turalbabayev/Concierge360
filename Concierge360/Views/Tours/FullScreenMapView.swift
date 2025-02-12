import SwiftUI
import MapKit

struct FullScreenMapView: View {
    let places: [Place]
    @Binding var isPresented: Bool
    @State private var region: MKCoordinateRegion
    @State private var selectedPlace: Place?
    
    init(places: [Place], isPresented: Binding<Bool>) {
        self.places = places
        self._isPresented = isPresented
        
        // Tüm noktaları kapsayan bir bölge hesapla
        let coordinates = places.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }
    
    var body: some View {
        ZStack {
            // Map
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: place.latitude,
                    longitude: place.longitude
                )) {
                    VStack {
                        if let index = places.firstIndex(where: { $0.id == place.id }) {
                            ZStack {
                                Circle()
                                    .fill(Color.mainColor)
                                    .frame(width: 30, height: 30)
                                
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                selectedPlace = place
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Controls Overlay
            VStack {
                // Top Bar
                HStack {
                    Button(action: { withAnimation { isPresented = false } }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // Bottom Info Card (if place selected)
                if let place = selectedPlace {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(place.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text(place.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .padding()
                }
            }
        }
    }
} 