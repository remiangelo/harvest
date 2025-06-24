import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    @EnvironmentObject var authService: AuthenticationService
    @StateObject private var matchesService = MatchesService()
    @State private var messageText = ""
    @State private var messages: [Message] = []
    
    private var otherUser: UserProfile? {
        guard let currentUserId = SupabaseManager.shared.getCurrentUser()?.id else { return nil }
        return conversation.match.getOtherUser(currentUserId: currentUserId)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    // Navigation back handled by NavigationView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                // Profile image and name
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: otherUser?.photoUrls.first ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(otherUser?.nickname ?? "Unknown")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("Active now")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // More options
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            
            // Messages
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(messages) { message in
                        MessageBubbleView(
                            message: message,
                            isFromCurrentUser: message.senderId == SupabaseManager.shared.getCurrentUser()?.id
                        )
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            
            // Message input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(24)
                    .lineLimit(1...4)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                       .secondary : Color(red: 128/255, green: 23/255, blue: 36/255))
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .onAppear {
            messages = conversation.messages
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        let tempMessage = Message(
            matchId: conversation.match.id,
            senderId: SupabaseManager.shared.getCurrentUser()?.id ?? UUID(),
            content: trimmedMessage
        )
        
        // Add message optimistically
        messages.append(tempMessage)
        messageText = ""
        
        Task {
            let success = await matchesService.sendMessage(to: conversation.match.id, content: trimmedMessage)
            if !success {
                // Remove the optimistic message if sending failed
                if let index = messages.firstIndex(where: { $0.id == tempMessage.id }) {
                    messages.remove(at: index)
                }
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        isFromCurrentUser ? 
                        Color(red: 128/255, green: 23/255, blue: 36/255) : 
                        Color(.secondarySystemBackground)
                    )
                    .cornerRadius(20)
                
                Text(message.createdAt, style: .time)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isFromCurrentUser ? .trailing : .leading)
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMatch = Match(
            id: UUID(),
            user1Id: UUID(),
            user2Id: UUID(),
            user1: UserProfile(
                id: UUID(),
                email: "user1@example.com",
                nickname: "Alice",
                birthDate: "1995-01-01",
                pronouns: "she/her",
                gender: "woman",
                preference: "men",
                relationshipGoals: "Long-term",
                hobbies: ["Reading"],
                bio: "Love books!",
                photoUrls: [],
                location: nil,
                isVerified: true,
                isActive: true,
                lastSeen: Date(),
                createdAt: Date(),
                updatedAt: Date()
            ),
            user2: UserProfile(
                id: UUID(),
                email: "user2@example.com",
                nickname: "Bob",
                birthDate: "1993-01-01",
                pronouns: "he/him",
                gender: "man",
                preference: "women",
                relationshipGoals: "Long-term",
                hobbies: ["Sports"],
                bio: "Love sports!",
                photoUrls: [],
                location: nil,
                isVerified: true,
                isActive: true,
                lastSeen: Date(),
                createdAt: Date(),
                updatedAt: Date()
            ),
            createdAt: Date()
        )
        
        let sampleConversation = Conversation(match: sampleMatch, messages: [])
        
        ChatDetailView(conversation: sampleConversation)
            .environmentObject(AuthenticationService())
    }
}
