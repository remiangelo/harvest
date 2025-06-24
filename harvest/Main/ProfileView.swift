import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthenticationService
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Profile")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let userProfile = authService.userProfile {
                        // Profile Photos
                        TabView {
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
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 50))
                                                    .foregroundColor(.gray)
                                                Text("Add Photo")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                }
                                .frame(height: 400)
                                .clipped()
                                .cornerRadius(20)
                            }
                        }
                        .frame(height: 400)
                        .tabViewStyle(PageTabViewStyle())
                        .padding(.horizontal)
                        
                        // Profile Info
                        VStack(alignment: .leading, spacing: 20) {
                            // Name and Age
                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Text(userProfile.nickname)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Text("\(userProfile.age)")
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                if !userProfile.pronouns.isEmpty {
                                    Text(userProfile.pronouns)
                                        .font(.system(size: 18, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if userProfile.isVerified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            // Bio
                            if !userProfile.bio.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About Me")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(userProfile.bio)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            // Relationship Goals
                            if !userProfile.relationshipGoals.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Looking For")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(userProfile.relationshipGoals)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(12)
                                }
                            }
                            
                            // Hobbies
                            if !userProfile.hobbies.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interests")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 8) {
                                        ForEach(userProfile.hobbies, id: \.self) { hobby in
                                            Text(hobby)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                            
                            // Edit Profile Button
                            Button(action: {
                                showingEditProfile = true
                            }) {
                                Text("Edit Profile")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                    .cornerRadius(32)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal)
                        
                    } else {
                        // Loading state
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Text("Loading profile...")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            if let userProfile = authService.userProfile {
                EditProfileView(userProfile: userProfile)
                    .environmentObject(authService)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(authService)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationService())
    }
}
