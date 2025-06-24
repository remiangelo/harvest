import SwiftUI

struct ChatReflectionsView: View {
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
                    
                    Text("Chat Reflections")
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
                    Text("Your Conversation Insights")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    
                    Text("Gardener AI analyzes your conversations and provides insights to help improve your communication skills.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Reflections List
                VStack(spacing: 16) {
                    ForEach(SampleData.chatReflections) { reflection in
                        ReflectionCard(reflection: reflection)
                    }
                }
                .padding(.horizontal)
                
                // Empty state (if needed)
                if SampleData.chatReflections.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.5))
                        
                        Text("No reflections yet")
                            .font(.system(size: 18, weight: .bold))
                        
                        Text("Start conversations with your matches to receive personalized insights.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                }
            }
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}

struct ReflectionCard: View {
    let reflection: ChatReflection
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with match info
            if let matchName = reflection.matchName {
                HStack(spacing: 12) {
                    if let matchImage = reflection.matchImage {
                        Image(systemName: matchImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Conversation with \(matchName)")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(formatDate(reflection.date))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Title & Message
            Text(reflection.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
            
            Text(reflection.message)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 3)
            
            // "Read more" button if needed
            if !isExpanded {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text("Read more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                }
            }
            
            // Action buttons
            HStack {
                Button(action: {}) {
                    Label("Save", systemImage: "bookmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                        .cornerRadius(20)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Label("Apply to Conversations", systemImage: "arrow.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .cornerRadius(20)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct ChatReflectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatReflectionsView()
    }
}
