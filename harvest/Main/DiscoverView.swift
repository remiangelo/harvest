import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var authService: AuthenticationService
    @StateObject private var discoverService = DiscoverService()
    @State private var currentCardIndex = 0
    @State private var dragOffset = CGSize.zero
    @State private var showingMatchPopup = false
    @State private var newMatch: UserProfile?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Text("Discover")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            // Settings action
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
                    
                    // Card Stack
                    ZStack {
                        if discoverService.potentialMatches.isEmpty {
                            // Empty state
                            VStack(spacing: 20) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 60))
                                    .foregroundColor(.secondary)
                                
                                Text("No more profiles")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Check back later for new people!")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Refresh") {
                                    Task {
                                        await discoverService.loadPotentialMatches()
                                    }
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                            .padding()
                        } else {
                            ForEach(Array(discoverService.potentialMatches.enumerated().reversed()), id: \.element.id) { index, profile in
                                if index >= currentCardIndex && index < currentCardIndex + 3 {
                                    SwipeableProfileCard(
                                        profile: profile,
                                        isTopCard: index == currentCardIndex,
                                        onSwipe: { direction in
                                            handleSwipe(direction: direction, profile: profile)
                                        }
                                    )
                                    .zIndex(Double(discoverService.potentialMatches.count - index))
                                    .scaleEffect(index == currentCardIndex ? 1.0 : 0.95)
                                    .offset(y: index == currentCardIndex ? 0 : CGFloat((index - currentCardIndex) * 10))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 40) {
                        // Pass Button
                        Button(action: {
                            if currentCardIndex < discoverService.potentialMatches.count {
                                handleSwipe(direction: .left, profile: discoverService.potentialMatches[currentCardIndex])
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        
                        // Super Like Button
                        Button(action: {
                            // Super like action
                        }) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        
                        // Like Button
                        Button(action: {
                            if currentCardIndex < discoverService.potentialMatches.count {
                                handleSwipe(direction: .right, profile: discoverService.potentialMatches[currentCardIndex])
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            Task {
                await discoverService.loadPotentialMatches()
            }
        }
        .fullScreenCover(isPresented: $showingMatchPopup) {
            if let match = newMatch {
                MatchPopupView(matchedUser: match) {
                    showingMatchPopup = false
                    newMatch = nil
                }
            }
        }
    }
    
    private func handleSwipe(direction: SwipeDirection, profile: UserProfile) {
        Task {
            let isMatch = await discoverService.swipe(on: profile, direction: direction)
            
            if isMatch && direction == .right {
                newMatch = profile
                showingMatchPopup = true
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                currentCardIndex += 1
            }
        }
    }
}

enum SwipeDirection {
    case left, right, up
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 128/255, green: 23/255, blue: 36/255))
            .cornerRadius(32)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .environmentObject(AuthenticationService())
    }
}
