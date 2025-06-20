import SwiftUI

struct NicknameInputView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  var body: some View {
    VStack {
      ProgressBar(progress: 0.3)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Your Harvest Name")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text(
        "Create a unique nickname that represents you. It's how others will know and remember you."
      )
      .font(.system(size: 16))
      .foregroundColor(.gray)
      .multilineTextAlignment(.leading)
      .padding(.horizontal)
      .padding(.bottom, 24)
      InputField(placeholder: "Nickname", text: $onboardingData.nickname)
        .padding(.horizontal)
        .padding(.bottom, 32)
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.nickname.isEmpty)
        .opacity(onboardingData.nickname.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct NicknameInputView_Previews: PreviewProvider {
  static var previews: some View {
    NicknameInputView(onboardingData: OnboardingData())
  }
}
