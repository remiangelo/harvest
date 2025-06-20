import SwiftUI

struct AgeInputView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  @State private var showError = false

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
        startPoint: .top, endPoint: .bottom
      )
      .ignoresSafeArea()
      VStack(spacing: 32) {
        Spacer()
        VStack(spacing: 18) {
          Text("Your Age")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.bottom, 2)
          Text("Enter your birth date")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
          ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
              .fill(.ultraThinMaterial)
              .opacity(0.7)
              .frame(height: 56)
            TextField("MM/DD/YYYY", text: $onboardingData.birthDate)
              .font(.system(size: 20, weight: .semibold, design: .rounded))
              .foregroundColor(.primary)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 16)
              .keyboardType(.numbersAndPunctuation)
          }
          .padding(.horizontal, 8)
          if showError {
            Text("Please enter a valid date in MM/DD/YYYY format.")
              .foregroundColor(.red)
              .font(.system(size: 14))
              .padding(.top, 2)
          }
        }
        .padding(24)
        .background(
          RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(.ultraThinMaterial)
            .opacity(0.7)
            .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
        Spacer()
        Button(action: {
          if isValidDate(onboardingData.birthDate) {
            showError = false
            onContinue()
          } else {
            showError = true
          }
        }) {
          Text("Continue")
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
              Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .overlay(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      Color.pink.opacity(0.18), Color.blue.opacity(0.14), Color.clear,
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing
                  )
                  .blendMode(.plusLighter)
                )
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
            )
        }
        .padding(.horizontal, 48)
        .padding(.bottom, 32)
        .disabled(onboardingData.birthDate.isEmpty)
        .opacity(onboardingData.birthDate.isEmpty ? 0.5 : 1)
      }
    }
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
