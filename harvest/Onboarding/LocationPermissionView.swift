import CoreLocation
import SwiftUI

class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  @Published var isAuthorized = false
  override init() {
    super.init()
    manager.delegate = self
  }
  func requestPermission() {
    manager.requestWhenInUseAuthorization()
  }
  func locationManager(
    _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
  ) {
    isAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
  }
}

struct LocationPermissionView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  @StateObject private var permissionManager = LocationPermissionManager()

  var body: some View {
    VStack {
      ProgressBar(progress: 1.0)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Spacer()
      Image(systemName: "location.fill")
        .resizable()
        .frame(width: 56, height: 56)
        .foregroundColor(Color(red: 128 / 255, green: 23 / 255, blue: 36 / 255))
        .padding(.bottom, 24)
      Text("Enable Location")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .padding(.bottom, 8)
      Text("You need to enable location to be able to use Harvest")
        .font(.system(size: 16))
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.bottom, 24)
      PrimaryButton(title: permissionManager.isAuthorized ? "Location Enabled" : "Allow Location") {
        permissionManager.requestPermission()
      }
      .disabled(permissionManager.isAuthorized)
      .padding(.bottom, 32)
      Spacer()
      PrimaryButton(
        title: "Continue",
        action: {
          onboardingData.locationAllowed = true
          onContinue()
        }
      )
      .padding(.bottom, 32)
      .disabled(!permissionManager.isAuthorized)
      .opacity(!permissionManager.isAuthorized ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
    .onAppear {
      #if targetEnvironment(simulator)
        permissionManager.isAuthorized = true
      #endif
    }
    .onChange(of: permissionManager.isAuthorized) { newValue in
      onboardingData.locationAllowed = newValue
    }
  }
}

struct LocationPermissionView_Previews: PreviewProvider {
  static var previews: some View {
    LocationPermissionView(onboardingData: OnboardingData())
  }
}
