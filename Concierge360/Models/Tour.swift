//
//  Tour.swift
//  Concierge360
//
//  Created by Tural Babayev on 7.02.2025.
//

import SwiftUI

struct Tour: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let rating: Double
    let duration: String
    let image: String
    let gallery: [String]
    let shortDescription: String
    let tourProgram: [TourProgramItem]
    let schedule: TourSchedule?
    let meetingPoint: String?
    let includedServices: [String]?
    let excludedServices: [String]?
    let visitingPlaces: [Place]?
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let description: String
}

struct TourProgramItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let location: Place
}

struct TourSchedule {
    let availableDays: [WeekDay]?
    let sessions: [TourSession]
    let notes: String?
}

struct TourSession: Identifiable {
    let id = UUID()
    let startTime: String
    let endTime: String
    let title: String? // Opsiyonel başlık (örn: "Morning Tour", "Afternoon Tour")
}

enum WeekDay: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

var tourList: [Tour] = [
    .init(
        title: "In The Footsteps of the Sultan",
        price: "$80",
        rating: 4.9,
        duration: "6.5 Hours",
        image: "topkapipalace",
        gallery: ["topkapipalace", "hagiairene", "bluemosque","sultanahmet","hippo","hurremsultanhamami"],
        shortDescription: "Embark on a fascinating journey through the legacy of the Ottoman Sultans! From grand palaces to majestic mosques, bustling bazaars to historic caravanserais, experience the splendor of the Ottoman Empire and walk through history in its most iconic locations.",
        tourProgram: [
            TourProgramItem(
                title: "Topkapı Palace",
                description: "Explore the grandeur of the Ottoman Empire and its historical treasures",
                location: Place(
                    name: "Topkapı Palace",
                    latitude: 41.0115,
                    longitude: 28.9833,
                    description: "The former imperial palace of the Ottoman Sultans, showcasing royal artifacts and stunning architecture"
                )
            ),
            TourProgramItem(
                title: "Hagia Irene Church",
                description: "Discover one of Istanbul's oldest Byzantine churches, rich in history and architecture",
                location: Place(
                    name: "Hagia Irene Church",
                    latitude: 41.0085,
                    longitude: 28.9802,
                    description: "A historic Byzantine church within the Topkapı Palace complex, known for its remarkable acoustics and ancient structure"
                )
            ),
            TourProgramItem(
                title: "Blue Mosque",
                description: "Experience the architectural splendor of the 17th-century Sultan Ahmed Mosque, renowned for its stunning blue tiles and six towering minarets.",
                location: Place(
                    name: "Blue Mosque",
                    latitude: 41.0055,
                    longitude: 28.9774,
                    description: "An iconic symbol of Istanbul, the Blue Mosque features a harmonious blend of Islamic and Ottoman architectural styles, captivating visitors with its serene ambiance and historical significance."
                )
            ),
            TourProgramItem(
                title: "Hippodrome of Constantinople",
                description: "Explore the historic arena that was once the social and sporting center of Byzantine Constantinople.",
                location: Place(
                    name: "Hippodrome of Constantinople",
                    latitude: 41.0064,
                    longitude: 28.9758,
                    description: "An ancient chariot-racing stadium and social hub of Byzantine Constantinople, now known as Sultanahmet Square, featuring notable monuments like the Obelisk of Theodosius and the Serpent Column."
                )
            ),
            TourProgramItem(
                title: "Ibrahim Pasha Palace (Outside)",
                description: "Admire the elegant exterior of one of the finest examples of Ottoman civil architecture.",
                location: Place(
                    name: "Ibrahim Pasha Palace",
                    latitude: 41.00583,
                    longitude: 28.97444,
                    description: "A historic Ottoman palace overlooking the Hippodrome, known for its grand facade and classical Ottoman architectural style."
                )
            ),
            TourProgramItem(
                title: "Hürrem Sultan Hamam (Outside)",
                description: "Admire the stunning exterior of the historic Ottoman bathhouse built for Hürrem Sultan.",
                location: Place(
                    name: "Hürrem Sultan Hamam",
                    latitude: 41.00732,
                    longitude: 28.97928,
                    description: "Designed by Mimar Sinan in the 16th century, this elegant bathhouse is known for its classical Ottoman architecture and beautiful domes."
                )
            )
        ],
        schedule: TourSchedule(
            availableDays: [.monday, .wednesday, .thursday, .friday, .saturday, .sunday],
            sessions: [
                TourSession(
                    startTime: "09:30",
                    endTime: "14:00",
                    title: "Morning Tour"
                )
            ],
            notes: "Last entry 1 hour before closing"
        ),
        meetingPoint: "Hotel Lobby",
        includedServices: [
            "Transportation",
            "Professional guide",
            "Entrance fees",
            "Water"
        ],
        excludedServices: [
            "Lunch",
            "Personal expenses",
            "Optional activities"
        ],
        visitingPlaces: [
            Place(name: "Aquarium",
                  latitude: 41.0392,
                  longitude: 29.0007,
                  description: "Underwater world of marine life")
        ]
    ),
    .init(
        title: "Turkish Hamam Tour",
        price: "$40",
        rating: 4.5,
        duration: "3 Hours",
        image: "turkishhamam",
        gallery: ["turkishhamam", "turkishhamam", "turkishhamam"],
        shortDescription: "Immerse yourself in the traditional Turkish bath experience, a centuries-old ritual of relaxation and rejuvenation.",
        tourProgram: [],
        schedule: TourSchedule(
            availableDays: [.monday, .wednesday, .friday, .saturday, .sunday],
            sessions: [
                TourSession(
                    startTime: "10:00",
                    endTime: "13:00",
                    title: "Morning Session"
                ),
                TourSession(
                    startTime: "14:00",
                    endTime: "17:00",
                    title: "Afternoon Session"
                ),
                TourSession(
                    startTime: "18:00",
                    endTime: "21:00",
                    title: "Evening Session"
                )
            ],
            notes: "Last entry 2 hours before closing"
        ),
        meetingPoint: "Hamam Entrance",
        includedServices: [
            "Traditional bath service",
            "Towels and toiletries",
            "Locker usage",
            "Tea service"
        ],
        excludedServices: [
            "Extra massage services",
            "Private room",
            "Transportation"
        ],
        visitingPlaces: [
            Place(name: "Historical Hamam",
                  latitude: 41.0082,
                  longitude: 28.9784,
                  description: "Traditional Turkish bath")
        ]
    ),
    .init(
        title: "The Horizon Retreat",
        price: "$100",
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
        schedule: TourSchedule(
            availableDays: [.monday, .wednesday, .friday, .saturday],
            sessions: [
                TourSession(
                    startTime: "09:30",
                    endTime: "14:00",
                    title: "Morning Tour"
                ),
                TourSession(
                    startTime: "12:30",
                    endTime: "17:00",
                    title: "Afternoon Tour"
                )
            ],
            notes: "Not available on public holidays"
        ),
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
    ),
    .init(
        title: "Panorama of the Bosporus",
        price: "$30",
        rating: 4.5,
        duration: "3 Hours",
        image: "Panorama of the Bosporus",
        gallery: ["Panorama of the Bosporus", "Panorama of the Bosporus", "Panorama of the Bosporus"],
        shortDescription: "Discover the beauty of Istanbul's Bosphorus strait with our panoramic tour, offering breathtaking views of two continents.",
        tourProgram: [],
        schedule: TourSchedule(
            availableDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
            sessions: [
                TourSession(
                    startTime: "10:00",
                    endTime: "13:00",
                    title: "Morning Cruise"
                ),
                TourSession(
                    startTime: "14:00",
                    endTime: "17:00",
                    title: "Afternoon Cruise"
                )
            ],
            notes: "Weather dependent tour"
        ),
        meetingPoint: "Eminönü Pier",
        includedServices: [
            "Boat tour",
            "Guide service",
            "Welcome drink",
            "Audio guide"
        ],
        excludedServices: [
            "Food and beverages",
            "Hotel transfer",
            "Gratuities"
        ],
        visitingPlaces: [
            Place(name: "Dolmabahce Palace",
                  latitude: 41.0392,
                  longitude: 29.0007,
                  description: "Ottoman palace with stunning architecture"),
            Place(name: "Maiden's Tower",
                  latitude: 41.0211,
                  longitude: 29.0041,
                  description: "Historic tower on a small islet")
        ]
    ),
    .init(
        title: "Panoramıc Istanbul",
        price: "$90",
        rating: 4.5,
        duration: "3 Hours",
        image: "Panoramıc Istanbul",
        gallery: ["Panoramıc Istanbul", "Panoramıc Istanbul", "Panoramıc Istanbul"],
        shortDescription: "Experience Istanbul from the best viewpoints, capturing the city's magnificent skyline and historical landmarks.",
        tourProgram: [],
        schedule: TourSchedule(
            availableDays: [.tuesday, .thursday, .saturday, .sunday],
            sessions: [
                TourSession(
                    startTime: "09:00",
                    endTime: "12:00",
                    title: "Morning Tour"
                ),
                TourSession(
                    startTime: "13:00",
                    endTime: "16:00",
                    title: "Afternoon Tour"
                )
            ],
            notes: nil
        ),
        meetingPoint: "Sultanahmet Square",
        includedServices: [
            "Transportation",
            "Professional guide",
            "Entrance fees",
            "Water"
        ],
        excludedServices: [
            "Lunch",
            "Personal expenses",
            "Optional activities"
        ],
        visitingPlaces: [
            Place(name: "Çamlıca Hill",
                  latitude: 41.0278,
                  longitude: 29.0717,
                  description: "Highest point in Istanbul"),
            Place(name: "Pierre Loti Hill",
                  latitude: 41.0547,
                  longitude: 28.9435,
                  description: "Historic hilltop cafe")
        ]
    ),
    
]

extension Tour {
    static let example = Tour(
        title: "Bosphorus Sunset Cruise",
        price: "$75",
        rating: 4.8,
        duration: "2.5 Hours",
        image: "bosphorus",
        gallery: ["bosphorus1", "bosphorus2", "bosphorus3"],
        shortDescription: "Experience the magic of Istanbul from the water as you cruise between two continents on a 2.5-hour sunset cruise along the Bosphorus Strait.",
        tourProgram: [],
        schedule: TourSchedule(
            availableDays: [.monday, .wednesday, .friday, .saturday],
            sessions: [
                TourSession(
                    startTime: "17:30",
                    endTime: "20:00",
                    title: "Sunset Cruise"
                )
            ],
            notes: "Sunset timing may vary by season"
        ),
        meetingPoint: "Kabataş Pier",
        includedServices: [
            "Professional guide",
            "Hotel pickup and drop-off",
            "Light refreshments",
            "Live entertainment"
        ],
        excludedServices: [
            "Gratuities",
            "Personal expenses",
            "Additional food and drinks"
        ],
        visitingPlaces: [
            Place(name: "Dolmabahce Palace", 
                  latitude: 41.0392, 
                  longitude: 29.0007,
                  description: "Ottoman palace with stunning architecture"),
            Place(name: "Maiden's Tower", 
                  latitude: 41.0211, 
                  longitude: 29.0041,
                  description: "Historic tower on a small islet")
        ]
    )
}

#Preview {
    TourDetailView(tour: .init(
        title: "Bosphorus Sunset Cruise",
        price: "$75",
        rating: 4.8,
        duration: "2.5 Hours",
        image: "bosphorus",
        gallery: ["bosphorus1", "bosphorus2", "bosphorus3"],
        shortDescription: "Experience the magic of Istanbul from the water as you cruise between two continents on a 2.5-hour sunset cruise along the Bosphorus Strait.",
        tourProgram: [],
        schedule: TourSchedule(
            availableDays: [.monday, .wednesday, .friday],
            sessions: [
                TourSession(
                    startTime: "09:00",
                    endTime: "17:00",
                    title: "Full Day Tour"
                )
            ],
            notes: "Tour not available on public holidays"
        ),
        meetingPoint: "Kabataş Pier",
        includedServices: [
            "Professional guide",
            "Hotel pickup and drop-off",
            "Light refreshments",
            "Live entertainment"
        ],
        excludedServices: [
            "Gratuities",
            "Personal expenses",
            "Additional food and drinks"
        ],
        visitingPlaces: [
            Place(name: "Dolmabahce Palace", 
                  latitude: 41.0392, 
                  longitude: 29.0007,
                  description: "Ottoman palace with stunning architecture"),
            Place(name: "Maiden's Tower", 
                  latitude: 41.0211, 
                  longitude: 29.0041,
                  description: "Historic tower on a small islet")
        ]
    ))
}
