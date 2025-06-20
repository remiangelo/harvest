import SwiftUI

struct ProfileCardView: View {
  @ObservedObject var onboardingData: OnboardingData
  @State private var showChat = false
  @State private var showEdit = false
  var body: some View {
    ZStack(alignment: .bottom) {
      if let firstPhoto = onboardingData.photos.first {
        Image(uiImage: firstPhoto)
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
          .clipped()
      } else {
        Image(systemName: "person.crop.square")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
          .clipped()
      }
      VStack(alignment: .leading, spacing: 0) {
        Spacer()
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(onboardingData.nickname.isEmpty ? "Your Name" : onboardingData.nickname)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(.white)
            if let age = calculateAge(from: onboardingData.birthDate) {
              Text("\(age)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            }
            if !onboardingData.pronouns.isEmpty {
              Text(onboardingData.pronouns)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 4)
            }
          }
          HStack(spacing: 8) {
            Image(systemName: "location.fill")
              .foregroundColor(.white.opacity(0.8))
              .font(.system(size: 16))
            Text("Location • Distance")
              .font(.system(size: 16))
              .foregroundColor(.white.opacity(0.8))
          }
          if !onboardingData.hobbies.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 8) {
                ForEach(onboardingData.hobbies, id: \.self) { tag in
                  Text("#\(tag)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }
              }
            }
            .padding(.vertical, 4)
          }
          Text(onboardingData.bio.isEmpty ? "No bio provided." : onboardingData.bio)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .padding(.top, 8)
            .lineLimit(3)
        }
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .shadow(radius: 8)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        HStack(spacing: 12) {
          Button(action: { showEdit = true }) {
            Text("Edit Profile")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 10)
              .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
          }
          Button(action: { showChat = true }) {
            Text("Chat with Gardener AI")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 10)
              .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
          }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 32)
      }
    }
    .edgesIgnoringSafeArea(.all)
    .sheet(isPresented: $showChat) {
      ChatView()
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
