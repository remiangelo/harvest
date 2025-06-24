import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthenticationService
    @Environment(\.dismiss) private var dismiss
    @State private var showingSignOutAlert = false
    @State private var showingDeleteAccountAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section("Account") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(authService.userProfile?.nickname ?? "Unknown")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(authService.userProfile?.email ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                // Preferences Section
                Section("Preferences") {
                    NavigationLink(destination: DiscoverySettingsView()) {
                        Label("Discovery Settings", systemImage: "slider.horizontal.3")
                    }
                    
                    NavigationLink(destination: NotificationSettingsView()) {
                        Label("Notifications", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: PrivacySettingsView()) {
                        Label("Privacy", systemImage: "lock")
                    }
                }
                
                // Support Section
                Section("Support") {
                    NavigationLink(destination: HelpView()) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: FeedbackView()) {
                        Label("Send Feedback", systemImage: "envelope")
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                }
                
                // Account Actions Section
                Section("Account Actions") {
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        Label("Sign Out", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showingDeleteAccountAlert = true
                    }) {
                        Label("Delete Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                Task {
                    await authService.signOut()
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle account deletion
                dismiss()
            }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
}

// Placeholder views for settings screens
struct DiscoverySettingsView: View {
    var body: some View {
        List {
            Section("Age Range") {
                HStack {
                    Text("18")
                    Slider(value: .constant(25), in: 18...99)
                    Text("99")
                }
            }
            
            Section("Distance") {
                HStack {
                    Text("1 km")
                    Slider(value: .constant(50), in: 1...100)
                    Text("100 km")
                }
            }
            
            Section("Show Me") {
                Picker("Show Me", selection: .constant("everyone")) {
                    Text("Everyone").tag("everyone")
                    Text("Men").tag("men")
                    Text("Women").tag("women")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationTitle("Discovery")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSettingsView: View {
    @State private var pushNotifications = true
    @State private var newMatches = true
    @State private var messages = true
    @State private var likes = false
    
    var body: some View {
        List {
            Section("Push Notifications") {
                Toggle("Enable Push Notifications", isOn: $pushNotifications)
            }
            
            Section("Notification Types") {
                Toggle("New Matches", isOn: $newMatches)
                Toggle("Messages", isOn: $messages)
                Toggle("Likes", isOn: $likes)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySettingsView: View {
    @State private var showDistance = true
    @State private var showAge = true
    @State private var incognitoMode = false
    
    var body: some View {
        List {
            Section("Profile Visibility") {
                Toggle("Show Distance", isOn: $showDistance)
                Toggle("Show Age", isOn: $showAge)
            }
            
            Section("Privacy") {
                Toggle("Incognito Mode", isOn: $incognitoMode)
            }
            
            Section(footer: Text("In incognito mode, you won't appear in the discovery stack unless you like someone first.")) {
                EmptyView()
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Section("Common Questions") {
                NavigationLink("How does matching work?", destination: Text("Matching explanation"))
                NavigationLink("How to report someone?", destination: Text("Reporting explanation"))
                NavigationLink("Account verification", destination: Text("Verification explanation"))
            }
            
            Section("Contact") {
                Link("Email Support", destination: URL(string: "mailto:support@harvest.app")!)
                Link("Visit Website", destination: URL(string: "https://harvest.app")!)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedbackView: View {
    @State private var feedbackText = ""
    @State private var feedbackType = "General"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("We'd love to hear from you!")
                    .font(.system(size: 18, weight: .semibold))
                
                Picker("Feedback Type", selection: $feedbackType) {
                    Text("General").tag("General")
                    Text("Bug Report").tag("Bug")
                    Text("Feature Request").tag("Feature")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Your feedback:")
                    .font(.system(size: 16, weight: .medium))
                
                TextEditor(text: $feedbackText)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                Button("Send Feedback") {
                    // Handle feedback submission
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
            
            Text("Harvest")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("Version 1.0.0")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            Text("Find meaningful connections and grow together.")
                .font(.system(size: 18))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                Link("Terms of Service", destination: URL(string: "https://harvest.app/terms")!)
                Link("Privacy Policy", destination: URL(string: "https://harvest.app/privacy")!)
            }
            .font(.system(size: 16))
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthenticationService())
    }
}
