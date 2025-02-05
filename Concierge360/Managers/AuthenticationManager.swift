import Foundation
import SwiftUI
import KeychainSwift

enum UserRole {
    case guest
    case manager
}

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentRole: UserRole?
    @Published var authError: String?
    
    private let keychain = KeychainSwift()
    private let roleKey = "userRole"
    private let managerCredentialsKey = "managerCredentials"
    
    init() {
        setupInitialManagerCredentials()
    }
    
    private func setupInitialManagerCredentials() {
        // Eğer daha önce kaydedilmemişse, manager bilgilerini kaydet
        if keychain.get(managerCredentialsKey) == nil {
            let managers = [
                "admin@hotel.com": "admin123",
                "manager@hotel.com": "manager123"
            ]
            
            if let encodedData = try? JSONEncoder().encode(managers) {
                keychain.set(encodedData, forKey: managerCredentialsKey)
            }
        }
    }
    
    private func getManagerCredentials() -> [String: String] {
        if let data = keychain.getData(managerCredentialsKey),
           let credentials = try? JSONDecoder().decode([String: String].self, from: data) {
            return credentials
        }
        return [:]
    }
    
    func loginAsGuest() {
        isAuthenticated = true
        currentRole = .guest
        saveRole(.guest)
    }
    
    func loginAsManager(email: String, password: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simüle edilmiş ağ gecikmesi
        
        let managerCredentials = getManagerCredentials()
        
        if let storedPassword = managerCredentials[email], storedPassword == password {
            await MainActor.run {
                self.isAuthenticated = true
                self.currentRole = .manager
                self.saveRole(.manager)
                self.authError = nil
            }
            return true
        } else {
            await MainActor.run {
                self.authError = "Invalid email or password"
                self.isAuthenticated = false
            }
            return false
        }
    }
    
    func logout() {
        isAuthenticated = false
        currentRole = nil
        UserDefaults.standard.removeObject(forKey: roleKey)
    }
    
    private func saveRole(_ role: UserRole) {
        UserDefaults.standard.set(role == .manager ? "manager" : "guest", forKey: roleKey)
    }
    
    func loadSavedRole() {
        if let savedRole = UserDefaults.standard.string(forKey: roleKey) {
            currentRole = savedRole == "manager" ? .manager : .guest
            isAuthenticated = true
        }
    }
} 