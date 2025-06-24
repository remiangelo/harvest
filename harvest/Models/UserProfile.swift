import Foundation
import Supabase

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var email: String
    var nickname: String
    var birthDate: String
    var age: Int {
        calculateAge(from: birthDate) ?? 0
    }
    var pronouns: String
    var gender: String
    var preference: String // Who they're interested in
    var relationshipGoals: String
    var hobbies: [String]
    var bio: String
    var photoUrls: [String]
    var location: UserLocation?
    var isVerified: Bool
    var isActive: Bool
    var lastSeen: Date
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case nickname
        case birthDate = "birth_date"
        case pronouns
        case gender
        case preference
        case relationshipGoals = "relationship_goals"
        case hobbies
        case bio
        case photoUrls = "photo_urls"
        case location
        case isVerified = "is_verified"
        case isActive = "is_active"
        case lastSeen = "last_seen"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from onboardingData: OnboardingData, userId: UUID, email: String) {
        self.id = userId
        self.email = email
        self.nickname = onboardingData.nickname
        self.birthDate = onboardingData.birthDate
        self.pronouns = onboardingData.pronouns
        self.gender = onboardingData.gender
        self.preference = onboardingData.preference
        self.relationshipGoals = onboardingData.relationshipGoals
        self.hobbies = onboardingData.hobbies
        self.bio = onboardingData.bio
        self.photoUrls = [] // Will be populated after photo upload
        self.location = onboardingData.locationAllowed ? UserLocation() : nil
        self.isVerified = false
        self.isActive = true
        self.lastSeen = Date()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct UserLocation: Codable {
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var state: String?
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case city
        case state
        case country
    }
}

struct UserPreferences: Codable {
    var minAge: Int
    var maxAge: Int
    var maxDistance: Int // in kilometers
    var interestedIn: String
    var showMe: String
    
    enum CodingKeys: String, CodingKey {
        case minAge = "min_age"
        case maxAge = "max_age"
        case maxDistance = "max_distance"
        case interestedIn = "interested_in"
        case showMe = "show_me"
    }
}

// Helper function to calculate age
func calculateAge(from birthDateString: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    guard let birthDate = formatter.date(from: birthDateString) else {
        return nil
    }
    
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
    
    return ageComponents.year
}
