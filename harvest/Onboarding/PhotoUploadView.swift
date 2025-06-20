import SwiftUI

struct PhotoUploadView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  @State private var showImagePicker = false
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
          Text("Profile Photo")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.bottom, 2)
          Text("Add a photo of yourself")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
          ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
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
            if let image = onboardingData.photos.first {
              Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                  RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.7), lineWidth: 2))
            } else {
              VStack(spacing: 8) {
                Image(systemName: "person.crop.circle.badge.plus")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 60, height: 60)
                  .foregroundColor(.secondary)
                Text("Tap to upload")
                  .font(.system(size: 16, weight: .medium, design: .rounded))
                  .foregroundColor(.secondary)
              }
            }
          }
          .frame(width: 160, height: 160)
          .onTapGesture { showImagePicker = true }
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
          Text("Finish")
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
        .disabled(onboardingData.photos.isEmpty)
        .opacity(onboardingData.photos.isEmpty ? 0.5 : 1)
      }
    }
    .sheet(isPresented: $showImagePicker) {
      ImagePicker(
        image: Binding(
          get: { onboardingData.photos.first },
          set: { newImage in
            if let img = newImage {
              onboardingData.photos = [img]
            }
          }
        ))
    }
  }
}

// ImagePicker is a UIKit wrapper for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    init(_ parent: ImagePicker) { self.parent = parent }
    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      if let image = info[.originalImage] as? UIImage {
        parent.image = image
      }
      picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }
}

struct PhotoUploadView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoUploadView(onboardingData: OnboardingData())
  }
}
