import SwiftUI

struct BioInputView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  var body: some View {
    VStack {
      ProgressBar(progress: 0.8)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Describe Your True Self!")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text("Add a bio to your profile so people get to know you before swiping!")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 24)
      ZStack(alignment: .topLeading) {
        TextEditor(text: $onboardingData.bio)
          .font(.system(size: 16))
          .padding()
          .frame(height: 120)
          .background(
            RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        if onboardingData.bio.isEmpty {
          Text("I'm a person that loves....")
            .foregroundColor(.gray)
            .padding(.top, 16)
            .padding(.leading, 20)
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 32)
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.bio.isEmpty)
        .opacity(onboardingData.bio.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct BioInputView_Previews: PreviewProvider {
  static var previews: some View {
    BioInputView(onboardingData: OnboardingData())
  }
}
