import SwiftUI

struct ChatView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Group {
            if authManager.currentRole == .manager {
                ManagerChatView()
            } else {
                GuestChatView()
            }
        }
    }
}

// Yönetici için Chat View
struct ManagerChatView: View {
    @State private var searchText = ""
    @State private var selectedChat: UUID? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Navigation Bar
                CustomNavigationBar(
                    title: "Messages",
                    rightButton: NavigationBarButton(
                        title: "",
                        icon: "square.and.pencil",
                        action: {}
                    ),
                    color: .black
                )
                
                // Search Bar
                CommonSearchBar(
                    text: $searchText,
                    placeholder: "Search conversations..."
                )
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // Online Users
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(1...5, id: \.self) { index in
                            VStack(spacing: 8) {
                                ZStack(alignment: .bottomTrailing) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 56, height: 56)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        )
                                    
                                    // Online indicator
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 14, height: 14)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                }
                                
                                Text("Guest \(index)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                Divider()
                    .padding(.horizontal)
                
                // Conversations List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<10) { index in
                            NavigationLink(
                                destination: ChatDetailView(
                                    chatId: UUID(),
                                    guestName: "Guest \(index + 1)"
                                )
                            ) {
                                ModernConversationRow(
                                    name: "Guest \(index + 1)",
                                    lastMessage: "Last message from guest...",
                                    time: "2m ago",
                                    unreadCount: index % 3 == 0 ? 3 : 0,
                                    isOnline: index % 2 == 0
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom, getTabBarHeight())
                }
            }
            .background(.white)
        }
    }
}

// Modern Conversation Row
struct ModernConversationRow: View {
    let name: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let isOnline: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        )
                    
                    if isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(lastMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if unreadCount > 0 {
                            Text("\(unreadCount)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color.mainColor)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 88)
        }
        .background(Color.white)
    }
}

// Mesajlaşma Detay Sayfası
struct ChatDetailView: View {
    let chatId: UUID
    let guestName: String
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = sampleMessages
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            CustomNavigationBar(
                title: guestName,
                color: .black
            )
            
            // Online Status
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Online")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            
            Divider()
            
            // Messages
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(messages) { message in
                        ModernMessageBubble(message: message)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .padding(.bottom, 8)
            
            // Input Area
            ModernMessageInput(text: $messageText, isFocused: _isTextFieldFocused) {
                sendMessage()
            }
            .padding(.bottom, getTabBarHeight() + 8)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let newMessage = ChatMessage(
            id: UUID(),
            content: messageText,
            isFromGuest: false,
            timestamp: Date()
        )
        withAnimation(.spring()) {
            messages.append(newMessage)
        }
        messageText = ""
    }
}

// Modern Message Bubble
struct ModernMessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isFromGuest {
                // Avatar for hotel staff
                Circle()
                    .fill(Color.mainColor.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.mainColor)
                    )
            }
            
            VStack(alignment: message.isFromGuest ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(message.isFromGuest ? .white : .black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.isFromGuest ? 
                            Color.mainColor : 
                            Color.gray.opacity(0.1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text(formatMessageTime(message.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if message.isFromGuest {
                Spacer()
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Modern Message Input
struct ModernMessageInput: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                // Attachment Button
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.mainColor)
                }
                .frame(width: 44, height: 44)
                
                // Text Field
                TextField("Type a message...", text: $text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .focused($isFocused)
                
                // Send Button
                Button(action: onSend) {
                    Circle()
                        .fill(text.isEmpty ? Color.gray.opacity(0.1) : Color.mainColor)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16))
                                .foregroundColor(text.isEmpty ? .gray : .white)
                        )
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(
            Color.white
                .shadow(color: .black.opacity(0.05), radius: 20, y: -5)
        )
    }
}

// Misafir için Chat View
struct GuestChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = sampleMessages
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            CustomNavigationBar(
                title: "Hotel Support",
                color: .black
            )
            
            // Messages List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message Input
            MessageInputField(text: $messageText) {
                sendMessage()
            }
        }
        .background(Color(uiColor: .systemBackground))
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let newMessage = ChatMessage(
            id: UUID(),
            content: messageText,
            isFromGuest: true,
            timestamp: Date()
        )
        messages.append(newMessage)
        messageText = ""
    }
}

// MARK: - Supporting Views
struct ConversationRow: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Guest Name")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Text("2m ago")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text("Last message preview...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        Divider()
            .padding(.leading, 78)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromGuest {
                Spacer()
            }
            
            Text(message.content)
                .font(.system(size: 16))
                .foregroundColor(message.isFromGuest ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    message.isFromGuest ? Color.mainColor : Color.gray.opacity(0.1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if !message.isFromGuest {
                Spacer()
            }
        }
    }
}

struct MessageInputField: View {
    @Binding var text: String
    let onSend: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                TextField("Type a message...", text: $text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .focused($isFocused)
                
                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.mainColor)
                        .clipShape(Circle())
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
}

// MARK: - Models
struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isFromGuest: Bool
    let timestamp: Date
}

// Sample Data
let sampleMessages = [
    ChatMessage(id: UUID(), content: "Hello, how can I help you?", isFromGuest: false, timestamp: Date()),
    ChatMessage(id: UUID(), content: "I have a question about room service", isFromGuest: true, timestamp: Date()),
    ChatMessage(id: UUID(), content: "Of course! What would you like to know?", isFromGuest: false, timestamp: Date())
] 
