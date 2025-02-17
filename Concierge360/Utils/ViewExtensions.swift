import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                     to: nil, 
                                     from: nil, 
                                     for: nil)
    }
    
    func closeKeyboardOnTap() -> some View {
        self.onTapGesture {
            dismissKeyboard()
        }
    }
    
    // Safe Area ve TabBar yüksekliklerini almak için
    func getSafeAreaTop() -> CGFloat {
        guard let screen = UIApplication.shared.windows.first else { return 0 }
        return screen.safeAreaInsets.top
    }
    
    func getTabBarHeight() -> CGFloat {
        return 83 // TabBar yüksekliği + bottom safe area
    }
} 
