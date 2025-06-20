import SwiftUI

struct PreferenceSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let preferences = ["Asexual", "Bisexual", "Gay", "Intersex", "Lesbian", "Trans"]
  var body: some View {
    VStack {
      ProgressBar(progress: 0.5)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("What is your preference?")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text("Choose the genders that you wish to meet on Harvest!")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 24)
      ForEach(preferences, id: \.self) { preference in
        Button(action: { onboardingData.preference = preference }) {
          Text(preference)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(onboardingData.preference == preference ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              onboardingData.preference == preference
                ? Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255) : Color.white
            )
            .overlay(
              RoundedRectangle(cornerRadius: 32)
                .stroke(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255), lineWidth: 2)
            )
            .cornerRadius(32)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
      }
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.preference.isEmpty)
        .opacity(onboardingData.preference.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct PreferenceSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceSelectionView(onboardingData: OnboardingData())
  }
}
