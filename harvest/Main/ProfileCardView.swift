import SwiftUI

struct ProfileCardView: View {
  @ObservedObject var onboardingData: OnboardingData
  @State private var showChat = false
  @State private var showEdit = false
  var body: some View {
    ZStack(alignment: .bottom) {
      // Fullscreen, aspect-fill profile image
      if let firstPhoto = onboardingData.photos.first {
        GeometryReader { geo in
          Image(uiImage: firstPhoto)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .ignoresSafeArea()
        }
      } else {
        Color(.systemBackground)
          .ignoresSafeArea()
      }
      // Glass overlay with chromatic distortion
      VStack(alignment: .leading, spacing: 0) {
        Spacer()
        VStack(alignment: .leading, spacing: 18) {
          HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(onboardingData.nickname.isEmpty ? "Your Name" : onboardingData.nickname)
              .font(.system(size: 34, weight: .bold, design: .rounded))
              .foregroundColor(.primary)
            if let age = calculateAge(from: onboardingData.birthDate) {
              Text("\(age)")
                .font(.system(size: 26, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            }
            if !onboardingData.pronouns.isEmpty {
              Text(onboardingData.pronouns)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            }
          }
          HStack(spacing: 8) {
            Image(systemName: "location.fill")
              .foregroundColor(.accentColor)
              .font(.system(size: 18))
            Text("Location • Distance")
              .font(.system(size: 18, weight: .medium, design: .rounded))
              .foregroundColor(.secondary)
          }
          if !onboardingData.hobbies.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 10) {
                ForEach(onboardingData.hobbies, id: \.self) { tag in
                  Text("#\(tag)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                      Capsule()
                        .fill(.ultraThinMaterial)
                        .opacity(0.65)
                        .overlay(
                          LinearGradient(
                            gradient: Gradient(colors: [
                              Color.pink.opacity(0.15), Color.blue.opacity(0.12), Color.clear,
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing
                          )
                          .blendMode(.plusLighter)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
                    )
                }
              }
            }
            .padding(.vertical, 4)
          }
          Text(onboardingData.bio.isEmpty ? "No bio provided." : onboardingData.bio)
            .font(.system(size: 17, weight: .regular, design: .rounded))
            .foregroundColor(.primary)
            .padding(.top, 8)
            .lineLimit(3)
        }
        .padding(28)
        .background(
          RoundedRectangle(cornerRadius: 36, style: .continuous)
            .fill(.ultraThinMaterial)
            .opacity(0.65)
            .overlay(
              LinearGradient(
                gradient: Gradient(colors: [
                  Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                ]), startPoint: .topLeading, endPoint: .bottomTrailing
              )
              .blendMode(.plusLighter)
            )
            .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
        )
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
        HStack(spacing: 16) {
          Button(action: { showEdit = true }) {
            Text("Edit Profile")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
              .foregroundColor(.primary)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 12)
              .background(
                Capsule()
                  .fill(.ultraThinMaterial)
                  .opacity(0.65)
                  .overlay(
                    LinearGradient(
                      gradient: Gradient(colors: [
                        Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                      ]), startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .blendMode(.plusLighter)
                  )
                  .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
              )
          }
          Button(action: { showChat = true }) {
            Text("Chat with Gardener AI")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 12)
              .background(
                Capsule()
                  .fill(
                    LinearGradient(
                      gradient: Gradient(colors: [
                        Color.accentColor, Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255),
                      ]), startPoint: .leading, endPoint: .trailing)
                  )
                  .opacity(0.85)
                  .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
              )
          }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 36)
      }
    }
    .edgesIgnoringSafeArea(.all)
    .sheet(isPresented: $showChat) {
      ChatView(onboardingData: onboardingData)
    }
    .sheet(isPresented: $showEdit) {
      EditProfileView(onboardingData: onboardingData)
    }
  }
  // Helper to calculate age from MM/DD/YYYY string
  private func calculateAge(from birthDate: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    guard let date = formatter.date(from: birthDate) else { return nil }
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: date, to: now)
    return ageComponents.year
  }
}

struct EditProfileView: View {
  @ObservedObject var onboardingData: OnboardingData
  @Environment(\.presentationMode) var presentationMode
  @State private var nickname: String = ""
  @State private var pronouns: String = ""
  @State private var bio: String = ""
  @State private var hobbies: [String] = []
  @State private var locationAllowed: Bool = false
  let allHobbies = [
    "Art", "Board Games", "Cooking", "Dancing", "Fitness", "Gaming", "Hiking", "Motorcycling",
    "Movies", "Music", "Pets", "Photography", "Reading", "Sports", "Singing", "Technology",
    "Tourism", "Writing",
  ]
  let maxSelection = 5
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Nickname")) {
          TextField("Nickname", text: $nickname)
        }
        Section(header: Text("Pronouns")) {
          TextField("Pronouns", text: $pronouns)
        }
        Section(header: Text("Bio")) {
          TextEditor(text: $bio)
            .frame(height: 80)
        }
        Section(header: Text("Hobbies (up to 5)")) {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(allHobbies, id: \.self) { hobby in
                let isSelected = hobbies.contains(hobby)
                Button(action: {
                  if isSelected {
                    hobbies.removeAll { $0 == hobby }
                  } else if hobbies.count < maxSelection {
                    hobbies.append(hobby)
                  }
                }) {
                  Text(hobby)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                      isSelected
                        ? Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255)
                        : Color.gray.opacity(0.2)
                    )
                    .cornerRadius(16)
                }
                .disabled(!isSelected && hobbies.count >= maxSelection)
              }
            }
          }
        }
        Section {
          Toggle(isOn: $locationAllowed) {
            Text("Share my location with matches")
          }
        }
      }
      .navigationBarTitle("Edit Profile", displayMode: .inline)
      .navigationBarItems(
        trailing: Button("Save") {
          onboardingData.nickname = nickname
          onboardingData.pronouns = pronouns
          onboardingData.bio = bio
          onboardingData.hobbies = hobbies
          onboardingData.locationAllowed = locationAllowed
          presentationMode.wrappedValue.dismiss()
        }
      )
      .onAppear {
        nickname = onboardingData.nickname
        pronouns = onboardingData.pronouns
        bio = onboardingData.bio
        hobbies = onboardingData.hobbies
        locationAllowed = onboardingData.locationAllowed
      }
    }
  }
}

struct ProfileCardView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileCardView(onboardingData: OnboardingData())
  }
}
