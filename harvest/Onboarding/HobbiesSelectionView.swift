import SwiftUI

struct HobbiesSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let allHobbies = [
    "Art", "Board Games", "Cooking", "Dancing", "Fitness", "Gaming", "Hiking", "Motorcycling",
    "Movies", "Music", "Pets", "Photography", "Reading", "Sports", "Singing", "Technology",
    "Tourism", "Writing",
  ]
  let maxSelection = 5
  var body: some View {
    VStack(alignment: .leading) {
      ProgressBar(progress: 0.7)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Share your Hobbies")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text(
        "Share your interests, passions, and hobbies. We'll connect you with people who share your enthusiasm."
      )
      .font(.system(size: 16))
      .foregroundColor(.gray)
      .padding(.horizontal)
      .padding(.bottom, 16)
      Text("Select up to 5 hobbies    \(onboardingData.hobbies.count) out of 5 selected")
        .font(.system(size: 14))
        .foregroundColor(.gray)
        .padding(.horizontal)
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 12)], spacing: 12) {
          ForEach(allHobbies, id: \.self) { hobby in
            let isSelected = onboardingData.hobbies.contains(hobby)
            Button(action: {
              if isSelected {
                onboardingData.hobbies.removeAll { $0 == hobby }
              } else if onboardingData.hobbies.count < maxSelection {
                onboardingData.hobbies.append(hobby)
              }
            }) {
              Text(hobby)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(
                  isSelected ? Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255) : Color.white
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255), lineWidth: 1)
                )
                .cornerRadius(24)
            }
            .disabled(!isSelected && onboardingData.hobbies.count >= maxSelection)
          }
        }
        .padding(.horizontal)
      }
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.hobbies.isEmpty)
        .opacity(onboardingData.hobbies.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct HobbiesSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    HobbiesSelectionView(onboardingData: OnboardingData())
  }
}
