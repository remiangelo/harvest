import Foundation
import SwiftUI

@MainActor
class MatchesService: ObservableObject {
    @Published var matches: [Match] = []
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared
    
    func loadMatches() async {
        guard let currentUser = supabase.getCurrentUser() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedMatches = try await supabase.getMatches(for: currentUser.id)
            self.matches = fetchedMatches
            
            // Load conversations for each match
            var conversations: [Conversation] = []
            
            for match in fetchedMatches {
                let messages = try await supabase.getMessages(for: match.id)
                let conversation = Conversation(match: match, messages: messages)
                conversations.append(conversation)
            }
            
            // Sort by most recent activity
            self.conversations = conversations.sorted { conv1, conv2 in
                let date1 = conv1.lastMessage?.createdAt ?? conv1.match.createdAt
                let date2 = conv2.lastMessage?.createdAt ?? conv2.match.createdAt
                return date1 > date2
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func sendMessage(to matchId: UUID, content: String) async -> Bool {
        guard let currentUser = supabase.getCurrentUser() else { return false }
        
        let message = Message(
            matchId: matchId,
            senderId: currentUser.id,
            content: content
        )
        
        do {
            try await supabase.sendMessage(message)
            
            // Update local conversations
            if let index = conversations.firstIndex(where: { $0.id == matchId }) {
                var updatedConversation = conversations[index]
                var updatedMessages = updatedConversation.messages
                updatedMessages.append(message)
                
                let newConversation = Conversation(
                    match: updatedConversation.match,
                    messages: updatedMessages
                )
                
                conversations[index] = newConversation
                
                // Move to top of list
                conversations.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
            }
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
