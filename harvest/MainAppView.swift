import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authService: AuthenticationService
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Discover/Swiping Tab
            DiscoverView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Discover")
                }
                .tag(0)
            
            // Matches Tab
            MatchesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Matches")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Color(red: 128/255, green: 23/255, blue: 36/255))
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
            .environmentObject(AuthenticationService())
    }
}
