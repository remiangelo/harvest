import SwiftUI

struct ChatView: View {
  @ObservedObject var onboardingData: OnboardingData
  @State private var message: String = ""
  @State private var messages: [String] = ["Hey there! 👋", "How's your day going?"]
  var onBack: () -> Void = {}
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
        startPoint: .top, endPoint: .bottom
      )
      .ignoresSafeArea()
      VStack(spacing: 0) {
        HStack {
          Button(action: onBack) {
            Image(systemName: "chevron.left")
              .font(.system(size: 22, weight: .bold))
              .foregroundColor(.primary)
              .padding(10)
              .background(Circle().fill(.ultraThinMaterial).opacity(0.7))
          }
          Spacer()
          Text("Chat")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
          Spacer().frame(width: 44)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 8)
        ScrollView {
          VStack(spacing: 18) {
            ForEach(messages.indices, id: \.self) { idx in
              HStack {
                if idx % 2 == 0 { Spacer() }
                Text(messages[idx])
                  .font(.system(size: 17, weight: .regular, design: .rounded))
                  .foregroundColor(.primary)
                  .padding(.vertical, 12)
                  .padding(.horizontal, 20)
                  .background(
                    Capsule()
                      .fill(.ultraThinMaterial)
                      .opacity(0.8)
                      .overlay(
                        LinearGradient(
                          gradient: Gradient(colors: [
                            Color.pink.opacity(0.13), Color.blue.opacity(0.10), Color.clear,
                          ]), startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                        .blendMode(.plusLighter)
                      )
                  )
                if idx % 2 == 1 { Spacer() }
              }
            }
          }
          .padding(.horizontal, 16)
          .padding(.top, 8)
        }
        .background(
          RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(.ultraThinMaterial)
            .opacity(0.7)
            .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        HStack(spacing: 12) {
          TextField("Type a message…", text: $message)
            .font(.system(size: 17, weight: .regular, design: .rounded))
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
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
            )
          Button(action: {
            if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
              messages.append(message)
              message = ""
            }
          }) {
            Image(systemName: "arrow.up.circle.fill")
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(.blue)
          }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
      }
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(onboardingData: OnboardingData())
  }
}
