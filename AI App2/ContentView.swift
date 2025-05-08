import SwiftUI

struct ContentView: View {
    @State private var chats: [String] = ["Chat 1", "Chat 2"]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chats, id: \.self) { chat in
                        NavigationLink(destination: AIChatView2(chatTitle: chat)) {
                            Text(chat)
                        
                        }
                    }
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    createNewChat()
                }) {
                    Text("New Chat") 
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("RAFI AI")
    
        }
    }

    private func createNewChat() {
        chats.append("New Chat \(chats.count + 1)")
    }
}

