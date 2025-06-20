import SwiftUI

struct PhotoUploadView: View {
  @ObservedObject var onboardingData: OnboardingData
  var onContinue: () -> Void = {}
  let maxPhotos = 6
  @State private var showImagePicker = false
  @State private var selectedImage: UIImage?
  @State private var isLoading = false

  var body: some View {
    VStack {
      ProgressBar(progress: 0.9)
        .padding(.top, 40)
        .padding(.bottom, 32)
      Text("Show your Best Self")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 8)
      Text(
        "Upload up to six of your best photos to make a fantastic first impression. Let your personality shine."
      )
      .font(.system(size: 16))
      .foregroundColor(.gray)
      .padding(.horizontal)
      .padding(.bottom, 16)
      if isLoading {
        ProgressView("Uploading...")
          .padding(.vertical, 32)
      }
      LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16
      ) {
        ForEach(0..<maxPhotos, id: \.self) { index in
          ZStack {
            if onboardingData.photos.indices.contains(index) {
              Image(uiImage: onboardingData.photos[index])
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 120)
                .clipped()
                .cornerRadius(12)
            } else {
              Button(action: { showImagePicker = true }) {
                RoundedRectangle(cornerRadius: 12)
                  .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                  .frame(width: 90, height: 120)
                  .overlay(Image(systemName: "plus").font(.title).foregroundColor(.gray))
              }
            }
          }
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 32)
      Spacer()
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.bottom, 32)
        .disabled(onboardingData.photos.isEmpty)
        .opacity(onboardingData.photos.isEmpty ? 0.5 : 1)
    }
    .background(Color.white.ignoresSafeArea())
    .sheet(
      isPresented: $showImagePicker,
      onDismiss: {
        if let img = selectedImage, onboardingData.photos.count < maxPhotos {
          isLoading = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onboardingData.photos.append(img)
            selectedImage = nil
            isLoading = false
          }
        }
      }
    ) {
      ImagePicker(image: $selectedImage)
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
      if let uiImage = info[.originalImage] as? UIImage {
        parent.image = uiImage
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
