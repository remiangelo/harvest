import Foundation
import SwiftUI

class OnboardingData: ObservableObject {
  @Published var birthDate: String = ""
  @Published var pronouns: String = ""
  @Published var nickname: String = ""
  @Published var gender: String = ""
  @Published var preference: String = ""
  @Published var relationshipGoals: String = ""
  @Published var hobbies: [String] = []
  @Published var bio: String = ""
  @Published var photos: [UIImage] = []
  @Published var locationAllowed: Bool = false
  @Published var verificationCode: String = ""
}
