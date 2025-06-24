import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthenticationService
    @State private var showingGardenerAI = false
    @State private var showingGrowthLessons = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Features")) {
                    // Gardener AI Button
                    Button(action: {
                        showingGardenerAI = true
                    }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Gardener AI")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                    
                    // Growth Lessons Button
                    Button(action: {
                        showingGrowthLessons = true
                    }) {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Growth Lessons")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                }
                
                Section(header: Text("Account")) {
                    // Edit Profile
                    NavigationLink(destination: Text("Edit Profile")) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Edit Profile")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Notifications
                    NavigationLink(destination: Text("Notification Settings")) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Notifications")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Privacy Settings
                    NavigationLink(destination: Text("Privacy Settings")) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Privacy")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section(header: Text("Support")) {
                    // Help Center
                    NavigationLink(destination: Text("Help Center")) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("Help Center")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // About
                    NavigationLink(destination: Text("About Harvest")) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .font(.system(size: 20))
                            
                            Text("About")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section {
                    // Sign Out Button
                    Button(action: {
                        authService.signOut()
                    }) {
                        HStack {
                            Spacer()
                            
                            Text("Sign Out")
                                .foregroundColor(.red)
                                .font(.system(size: 16, weight: .medium))
                            
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            })
        }
        .fullScreenCover(isPresented: $showingGardenerAI) {
            GardenerAIOptionsView()
        }
        .fullScreenCover(isPresented: $showingGrowthLessons) {
            GrowthLessonsView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthenticationService())
    }
}
