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
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text(onboardingData.nickname.isEmpty ? "Your Name" : onboardingData.nickname)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
          if let age = calculateAge(from: onboardingData.birthDate) {
            Text("\(age)")
              .font(.system(size: 20, weight: .semibold))
              .foregroundColor(.white.opacity(0.8))
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
        Text(onboardingData.bio.isEmpty ? "No bio provided." : onboardingData.bio)
          .font(.system(size: 15))
          .foregroundColor(.white)
          .padding(.top, 8)
        Spacer()
        HStack(spacing: 12) {
          Button(action: { showEdit = true }) {
            Text("Edit Profile")
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.gray)
              .cornerRadius(32)
          }
          Button(action: { showChat = true }) {
            Text("Chat with Gardener AI")
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255))
              .cornerRadius(32)
          }
        }
        .padding(.top, 16)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 24)
          .fill(Color.black.opacity(0.3))
          .blur(radius: 2)
      )
      .padding(.bottom, 32)
      .padding(.horizontal, 8)
    }
    .edgesIgnoringSafeArea(.all)
    .background(Color.black)
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
  var body: some View {
    VStack(spacing: 24) {
      Text("Edit Profile (Coming Soon)")
        .font(.title)
        .padding()
      Toggle(isOn: $onboardingData.locationAllowed) {
        Text("Share my location with matches")
      }
      .padding()
      Spacer()
    }
    .padding()
  }
}

struct ProfileCardView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileCardView(onboardingData: OnboardingData())
  }
}
