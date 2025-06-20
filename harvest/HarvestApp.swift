import SwiftUI

@main
struct HarvestApp: App {
  @State private var showSplash = true
  var body: some Scene {
    WindowGroup {
      ZStack {
        if showSplash {
          SplashScreenView()
            .transition(.opacity)
            .zIndex(1)
        } else {
          ContentView()
            .transition(.opacity)
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
