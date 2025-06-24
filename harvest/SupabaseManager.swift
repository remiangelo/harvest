import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Replace with your actual Supabase project credentials
        let supabaseURL = URL(string: "https://ajuxvdtylcppakxipaus.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqdXh2ZHR5bGNwcGFreGlwYXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk0ODI3MTgsImV4cCI6MjA2NTA1ODcxOH0.3ltHluC67rk23g3wNeUtYHgzvA7Es7nwlGU5m0Z8sW4"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> AuthResponse {
        return try await client.auth.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        return try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() -> User? {
        return client.auth.currentUser
    }
    
    func getCurrentSession() -> Session? {
        return client.auth.currentSession
    }
    
    // MARK: - Profile Management
    
    func createUserProfile(_ profile: UserProfile) async throws {
        try await client.database
            .from("users")
            .insert(profile)
            .execute()
    }
    
    func updateUserProfile(_ profile: UserProfile) async throws {
        try await client.database
            .from("users")
            .update(profile)
            .eq("id", value: profile.id)
            .execute()
    }
    
    func getUserProfile(userId: UUID) async throws -> UserProfile? {
        let response: [UserProfile] = try await client.database
            .from("users")
            .select()
            .eq("id", value: userId)
            .execute()
            .value
        
        return response.first
    }
    
    // MARK: - Photo Upload
    
    func uploadPhoto(_ imageData: Data, fileName: String) async throws -> String {
        let file = File(name: fileName, data: imageData, fileName: fileName, contentType: "image/jpeg")
        
        try await client.storage
            .from("profile-photos")
            .upload(path: fileName, file: file)
        
        let url = try client.storage
            .from("profile-photos")
            .getPublicURL(path: fileName)
        
        return url.absoluteString
    }
    
    // MARK: - Matching & Swiping
    
    func getPotentialMatches(for userId: UUID, preferences: UserPreferences) async throws -> [UserProfile] {
        // Basic query - can be enhanced with more complex filtering
        let response: [UserProfile] = try await client.database
            .from("users")
            .select()
            .neq("id", value: userId)
            .execute()
            .value
        
        return response
    }
    
    func recordSwipe(_ swipe: SwipeRecord) async throws {
        try await client.database
            .from("swipes")
            .insert(swipe)
            .execute()
    }
    
    func getMatches(for userId: UUID) async throws -> [Match] {
        let response: [Match] = try await client.database
            .from("matches")
            .select("*, user1:users!matches_user1_id_fkey(*), user2:users!matches_user2_id_fkey(*)")
            .or("user1_id.eq.\(userId),user2_id.eq.\(userId)")
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Messaging
    
    func sendMessage(_ message: Message) async throws {
        try await client.database
            .from("messages")
            .insert(message)
            .execute()
    }
    
    func getMessages(for matchId: UUID) async throws -> [Message] {
        let response: [Message] = try await client.database
            .from("messages")
            .select()
            .eq("match_id", value: matchId)
            .order("created_at", ascending: true)
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Real-time Subscriptions
    
    func subscribeToMessages(matchId: UUID, onMessage: @escaping (Message) -> Void) -> RealtimeChannel {
        return client.realtime
            .channel("messages:\(matchId)")
            .on(.insert) { payload in
                if let message = try? payload.decodeRecord(as: Message.self) {
                    onMessage(message)
                }
            }
    }
}
