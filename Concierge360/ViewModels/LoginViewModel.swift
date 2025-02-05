import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var navigateToHome: Bool = false
    @Published var isPasswordVisible: Bool = false
    
    init() { }
    
    func loginAsManager(using authManager: AuthenticationManager) async {
        guard !email.isEmpty && !password.isEmpty else {
            await MainActor.run {
                authManager.authError = "Please fill all fields"
            }
            return
        }
        
        await MainActor.run { isLoading = true }
        
        let success = await authManager.loginAsManager(email: email, password: password)
        
        await MainActor.run {
            isLoading = false
            if success {
                navigateToHome = true
            }
        }
    }
} 