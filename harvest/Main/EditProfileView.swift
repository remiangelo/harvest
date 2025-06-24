import SwiftUI

struct EditProfileView: View {
    let userProfile: UserProfile
    @EnvironmentObject var authService: AuthenticationService
    @Environment(\.dismiss) private var dismiss
    
    @State private var nickname: String
    @State private var bio: String
    @State private var relationshipGoals: String
    @State private var hobbies: [String]
    @State private var newHobby = ""
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        self._nickname = State(initialValue: userProfile.nickname)
        self._bio = State(initialValue: userProfile.bio)
        self._relationshipGoals = State(initialValue: userProfile.relationshipGoals)
        self._hobbies = State(initialValue: userProfile.hobbies)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Photos Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Photos")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(userProfile.photoUrls.isEmpty ? [""] : userProfile.photoUrls, id: \.self) { photoUrl in
                                    AsyncImage(url: URL(string: photoUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .overlay(
                                                VStack {
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 30))
                                                        .foregroundColor(.gray)
                                                    Text("Add Photo")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(.gray)
                                                }
                                            )
                                    }
                                    .frame(width: 120, height: 160)
                                    .clipped()
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Basic Info Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Basic Info")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nickname")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            TextField("Enter your nickname", text: $nickname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bio")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            TextField("Tell us about yourself...", text: $bio, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Looking For")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            TextField("What are you looking for?", text: $relationshipGoals)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Interests Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Interests")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        // Current hobbies
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(hobbies, id: \.self) { hobby in
                                HStack {
                                    Text(hobby)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Button(action: {
                                        hobbies.removeAll { $0 == hobby }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .cornerRadius(16)
                            }
                        }
                        
                        // Add new hobby
                        HStack {
                            TextField("Add interest", text: $newHobby)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: addHobby) {
                                Text("Add")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                    .cornerRadius(8)
                            }
                            .disabled(newHobby.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(isLoading)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func addHobby() {
        let trimmedHobby = newHobby.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedHobby.isEmpty && !hobbies.contains(trimmedHobby) else { return }
        
        hobbies.append(trimmedHobby)
        newHobby = ""
    }
    
    private func saveProfile() {
        isLoading = true
        
        Task {
            do {
                var updatedProfile = userProfile
                updatedProfile.nickname = nickname
                updatedProfile.bio = bio
                updatedProfile.relationshipGoals = relationshipGoals
                updatedProfile.hobbies = hobbies
                
                try await authService.updateUserProfile(updatedProfile)
                
                await MainActor.run {
                    dismiss()
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(
            userProfile: UserProfile(
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
        )
        .environmentObject(AuthenticationService())
    }
}
