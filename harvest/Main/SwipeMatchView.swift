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
    ZStack {
      Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255).ignoresSafeArea()
      if currentIndex < profiles.count {
        let profile = profiles[currentIndex]
        VStack {
          Spacer()
          ZStack(alignment: .bottom) {
            profile.image
              .resizable()
              .scaledToFill()
              .frame(width: 260, height: 360)
              .clipped()
              .cornerRadius(32)
              .shadow(radius: 12)
            VStack(alignment: .leading, spacing: 8) {
              Text("\(profile.name), \(profile.age)")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
              Text(profile.bio)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
              RoundedRectangle(cornerRadius: 28).fill(.ultraThinMaterial).shadow(radius: 4)
            )
            .offset(y: 24)
          }
          .frame(width: 260, height: 400)
          .padding(.bottom, 32)
          HStack(spacing: 40) {
            Button(action: { swipeLeft() }) {
              Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.red)
                .background(Circle().fill(.ultraThinMaterial).shadow(radius: 2))
            }
            Button(action: { swipeRight() }) {
              Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.green)
                .background(Circle().fill(.ultraThinMaterial).shadow(radius: 2))
            }
          }
          .padding(.top, -16)
          Spacer()
        }
      } else {
        VStack {
          Spacer()
          Text("No more profiles!")
            .font(.title2)
            .foregroundColor(.gray)
          Spacer()
        }
      }
    }
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
