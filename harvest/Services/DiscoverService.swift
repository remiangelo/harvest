import Foundation
import SwiftUI

@MainActor
class DiscoverService: ObservableObject {
    @Published var potentialMatches: [UserProfile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared
    
    func loadPotentialMatches() async {
        guard let currentUser = supabase.getCurrentUser() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Get user preferences (for now using default preferences)
            let preferences = UserPreferences(
                minAge: 18,
                maxAge: 99,
                maxDistance: 50,
                interestedIn: "everyone",
                showMe: "active"
            )
            
            let matches = try await supabase.getPotentialMatches(for: currentUser.id, preferences: preferences)
            
            // Filter out users we've already swiped on
            let filteredMatches = await filterAlreadySwipedUsers(matches, currentUserId: currentUser.id)
            
            self.potentialMatches = filteredMatches
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func swipe(on profile: UserProfile, direction: SwipeDirection) async -> Bool {
        guard let currentUser = supabase.getCurrentUser() else { return false }
        
        let isLike = direction == .right
        let swipeRecord = SwipeRecord(
            swiperId: currentUser.id,
            swipedUserId: profile.id,
            isLike: isLike
        )
        
        do {
            try await supabase.recordSwipe(swipeRecord)
            
            // Check if this created a match
            if isLike {
                let matches = try await supabase.getMatches(for: currentUser.id)
                return matches.contains { match in
                    (match.user1Id == currentUser.id && match.user2Id == profile.id) ||
                    (match.user2Id == currentUser.id && match.user1Id == profile.id)
                }
            }
            
            return false
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    private func filterAlreadySwipedUsers(_ users: [UserProfile], currentUserId: UUID) async -> [UserProfile] {
        // For now, return all users. In a real implementation, we'd query the swipes table
        // to filter out users we've already swiped on
        return users
    }
}
