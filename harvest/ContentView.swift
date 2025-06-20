import SwiftUI

struct ContentView: View {
  @StateObject var onboardingData = OnboardingData()
  var body: some View {
    NavigationStack {
      OnboardingFlowView(onboardingData: onboardingData)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
