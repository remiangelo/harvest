import SwiftUI

struct GrowthLessonsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("Growth Lessons")
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer()
                        
                        // Empty view for alignment
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Explanation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Grow Your Relationship Skills")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        
                        Text("Explore interactive lessons designed to help you build healthier and more meaningful relationships.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Featured Lesson
                    if let featuredLesson = SampleData.growthLessons.first {
                        NavigationLink(destination: GrowthLessonDetailView(lesson: featuredLesson)) {
                            FeaturedLessonCard(lesson: featuredLesson)
                                .padding(.horizontal)
                        }
                    }
                    
                    // All Lessons
                    VStack(alignment: .leading, spacing: 16) {
                        Text("All Lessons")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        ForEach(SampleData.growthLessons) { lesson in
                            NavigationLink(destination: GrowthLessonDetailView(lesson: lesson)) {
                                LessonCard(lesson: lesson)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress Overview
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Progress")
                            .font(.system(size: 20, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Completed Lessons")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("1/\(SampleData.growthLessons.count)")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                            ProgressBar(progress: 0.33)
                                .frame(height: 8)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
        }
    }
}

struct FeaturedLessonCard: View {
    let lesson: GrowthLesson
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with Featured badge
            HStack {
                Text("Featured Lesson")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .cornerRadius(12)
                
                Spacer()
                
                Text(lesson.duration)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Title and icon
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(lesson.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    
                    Text(lesson.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if let image = lesson.image {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .padding(8)
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                        .cornerRadius(16)
                }
            }
            
            // Topics
            HStack {
                ForEach(lesson.topics.prefix(3), id: \.self) { topic in
                    Text(topic)
                        .font(.system(size: 14))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                
                if lesson.topics.count > 3 {
                    Text("+\(lesson.topics.count - 3) more")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            // Start button
            Text("Start Lesson")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                .cornerRadius(16)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct LessonCard: View {
    let lesson: GrowthLesson
    
    var body: some View {
        HStack {
            if let image = lesson.image {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .padding(8)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("\(lesson.duration) • \(lesson.topics.first ?? "")")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color = Color(red: 128/255, green: 23/255, blue: 36/255)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(.systemGray5))
                    .cornerRadius(5)
                
                Rectangle()
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(color)
                    .cornerRadius(5)
            }
        }
    }
}

struct GrowthLessonsView_Previews: PreviewProvider {
    static var previews: some View {
        GrowthLessonsView()
    }
}
