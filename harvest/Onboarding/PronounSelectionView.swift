import SwiftUI

struct PronounSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}

  var body: some View {
    VStack {
      ProgressBar(progress: 0.2)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("What Do You Identify As?")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text("Choose your pronouns so people can address you correctly")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 24)
      InputField(placeholder: "They/Them", text: $onboardingData.pronouns)
        .padding(.horizontal)
        .padding(.bottom, 32)
      Spacer()
      PrimaryButton(title: "Continue") {
        onContinue()
      }
      .padding(.bottom, 32)
      .disabled(onboardingData.pronouns.isEmpty)
      .opacity(onboardingData.pronouns.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct PronounSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    PronounSelectionView(onboardingData: OnboardingData())
  }
}
