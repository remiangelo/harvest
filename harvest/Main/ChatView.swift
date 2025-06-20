import SwiftUI

struct ChatView: View {
  @State private var messages: [String] = [
    "Hi there! I'm Gardener AI. Your mindful dating AI coach. What can I assist you with?"
  ]
  @State private var input: String = ""
  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          ForEach(messages, id: \.self) { msg in
            HStack(alignment: .top) {
              Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.gray)
              Text(msg)
                .padding(12)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(16)
            }
          }
        }
        .padding()
      }
      HStack {
        TextField("Type a message...", text: $input)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button(action: sendMessage) {
          Image(systemName: "paperplane.fill")
            .font(.title2)
            .foregroundColor(.accentColor)
        }
        .disabled(input.isEmpty)
      }
      .padding()
    }
  }
  private func sendMessage() {
    guard !input.isEmpty else { return }
    messages.append(input)
    input = ""
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
