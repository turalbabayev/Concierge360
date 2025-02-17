import SwiftUI

class AllServicesViewModel: ObservableObject {
    @Published var searchText = ""
    
    func filteredServices(for category: ServiceCategory) -> [Services] {
        var services = Services.sampleServices
        
        // Kategori filtresi
        if category != .all {
            services = services.filter { $0.category == category }
        }
        
        // Arama filtresi
        if !searchText.isEmpty {
            services = services.filter { service in
                service.name.lowercased().contains(searchText.lowercased()) ||
                service.features.joined(separator: " ").lowercased().contains(searchText.lowercased())
            }
        }
        
        return services
    }
} 