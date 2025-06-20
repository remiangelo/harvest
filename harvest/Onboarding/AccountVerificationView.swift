import SwiftUI

struct AccountVerificationView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  @FocusState private var isFocused: Bool
  var body: some View {
    VStack {
      Spacer()
      Text("Verify Your Account")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .padding(.bottom, 16)
      Text("Enter 5-digit Code code we have sent to at your email")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.bottom, 24)
      HStack(spacing: 12) {
        ForEach(0..<5) { i in
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray.opacity(0.3), lineWidth: 2)
              .frame(width: 48, height: 56)
            Text(self.digit(at: i))
              .font(.system(size: 24, weight: .bold))
          }
        }
      }
      .padding(.bottom, 16)
      TextField("", text: $onboardingData.verificationCode)
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .frame(width: 0, height: 0)
        .opacity(0.01)
        .focused($isFocused)
        .onAppear { isFocused = true }
      Button("Resend Code") {}
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255))
        .padding(.bottom, 32)
      Spacer()
      PrimaryButton(title: "NEXT", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.verificationCode.count != 5)
        .opacity(onboardingData.verificationCode.count != 5 ? 0.5 : 1)
      Text("by clicking next, you agree to our Privacy Policy our Terms and Conditions")
        .font(.system(size: 12))
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    .background(Color.white.ignoresSafeArea())
    .onTapGesture { isFocused = true }
  }
  private func digit(at index: Int) -> String {
    let code = onboardingData.verificationCode
    if index < code.count {
      let idx = code.index(code.startIndex, offsetBy: index)
      return String(code[idx])
    }
    return ""
  }
}

struct AccountVerificationView_Previews: PreviewProvider {
  static var previews: some View {
    AccountVerificationView(onboardingData: OnboardingData())
  }
}
