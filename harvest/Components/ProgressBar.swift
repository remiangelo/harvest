import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat // 0.0 to 1.0
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 8)
                    .foregroundColor(Color.gray.opacity(0.2))
                Capsule()
                    .frame(width: geometry.size.width * progress, height: 8)
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
            }
        }
        .frame(height: 8)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.5)
            .frame(width: 200)
    }
} 