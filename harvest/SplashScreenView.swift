import SwiftUI

struct SplashScreenView: View {
  @State private var opacity: Double = 0
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      Text("Harvest")
        .font(.system(size: 48, weight: .bold, design: .rounded))
        .foregroundColor(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255))
        .opacity(opacity)
        .onAppear {
          withAnimation(.easeInOut(duration: 1.2)) {
            opacity = 1
          }
        }
    }
  }
}

struct SplashScreenView_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreenView()
  }
}
