import SwiftUI

enum OnboardingStep: Int, CaseIterable {
  case age, pronouns, nickname, gender, preference, relationshipGoals, hobbies, bio, photos
}

struct OnboardingFlowView: View {
  @State private var step: OnboardingStep = .age
  @StateObject private var onboardingData = OnboardingData()
  @State private var onboardingComplete = false
  @State private var showProfile = false

  var body: some View {
    if showProfile {
      ProfileCardView(onboardingData: onboardingData)
    } else if onboardingComplete {
      VStack {
        Spacer()
        ProgressView("Loading your profile...")
          .progressViewStyle(CircularProgressViewStyle())
          .padding()
        Spacer()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          showProfile = true
        }
      }
    } else {
      VStack {
        switch step {
        case .age:
          AgeInputView(onboardingData: onboardingData, onContinue: { step = .pronouns })
        case .pronouns:
          PronounSelectionView(onboardingData: onboardingData, onContinue: { step = .nickname })
        case .nickname:
          NicknameInputView(onboardingData: onboardingData, onContinue: { step = .gender })
        case .gender:
          GenderSelectionView(onboardingData: onboardingData, onContinue: { step = .preference })
        case .preference:
          PreferenceSelectionView(
            onboardingData: onboardingData, onContinue: { step = .relationshipGoals })
        case .relationshipGoals:
          RelationshipGoalsView(onboardingData: onboardingData, onContinue: { step = .hobbies })
        case .hobbies:
          HobbiesSelectionView(onboardingData: onboardingData, onContinue: { step = .bio })
        case .bio:
          BioInputView(onboardingData: onboardingData, onContinue: { step = .photos })
        case .photos:
          PhotoUploadView(onboardingData: onboardingData, onContinue: { onboardingComplete = true })
        }
      }
      .animation(.easeInOut, value: step)
      .transition(.slide)
    }
  }
}

struct OnboardingFlowView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingFlowView()
  }
}
