import SwiftUI

struct GenderSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let genders = ["Asexual", "Bisexual", "Gay", "Intersex", "Lesbian", "Trans", "Straight"]
  var body: some View {
    VStack {
      ProgressBar(progress: 0.4)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Be True to Yourself")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text(
        "Choose the gender that best represents you. Authenticity is key to meaningful connections."
      )
      .font(.system(size: 16))
      .foregroundColor(.gray)
      .multilineTextAlignment(.leading)
      .padding(.horizontal)
      .padding(.bottom, 24)
      ForEach(genders, id: \.self) { gender in
        Button(action: { onboardingData.gender = gender }) {
          Text(gender)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(onboardingData.gender == gender ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              onboardingData.gender == gender
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
        .disabled(onboardingData.gender.isEmpty)
        .opacity(onboardingData.gender.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct GenderSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    GenderSelectionView(onboardingData: OnboardingData())
  }
}
