import Foundation

struct SwipeRecord: Codable, Identifiable {
    let id: UUID
    let swiperId: UUID
    let swipedUserId: UUID
    let isLike: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case swiperId = "swiper_id"
        case swipedUserId = "swiped_user_id"
        case isLike = "is_like"
        case createdAt = "created_at"
    }
    
    init(swiperId: UUID, swipedUserId: UUID, isLike: Bool) {
        self.id = UUID()
        self.swiperId = swiperId
        self.swipedUserId = swipedUserId
        self.isLike = isLike
        self.createdAt = Date()
    }
}

struct Match: Codable, Identifiable {
    let id: UUID
    let user1Id: UUID
    let user2Id: UUID
    let createdAt: Date
    var lastMessageAt: Date?
    var isActive: Bool
    
    // Populated by joins in queries
    var user1: UserProfile?
    var user2: UserProfile?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case createdAt = "created_at"
        case lastMessageAt = "last_message_at"
        case isActive = "is_active"
        case user1
        case user2
    }
    
    init(user1Id: UUID, user2Id: UUID) {
        self.id = UUID()
        self.user1Id = user1Id
        self.user2Id = user2Id
        self.createdAt = Date()
        self.lastMessageAt = nil
        self.isActive = true
    }
    
    // Helper to get the other user in the match
    func getOtherUser(currentUserId: UUID) -> UserProfile? {
        if user1Id == currentUserId {
            return user2
        } else if user2Id == currentUserId {
            return user1
        }
        return nil
    }
}
