import SwiftUI

struct MatchPracticeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    }
                    
                    Spacer()
                    
                    Text("Match Practice")
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    // Empty view for alignment
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Explanation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Improve Your Messaging Skills")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    
                    Text("Practice messaging in different scenarios to build confidence and improve your communication.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Practice Scenarios
                VStack(spacing: 16) {
                    ForEach(SampleData.matchPracticeScenarios) { scenario in
                        NavigationLink(destination: PracticeScenarioDetailView(scenario: scenario)) {
                            PracticeScenarioCard(scenario: scenario)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Recent practice sessions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Practice Sessions")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.horizontal)
                    
                    // Sample sessions (empty state handled)
                    if true { // Replace with actual condition
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("First Message Practice")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("2 days ago • Score: 8/10")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Text("Great opener!")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                    
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        Text("No recent practice sessions")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}

struct PracticeScenarioCard: View {
    let scenario: MatchPracticeScenario
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(scenario.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                
                Text(scenario.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Label("Start Practice", systemImage: "play.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .cornerRadius(16)
            }
            
            Spacer()
            
            if let image = scenario.image {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .padding(8)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                    .cornerRadius(16)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct PracticeScenarioDetailView: View {
    let scenario: MatchPracticeScenario
    @Environment(\.presentationMode) var presentationMode
    @State private var messageText = ""
    @State private var conversation: [Message] = [
        Message(content: "Hi there! I noticed we both love hiking. What's your favorite trail?", isUser: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                }
                
                Spacer()
                
                VStack {
                    Text("Practice: \(scenario.title)")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("with Gardener AI")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Conversation
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(conversation) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            messageText.isEmpty ? 
                            Color(.systemGray) : 
                            Color(red: 128/255, green: 23/255, blue: 36/255)
                        )
                        .cornerRadius(20)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: messageText, isUser: true)
        conversation.append(userMessage)
        messageText = ""
        
        // Simulate AI response after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = Message(content: "That's a great response! You've shown interest and asked a specific question. Consider adding a bit about your own favorite trail next time to make it more personal.", isUser: false)
            conversation.append(aiResponse)
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? 
                        Color(red: 128/255, green: 23/255, blue: 36/255) : 
                        Color(.systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(18)
                    .cornerRadius(message.isUser ? 18 : 18, corners: message.isUser ? [.topLeft, .bottomLeft, .bottomRight] : [.topRight, .bottomLeft, .bottomRight])
            }
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, 
            byRoundingCorners: corners, 
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MatchPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchPracticeView()
    }
}
