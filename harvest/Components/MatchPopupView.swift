import SwiftUI

struct MatchPopupView: View {
    let matchedUser: UserProfile
    let onDismiss: () -> Void
    
    @State private var showingHearts = false
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 30) {
                // Title
                Text("It's a Match!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: scale)
                
                // Profile images
                HStack(spacing: -30) {
                    // Current user placeholder (would need actual user photo)
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                    
                    // Matched user
                    AsyncImage(url: URL(string: matchedUser.photoUrls.first ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                }
                .scaleEffect(scale)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: scale)
                
                // Matched user info
                VStack(spacing: 8) {
                    Text("You and \(matchedUser.nickname) liked each other!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    if !matchedUser.bio.isEmpty {
                        Text(matchedUser.bio)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                .scaleEffect(scale)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: scale)
                
                // Action buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to chat
                        onDismiss()
                    }) {
                        Text("Send Message")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                            .cornerRadius(32)
                    }
                    
                    Button(action: {
                        onDismiss()
                    }) {
                        Text("Keep Swiping")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 40)
                .scaleEffect(scale)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: scale)
            }
            .padding()
            
            // Floating hearts animation
            if showingHearts {
                ForEach(0..<6, id: \.self) { index in
                    FloatingHeart(delay: Double(index) * 0.2)
                }
            }
        }
        .onAppear {
            scale = 1.0
            showingHearts = true
        }
    }
}

struct FloatingHeart: View {
    let delay: Double
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 20))
            .foregroundColor(.red)
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0).delay(delay)) {
                    offset = -200
                    opacity = 0
                }
                withAnimation(.easeIn(duration: 0.3).delay(delay)) {
                    opacity = 1
                }
            }
    }
}

struct MatchPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MatchPopupView(
            matchedUser: UserProfile(
                id: UUID(),
                email: "test@example.com",
                nickname: "Alex",
                birthDate: "1995-01-01",
                pronouns: "they/them",
                gender: "non-binary",
                preference: "everyone",
                relationshipGoals: "Long-term",
                hobbies: ["Photography", "Hiking"],
                bio: "Love exploring new places!",
                photoUrls: [],
                location: nil,
                isVerified: true,
                isActive: true,
                lastSeen: Date(),
                createdAt: Date(),
                updatedAt: Date()
            )
        ) {}
    }
}
