import Foundation
import SwiftUI

// Gardener AI related models

struct GardenerAIOption: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String // SF Symbol name
    let color: Color
    let destination: GardenerAIDestination
}

enum GardenerAIDestination {
    case chatReflections
    case matchPractice
    case intervention
}

struct ChatReflection: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let date: Date
    let matchName: String?
    let matchImage: String?
}

struct MatchPracticeScenario: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let image: String?
}

struct Intervention: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let tips: [String]
    let image: String?
}

// Growth Lessons related models

struct GrowthLesson: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let image: String?
    let duration: String
    let topics: [String]
}

// Sample data for UI preview
class SampleData {
    static let gardenerOptions: [GardenerAIOption] = [
        GardenerAIOption(
            title: "Chat Reflections",
            description: "Review insights from your conversations",
            icon: "text.bubble.fill",
            color: Color(red: 128/255, green: 23/255, blue: 36/255),
            destination: .chatReflections
        ),
        GardenerAIOption(
            title: "Match Practice",
            description: "Practice messaging with different scenarios",
            icon: "person.2.fill",
            color: Color(red: 40/255, green: 120/255, blue: 80/255),
            destination: .matchPractice
        ),
        GardenerAIOption(
            title: "Intervention",
            description: "Get help with difficult conversations",
            icon: "hand.raised.fill",
            color: Color(red: 200/255, green: 80/255, blue: 50/255),
            destination: .intervention
        )
    ]
    
    static let chatReflections: [ChatReflection] = [
        ChatReflection(
            title: "Moving too quickly",
            message: "Your conversation seems to be moving too fast. Consider slowing down and asking more open-ended questions.",
            date: Date().addingTimeInterval(-86400), // yesterday
            matchName: "Emma",
            matchImage: "person.crop.circle.fill"
        ),
        ChatReflection(
            title: "Great conversation flow",
            message: "You maintained a balanced conversation with good listening cues. Keep it up!",
            date: Date().addingTimeInterval(-259200), // 3 days ago
            matchName: "Jake",
            matchImage: "person.crop.circle.fill"
        ),
        ChatReflection(
            title: "Could be more engaging",
            message: "Try asking more questions about their interests that you mentioned in your profile.",
            date: Date().addingTimeInterval(-432000), // 5 days ago
            matchName: "Sophia",
            matchImage: "person.crop.circle.fill"
        )
    ]
    
    static let matchPracticeScenarios: [MatchPracticeScenario] = [
        MatchPracticeScenario(
            title: "First Message",
            description: "Practice sending engaging first messages that stand out",
            image: "bubble.left.fill"
        ),
        MatchPracticeScenario(
            title: "Deeper Conversations",
            description: "Learn how to transition from small talk to meaningful discussion",
            image: "heart.text.square.fill"
        ),
        MatchPracticeScenario(
            title: "Planning a Date",
            description: "Practice suggesting a date in a comfortable, natural way",
            image: "calendar.badge.plus"
        )
    ]
    
    static let interventions: [Intervention] = [
        Intervention(
            title: "Moving on too quickly",
            description: "Your conversation seems to be moving too fast, which might make the other person uncomfortable.",
            tips: [
                "Slow down and ask more open-ended questions",
                "Give them time to respond fully",
                "Focus on shared interests before suggesting meeting"
            ],
            image: "clock.fill"
        ),
        Intervention(
            title: "One-sided conversation",
            description: "You're doing most of the talking without giving the other person much space.",
            tips: [
                "Ask more questions about their interests",
                "Acknowledge their responses before sharing your thoughts",
                "Balance the conversation by matching message length"
            ],
            image: "person.wave.2.fill"
        )
    ]
    
    static let growthLessons: [GrowthLesson] = [
        GrowthLesson(
            title: "Building Authentic Connections",
            description: "Learn how to create meaningful relationships based on mutual understanding and genuine interest.",
            image: "heart.circle.fill",
            duration: "15 min",
            topics: ["Authenticity", "Listening Skills", "Vulnerability"]
        ),
        GrowthLesson(
            title: "Effective Communication",
            description: "Improve your ability to express yourself clearly and understand others.",
            image: "bubble.left.and.bubble.right.fill",
            duration: "20 min",
            topics: ["Active Listening", "Clear Expression", "Nonverbal Cues"]
        ),
        GrowthLesson(
            title: "Setting Healthy Boundaries",
            description: "Learn how to establish and maintain healthy boundaries in relationships.",
            image: "shield.fill",
            duration: "10 min",
            topics: ["Self-awareness", "Assertiveness", "Respect"]
        )
    ]
}
