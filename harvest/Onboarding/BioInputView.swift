import SwiftUI

struct BioInputView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let characterLimit = 160
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
          Text("About You")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.bottom, 2)
          Text("Write a short bio")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
          ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
              .fill(.ultraThinMaterial)
              .opacity(0.7)
              .overlay(
                LinearGradient(
                  gradient: Gradient(colors: [
                    Color.pink.opacity(0.13), Color.blue.opacity(0.10), Color.clear,
                  ]), startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .blendMode(.plusLighter)
              )
              .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            TextEditor(text: $onboardingData.bio)
              .font(.system(size: 17, weight: .regular, design: .rounded))
              .foregroundColor(.primary)
              .padding(16)
              .frame(height: 120)
              .background(Color.clear)
              .cornerRadius(28)
              .onChange(of: onboardingData.bio) { newValue in
                if newValue.count > characterLimit {
                  onboardingData.bio = String(newValue.prefix(characterLimit))
                }
              }
            if onboardingData.bio.isEmpty {
              Text("Tell us about yourself…")
                .foregroundColor(.secondary)
                .padding(20)
            }
          }
          .frame(height: 120)
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
        Button(action: onContinue) {
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
        .disabled(onboardingData.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(
          onboardingData.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
      }
    }
  }
}

struct BioInputView_Previews: PreviewProvider {
  static var previews: some View {
    BioInputView(onboardingData: OnboardingData())
  }
}
