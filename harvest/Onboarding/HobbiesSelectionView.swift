import SwiftUI

struct HobbiesSelectionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let allHobbies = [
    "Art", "Board Games", "Cooking", "Dancing", "Fitness", "Gaming", "Hiking", "Motorcycling",
    "Movies", "Music", "Pets", "Photography", "Reading", "Sports", "Singing", "Technology",
    "Tourism", "Writing",
  ]
  let maxSelection = 5
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
          Text("Your Hobbies")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.bottom, 2)
          Text("Pick up to 5 hobbies")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
              ForEach(allHobbies, id: \.self) { hobby in
                let isSelected = onboardingData.hobbies.contains(hobby)
                Button(action: {
                  if isSelected {
                    onboardingData.hobbies.removeAll { $0 == hobby }
                  } else if onboardingData.hobbies.count < maxSelection {
                    onboardingData.hobbies.append(hobby)
                  }
                }) {
                  Text(hobby)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                      Capsule()
                        .fill(.ultraThinMaterial)
                        .opacity(isSelected ? 0.85 : 0.6)
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
                .scaleEffect(isSelected ? 1.08 : 1.0)
                .disabled(!isSelected && onboardingData.hobbies.count >= maxSelection)
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
        .disabled(onboardingData.hobbies.isEmpty)
        .opacity(onboardingData.hobbies.isEmpty ? 0.5 : 1)
      }
    }
  }
}

struct HobbiesSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    HobbiesSelectionView(onboardingData: OnboardingData())
  }
}
