import SwiftUI

struct OnboardingFlowView: View {
  @ObservedObject var onboardingData: OnboardingData
  @State private var step: Int = 0
  var onFinish: () -> Void = {}
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
        startPoint: .top, endPoint: .bottom
      )
      .ignoresSafeArea()
      VStack {
        Spacer(minLength: 0)
        Group {
          switch step {
          case 0:
            AgeInputView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 1:
            PronounSelectionView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 2:
            NicknameInputView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 3:
            GenderSelectionView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 4:
            PreferenceSelectionView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 5:
            RelationshipGoalsView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 6:
            HobbiesSelectionView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 7:
            BioInputView(onboardingData: onboardingData) {
              withAnimation { step += 1 }
            }
          case 8:
            PhotoUploadView(onboardingData: onboardingData) {
              onFinish()
            }
          default:
            EmptyView()
          }
        }
        Spacer(minLength: 0)
      }
    }
  }
}

struct OnboardingFlowView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingFlowView(onboardingData: OnboardingData())
  }
}
