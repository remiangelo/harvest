import SwiftUI

struct InputField: View {
    var placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 20, weight: .semibold))
            .padding()
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 28).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            .multilineTextAlignment(.center)
    }
}

struct InputField_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        InputField(placeholder: "MM/DD/YYYY", text: $text)
            .padding()
    }
} 