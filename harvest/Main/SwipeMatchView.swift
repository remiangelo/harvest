import SwiftUI

struct SwipeMatchView: View {
  @ObservedObject var onboardingData: OnboardingData
  @State private var currentIndex: Int = 0
  @State private var showMatch: Bool = false
  let profiles: [Profile] = [
    Profile(
      name: "Alex", age: 25, pronouns: "they/them", hobbies: ["Art", "Music"], bio: "Painter & DJ.",
      image: "profile1"),
    Profile(
      name: "Sam", age: 28, pronouns: "she/her", hobbies: ["Hiking", "Cooking"],
      bio: "Nature lover.", image: "profile2"),
    Profile(
      name: "Jordan", age: 23, pronouns: "he/him", hobbies: ["Gaming", "Fitness"],
      bio: "Leveling up IRL.", image: "profile3"),
  ]
  var onBack: () -> Void = {}
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
        startPoint: .top, endPoint: .bottom
      )
      .ignoresSafeArea()
      VStack {
        HStack {
          Button(action: onBack) {
            Image(systemName: "chevron.left")
              .font(.system(size: 22, weight: .bold))
              .foregroundColor(.primary)
              .padding(10)
              .background(Circle().fill(.ultraThinMaterial).opacity(0.7))
          }
          Spacer()
          Text("Discover")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
          Spacer().frame(width: 44)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 8)
        Spacer()
        if currentIndex < profiles.count {
          let profile = profiles[currentIndex]
          ZStack(alignment: .bottom) {
            Image(profile.image)
              .resizable()
              .scaledToFill()
              .frame(height: 420)
              .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
            VStack(alignment: .leading, spacing: 10) {
              Text(profile.name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
              HStack(spacing: 10) {
                Text("\(profile.age)")
                  .font(.system(size: 18, weight: .medium, design: .rounded))
                  .foregroundColor(.secondary)
                Text(profile.pronouns)
                  .font(.system(size: 16, weight: .medium, design: .rounded))
                  .foregroundColor(.secondary)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 5)
                  .background(
                    Capsule()
                      .fill(.ultraThinMaterial)
                      .opacity(0.7)
                      .overlay(
                        LinearGradient(
                          gradient: Gradient(colors: [
                            Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                          ]), startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                        .blendMode(.plusLighter)
                      )
                  )
              }
              if !profile.bio.isEmpty {
                Text(profile.bio)
                  .font(.system(size: 15, weight: .regular, design: .rounded))
                  .foregroundColor(.primary)
              }
              if !profile.hobbies.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 8) {
                    ForEach(profile.hobbies, id: \.self) { hobby in
                      Text(hobby)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(
                          Capsule()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                            .overlay(
                              LinearGradient(
                                gradient: Gradient(colors: [
                                  Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing
                              )
                              .blendMode(.plusLighter)
                            )
                        )
                    }
                  }
                  .padding(.horizontal, 4)
                }
              }
            }
            .padding(24)
            .background(
              RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.7)
                .overlay(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      Color.pink.opacity(0.13), Color.blue.opacity(0.10), Color.clear,
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing
                  )
                  .blendMode(.plusLighter)
                )
                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 16)
          }
          .padding(.bottom, 24)
          HStack(spacing: 32) {
            Button(action: {
              if currentIndex < profiles.count - 1 {
                currentIndex += 1
              }
            }) {
              Image(systemName: "xmark")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                  Capsule()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .overlay(
                      LinearGradient(
                        gradient: Gradient(colors: [
                          Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                        ]), startPoint: .topLeading, endPoint: .bottomTrailing
                      )
                      .blendMode(.plusLighter)
                    )
                )
            }
            Button(action: {
              showMatch = true
            }) {
              Image(systemName: "heart.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                  Capsule()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .overlay(
                      LinearGradient(
                        gradient: Gradient(colors: [
                          Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                        ]), startPoint: .topLeading, endPoint: .bottomTrailing
                      )
                      .blendMode(.plusLighter)
                    )
                )
            }
          }
          .padding(.bottom, 32)
        } else {
          Text("No more profiles")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.secondary)
            .padding(.top, 120)
        }
      }
      .alert(isPresented: $showMatch) {
        Alert(
          title: Text("It's a Match!"),
          message: Text("You and \(profiles[currentIndex].name) have matched."),
          dismissButton: .default(
            Text("Yay!"),
            action: {
              if currentIndex < profiles.count - 1 {
                currentIndex += 1
              }
            }))
      }
    }
  }
}

struct Profile {
  let name: String
  let age: Int
  let pronouns: String
  let hobbies: [String]
  let bio: String
  let image: String
}

struct SwipeMatchView_Previews: PreviewProvider {
  static var previews: some View {
    SwipeMatchView(onboardingData: OnboardingData())
  }
}
