import SwiftUI

struct RelationshipGoalsView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let goals = ["Dating", "Serious", "Marriage"]
  var body: some View {
    VStack {
      ProgressBar(progress: 0.6)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Relationship Goals")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text("Choose the type of relationship you're seeking on Harvest!")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .padding(.bottom, 24)
      ForEach(goals, id: \.self) { goal in
        Button(action: { onboardingData.relationshipGoals = goal }) {
          Text(goal)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(onboardingData.relationshipGoals == goal ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              onboardingData.relationshipGoals == goal
                ? Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255) : Color.white
            )
            .overlay(
              RoundedRectangle(cornerRadius: 32)
                .stroke(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255), lineWidth: 2)
            )
            .cornerRadius(32)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
      }
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.relationshipGoals.isEmpty)
        .opacity(onboardingData.relationshipGoals.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
  }
}

struct RelationshipGoalsView_Previews: PreviewProvider {
  static var previews: some View {
    RelationshipGoalsView(onboardingData: OnboardingData())
  }
}
