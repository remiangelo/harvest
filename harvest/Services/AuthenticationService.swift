import Foundation
import SwiftUI
import Supabase

@MainActor
class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared
    
    init() {
        checkAuthStatus()
    }
    
    // MARK: - Authentication Status
    
    func checkAuthStatus() {
        currentUser = supabase.getCurrentUser()
        isAuthenticated = currentUser != nil
        
        if let user = currentUser {
            Task {
                await loadUserProfile(userId: user.id)
            }
        }
    }
    
    // MARK: - Sign Up Flow
    
    func signUpWithOnboardingData(_ onboardingData: OnboardingData, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Create auth user
            let authResponse = try await supabase.signUp(email: email, password: password)
            
            guard let user = authResponse.user else {
                throw AuthError.userCreationFailed
            }
            
            // 2. Upload photos first
            var photoUrls: [String] = []
            for (index, photo) in onboardingData.photos.enumerated() {
                if let imageData = photo.jpegData(compressionQuality: 0.8) {
                    let fileName = "\(user.id)/photo_\(index).jpg"
                    let url = try await supabase.uploadPhoto(imageData, fileName: fileName)
                    photoUrls.append(url)
                }
            }
            
            // 3. Create user profile
            var userProfile = UserProfile(from: onboardingData, userId: user.id, email: email)
            userProfile.photoUrls = photoUrls
            
            try await supabase.createUserProfile(userProfile)
            
            // 4. Create default preferences
            let preferences = UserPreferences(
                minAge: 18,
                maxAge: 99,
                maxDistance: 50,
                interestedIn: onboardingData.preference,
                showMe: "active"
            )
            
            // 5. Update local state
            self.currentUser = user
            self.userProfile = userProfile
            self.isAuthenticated = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let authResponse = try await supabase.signIn(email: email, password: password)
            
            guard let user = authResponse.user else {
                throw AuthError.signInFailed
            }
            
            await loadUserProfile(userId: user.id)
            
            self.currentUser = user
            self.isAuthenticated = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    
    func signOut() async {
        do {
            try await supabase.signOut()
            
            self.currentUser = nil
            self.userProfile = nil
            self.isAuthenticated = false
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Profile Management
    
    private func loadUserProfile(userId: UUID) async {
        do {
            userProfile = try await supabase.getUserProfile(userId: userId)
        } catch {
            errorMessage = "Failed to load user profile: \(error.localizedDescription)"
        }
    }
    
    func updateUserProfile(_ profile: UserProfile) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await supabase.updateUserProfile(profile)
            self.userProfile = profile
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Photo Management
    
    func uploadNewPhoto(_ image: UIImage) async -> String? {
        guard let user = currentUser,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        do {
            let fileName = "\(user.id)/photo_\(UUID().uuidString).jpg"
            return try await supabase.uploadPhoto(imageData, fileName: fileName)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}

// MARK: - Custom Errors

enum AuthError: LocalizedError {
    case userCreationFailed
    case signInFailed
    case profileCreationFailed
    
    var errorDescription: String? {
        switch self {
        case .userCreationFailed:
            return "Failed to create user account"
        case .signInFailed:
            return "Failed to sign in"
        case .profileCreationFailed:
            return "Failed to create user profile"
        }
    }
}
