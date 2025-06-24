import SwiftUI

@main
struct HarvestApp: App {
  @State private var showSplash = true
  @StateObject private var authService = AuthenticationService()
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        if showSplash {
          SplashScreenView()
            .transition(.opacity)
            .zIndex(1)
        } else {
          if authService.isAuthenticated {
            MainAppView()
              .environmentObject(authService)
          } else {
            AuthenticationView()
              .environmentObject(authService)
          }
        }
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          withAnimation {
            showSplash = false
          }
        }
      }
    }
  }
}
