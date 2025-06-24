import SwiftUI

struct SwipeableProfileCard: View {
    let profile: UserProfile
    let isTopCard: Bool
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var rotationAngle: Double = 0
    
    private let swipeThreshold: CGFloat = 100
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 0) {
                // Profile Image
                AsyncImage(url: URL(string: profile.photoUrls.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 400)
                .clipped()
                .cornerRadius(20, corners: [.topLeft, .topRight])
                
                // Profile Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(profile.nickname)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("\(profile.age)")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        if !profile.pronouns.isEmpty {
                            Text(profile.pronouns)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if !profile.bio.isEmpty {
                        Text(profile.bio)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .lineLimit(3)
                    }
                    
                    // Hobbies
                    if !profile.hobbies.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(profile.hobbies.prefix(3), id: \.self) { hobby in
                                    Text(hobby)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                        .cornerRadius(16)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Swipe indicators
            if isTopCard {
                VStack {
                    HStack {
                        // NOPE indicator
                        Text("NOPE")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .rotationEffect(.degrees(-30))
                            .opacity(dragOffset.width < -50 ? 1 : 0)
                            .animation(.easeInOut(duration: 0.2), value: dragOffset.width)
                        
                        Spacer()
                        
                        // LIKE indicator
                        Text("LIKE")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .rotationEffect(.degrees(30))
                            .opacity(dragOffset.width > 50 ? 1 : 0)
                            .animation(.easeInOut(duration: 0.2), value: dragOffset.width)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        }
        .offset(dragOffset)
        .rotationEffect(.degrees(rotationAngle))
        .gesture(
            isTopCard ? DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    rotationAngle = Double(value.translation.width / 20)
                }
                .onEnded { value in
                    let swipeThreshold: CGFloat = 100
                    
                    if abs(value.translation.x) > swipeThreshold {
                        // Determine swipe direction
                        let direction: SwipeDirection = value.translation.x > 0 ? .right : .left
                        
                        // Animate card off screen
                        withAnimation(.easeOut(duration: 0.3)) {
                            dragOffset = CGSize(
                                width: value.translation.x > 0 ? 1000 : -1000,
                                height: value.translation.y
                            )
                            rotationAngle = value.translation.x > 0 ? 30 : -30
                        }
                        
                        // Call completion after animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwipe(direction)
                        }
                    } else {
                        // Snap back to center
                        withAnimation(.spring()) {
                            dragOffset = .zero
                            rotationAngle = 0
                        }
                    }
                } : nil
        )
    }
}

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

struct SwipeableProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableProfileCard(
            profile: UserProfile(
                id: UUID(),
                email: "test@example.com",
                nickname: "Alex",
                birthDate: "1995-01-01",
                pronouns: "they/them",
                gender: "non-binary",
                preference: "everyone",
                relationshipGoals: "Long-term",
                hobbies: ["Photography", "Hiking", "Cooking"],
                bio: "Love exploring new places and trying new foods!",
                photoUrls: [],
                location: nil,
                isVerified: true,
                isActive: true,
                lastSeen: Date(),
                createdAt: Date(),
                updatedAt: Date()
            ),
            isTopCard: true
        ) { _ in }
        .padding()
    }
}
