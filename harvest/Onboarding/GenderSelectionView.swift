import SwiftUI

struct GenderSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let genders = ["Asexual", "Bisexual", "Gay", "Intersex", "Lesbian", "Trans", "Straight"]
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
          Text("Your Gender/Sex")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.bottom, 2)
          Text("Select the option that best represents you")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
              ForEach(genders, id: \.self) { gender in
                Button(action: { onboardingData.gender = gender }) {
                  Text(gender)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(onboardingData.gender == gender ? .white : .primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 22)
                    .background(
                      Capsule()
                        .fill(.ultraThinMaterial)
                        .opacity(onboardingData.gender == gender ? 0.85 : 0.6)
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
                .scaleEffect(onboardingData.gender == gender ? 1.08 : 1.0)
              }
            }
            .padding(.vertical, 2)
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
        .disabled(onboardingData.gender.isEmpty)
        .opacity(onboardingData.gender.isEmpty ? 0.5 : 1)
      }
    }
  }
}

struct GenderSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    GenderSelectionView(onboardingData: OnboardingData())
  }
}
