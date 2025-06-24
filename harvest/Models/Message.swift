import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    let matchId: UUID
    let senderId: UUID
    let content: String
    let messageType: MessageType
    let createdAt: Date
    var isRead: Bool
    var readAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchId = "match_id"
        case senderId = "sender_id"
        case content
        case messageType = "message_type"
        case createdAt = "created_at"
        case isRead = "is_read"
        case readAt = "read_at"
    }
    
    init(matchId: UUID, senderId: UUID, content: String, messageType: MessageType = .text) {
        self.id = UUID()
        self.matchId = matchId
        self.senderId = senderId
        self.content = content
        self.messageType = messageType
        self.createdAt = Date()
        self.isRead = false
        self.readAt = nil
    }
}

enum MessageType: String, Codable, CaseIterable {
    case text = "text"
    case image = "image"
    case gif = "gif"
    case system = "system" // For system messages like "You matched!"
}

struct Conversation: Identifiable {
    let id: UUID
    let match: Match
    let messages: [Message]
    let lastMessage: Message?
    let unreadCount: Int
    
    init(match: Match, messages: [Message]) {
        self.id = match.id
        self.match = match
        self.messages = messages.sorted { $0.createdAt < $1.createdAt }
        self.lastMessage = messages.max { $0.createdAt < $1.createdAt }
        self.unreadCount = messages.filter { !$0.isRead }.count
    }
}
