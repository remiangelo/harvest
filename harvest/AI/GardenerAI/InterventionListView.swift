import SwiftUI

struct InterventionListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
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
                    
                    Text("Interventions")
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    // Empty view for alignment
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Explanation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Conversation Help")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    
                    Text("Gardener AI can help you navigate challenging conversations and improve your messaging patterns.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Interventions List
                VStack(spacing: 16) {
                    ForEach(SampleData.interventions) { intervention in
                        NavigationLink(destination: InterventionDetailView(intervention: intervention)) {
                            InterventionCard(intervention: intervention)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Request custom help
                VStack(spacing: 16) {
                    Text("Need specific help?")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.white)
                                .padding(.trailing, 4)
                            
                            Text("Request Custom Advice")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .cornerRadius(16)
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

struct InterventionCard: View {
    let intervention: Intervention
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(intervention.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                
                Text(intervention.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Label("\(intervention.tips.count) Actionable Tips", systemImage: "list.bullet")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
            }
            
            Spacer()
            
            if let image = intervention.image {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    .padding(8)
                    .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                    .cornerRadius(16)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct InterventionDetailView: View {
    let intervention: Intervention
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
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
                    
                    Text(intervention.title)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Image and description
                VStack(alignment: .leading, spacing: 16) {
                    if let image = intervention.image {
                        HStack {
                            Spacer()
                            
                            Image(systemName: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .padding(20)
                                .background(Color(red: 128/255, green: 23/255, blue: 36/255).opacity(0.1))
                                .cornerRadius(24)
                            
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                    
                    Text(intervention.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                    
                    Text(intervention.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Tips
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tips to Apply")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 4)
                    
                    ForEach(intervention.tips.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                                .cornerRadius(14)
                            
                            Text(intervention.tips[index])
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Example messages (placeholder)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Example Messages")
                        .font(.system(size: 20, weight: .bold))
                    
                    VStack(spacing: 16) {
                        ExampleMessageCard(
                            title: "Instead of:",
                            message: "So when are we meeting up?",
                            isGood: false
                        )
                        
                        ExampleMessageCard(
                            title: "Try:",
                            message: "I've been enjoying our conversation. Would you be interested in grabbing coffee sometime this week?",
                            isGood: true
                        )
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Apply to conversation button
                Button(action: {}) {
                    Text("Apply to My Conversations")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}

struct ExampleMessageCard: View {
    let title: String
    let message: String
    let isGood: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            HStack {
                Text(message)
                    .font(.system(size: 16))
                    .padding(12)
                    .background(isGood ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(16)
                
                Spacer()
                
                Image(systemName: isGood ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isGood ? .green : .red)
            }
        }
    }
}

struct InterventionListView_Previews: PreviewProvider {
    static var previews: some View {
        InterventionListView()
    }
}
