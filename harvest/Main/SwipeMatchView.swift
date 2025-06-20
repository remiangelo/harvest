import SwiftUI

struct SwipeMatchView: View {
  struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let bio: String
    let image: Image
  }
  @State private var profiles: [Profile] = [
    Profile(
      name: "Alex", age: 25, bio: "Love hiking and art.",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Sam", age: 28, bio: "Coffee enthusiast and bookworm.",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Jamie", age: 22, bio: "Music is my life!",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Taylor", age: 30, bio: "Dog lover and foodie.",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Jordan", age: 27, bio: "Runner, reader, and traveler.",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Morgan", age: 24, bio: "Tech enthusiast and gamer.",
      image: Image(systemName: "person.crop.square")),
    Profile(
      name: "Casey", age: 29, bio: "Yoga, meditation, and mindfulness.",
      image: Image(systemName: "person.crop.square")),
  ]
  @State private var currentIndex: Int = 0
  @State private var showMatch = false
  var body: some View {
    VStack {
      Spacer()
      if currentIndex < profiles.count {
        let profile = profiles[currentIndex]
        VStack(spacing: 16) {
          profile.image
            .resizable()
            .scaledToFill()
            .frame(width: 220, height: 300)
            .clipped()
            .cornerRadius(24)
          Text("\(profile.name), \(profile.age)")
            .font(.title)
            .bold()
          Text(profile.bio)
            .font(.body)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white).shadow(radius: 8))
        .padding(.horizontal, 32)
      } else {
        Text("No more profiles!")
          .font(.title2)
          .foregroundColor(.gray)
      }
      Spacer()
      HStack(spacing: 40) {
        Button(action: { swipeLeft() }) {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 56, height: 56)
            .foregroundColor(.red)
        }
        Button(action: { swipeRight() }) {
          Image(systemName: "heart.circle.fill")
            .resizable()
            .frame(width: 56, height: 56)
            .foregroundColor(.green)
        }
      }
      .padding(.bottom, 48)
    }
    .background(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255).ignoresSafeArea())
    .alert(isPresented: $showMatch) {
      Alert(
        title: Text("It's a match!"),
        message: Text("You and \(profiles[currentIndex-1].name) have matched!"),
        dismissButton: .default(Text("OK")))
    }
  }
  private func swipeLeft() {
    if currentIndex < profiles.count - 1 {
      currentIndex += 1
    } else {
      currentIndex = profiles.count
    }
  }
  private func swipeRight() {
    if currentIndex < profiles.count - 1 {
      currentIndex += 1
      showMatch = true
    } else {
      currentIndex = profiles.count
    }
  }
}

struct SwipeMatchView_Previews: PreviewProvider {
  static var previews: some View {
    SwipeMatchView()
  }
}
