import SwiftUI

struct MatchesView: View {
    @EnvironmentObject var authService: AuthenticationService
    @StateObject private var matchesService = MatchesService()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Matches")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                if matchesService.matches.isEmpty {
                    // Empty state
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "heart.text.square")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No matches yet")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("Start swiping to find your matches!")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    // Matches list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(matchesService.conversations) { conversation in
                                NavigationLink(destination: ChatDetailView(conversation: conversation)) {
                                    MatchRowView(conversation: conversation)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                Task {
                    await matchesService.loadMatches()
                }
            }
        }
    }
}

struct MatchRowView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image
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
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(otherUser?.nickname ?? "Unknown")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.createdAt, style: .time)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage.content)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                } else {
                    Text("Say hello! 👋")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            if conversation.unreadCount > 0 {
                Circle()
                    .fill(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("\(conversation.unreadCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private var otherUser: UserProfile? {
        guard let currentUserId = SupabaseManager.shared.getCurrentUser()?.id else { return nil }
        return conversation.match.getOtherUser(currentUserId: currentUserId)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
            .environmentObject(AuthenticationService())
    }
}
