import SwiftUI

struct AgeInputView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  @State private var showError = false

  var body: some View {
    VStack {
      // Progress Bar
      ProgressBar(progress: 0.1)
        .padding(.top, 40)
        .padding(.bottom, 32)

      // Title
      Text("Let's Start with Your Age")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)

      // Subtitle
      Text("Input your birth date so people know how old you are")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 24)

      // Input Field
      InputField(placeholder: "MM/DD/YYYY", text: $onboardingData.birthDate)
        .padding(.horizontal)
        .padding(.bottom, 8)

      if showError {
        Text("Please enter a valid date in MM/DD/YYYY format.")
          .foregroundColor(.red)
          .font(.system(size: 14))
          .padding(.bottom, 8)
      }

      Spacer()

      // Continue Button
      PrimaryButton(title: "Continue") {
        if isValidDate(onboardingData.birthDate) {
          showError = false
          onContinue()
        } else {
          showError = true
        }
      }
      .padding(.bottom, 32)
      .disabled(onboardingData.birthDate.isEmpty)
      .opacity(onboardingData.birthDate.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }

  private func isValidDate(_ dateString: String) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.date(from: dateString) != nil
  }
}

struct AgeInputView_Previews: PreviewProvider {
  static var previews: some View {
    AgeInputView(onboardingData: OnboardingData())
  }
}
