import SwiftUI

class AllServicesViewModel: ObservableObject {
    @Published var searchText = ""
    
    func filteredServices(for category: ServiceCategory) -> [Services] {
        var services = Services.sampleServices
        
        // Sadece kategori filtresi
        if category != .all {
            services = services.filter { $0.category == category }
        }
        
        return services
    }
} 