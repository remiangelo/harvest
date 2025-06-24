import SwiftUI

struct GardenerAIOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Gardener AI")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                            
                            Spacer()
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("Your personal dating coach and advisor")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Options Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(SampleData.gardenerOptions) { option in
                            NavigationLink(destination: destinationView(for: option.destination)) {
                                GardenerOptionCard(option: option)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About Gardener AI")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("Gardener AI is your personalized dating coach. It analyzes your conversations, offers insights, and helps you grow meaningful connections. All advice is personalized to your unique dating journey.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    func destinationView(for destination: GardenerAIDestination) -> some View {
        switch destination {
        case .chatReflections:
            ChatReflectionsView()
        case .matchPractice:
            MatchPracticeView()
        case .intervention:
            InterventionListView()
        }
    }
}

struct GardenerOptionCard: View {
    let option: GardenerAIOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: option.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(option.color)
                .padding(12)
                .background(option.color.opacity(0.2))
                .cornerRadius(12)
            
            Text(option.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            Text(option.description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .frame(height: 160)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct GardenerAIOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        GardenerAIOptionsView()
    }
}
