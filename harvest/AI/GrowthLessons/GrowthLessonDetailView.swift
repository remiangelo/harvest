import SwiftUI

struct GrowthLessonDetailView: View {
    let lesson: GrowthLesson
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage = 0
    
    // Sample lesson content - would normally come from backend
    let lessonPages = [
        LessonPage(
            title: "Introduction",
            content: "In this lesson, we'll explore how to build more meaningful connections with your matches through authentic communication.",
            image: "heart.circle.fill"
        ),
        LessonPage(
            title: "Why Authenticity Matters",
            content: "Research shows that authentic connections lead to more satisfying relationships. Being genuine allows others to truly know and appreciate you.",
            image: "person.2.fill"
        ),
        LessonPage(
            title: "Key Strategies",
            content: "1. Share your genuine interests and passions\n2. Listen actively and respond thoughtfully\n3. Be vulnerable when appropriate\n4. Express your needs clearly but kindly",
            image: "list.bullet.clipboard.fill"
        ),
        LessonPage(
            title: "Practice Exercise",
            content: "Think about something you're passionate about that you haven't shared with your matches. How might you bring this up in conversation in a natural way?",
            image: "pencil.and.outline"
        ),
        LessonPage(
            title: "Reflection",
            content: "Consider a time when someone's authenticity made you feel more connected to them. What specifically made that interaction meaningful?",
            image: "person.thought.bubble"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                }
                
                Spacer()
                
                Text(lesson.title)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Progress indicator
            ProgressBar(progress: CGFloat(currentPage + 1) / CGFloat(lessonPages.count))
                .frame(height: 4)
                .padding(.horizontal)
            
            // Page content
            TabView(selection: $currentPage) {
                ForEach(0..<lessonPages.count, id: \.self) { index in
                    LessonPageView(page: lessonPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Navigation
            HStack(spacing: 20) {
                if currentPage > 0 {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Previous")
                        }
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 128/255, green: 23/255, blue: 36/255), lineWidth: 2)
                        )
                    }
                } else {
                    Spacer()
                }
                
                Button(action: {
                    withAnimation {
                        if currentPage < lessonPages.count - 1 {
                            currentPage += 1
                        } else {
                            // Complete the lesson
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage < lessonPages.count - 1 ? "Next" : "Complete")
                        Image(systemName: currentPage < lessonPages.count - 1 ? "arrow.right" : "checkmark")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .cornerRadius(16)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }
}

struct LessonPage: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let image: String
}

struct LessonPageView: View {
    let page: LessonPage
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image
                Image(systemName: page.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .padding(24)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                    .clipShape(Circle())
                
                // Title
                Text(page.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .multilineTextAlignment(.center)
                
                // Content
                Text(page.content)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // If there's an exercise or reflection, add fields for user input
                if page.title.contains("Exercise") || page.title.contains("Reflection") {
                    TextField("Write your thoughts here...", text: .constant(""))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct GrowthLessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        if let lesson = SampleData.growthLessons.first {
            GrowthLessonDetailView(lesson: lesson)
        }
    }
}
