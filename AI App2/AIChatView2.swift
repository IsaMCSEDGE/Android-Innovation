import SwiftUI

struct AIChatView2: View {
    let chatTitle: String
    @State private var messages: [String] = ["Welcome to the RAFI AI Chat!"]
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
            // Display chat messages
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            
            // Input field and send button
            HStack {
                TextField("Type your message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                
                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(chatTitle)
    }
    
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        messages.append("You: \(userInput)")
        let userMessage = userInput
        userInput = ""
        
        // Call the AI API
        callAIAPI(message: userMessage) { response in
            DispatchQueue.main.async {
                messages.append("AI: \(response)")
            }
        }
    }
    
    private func callAIAPI(message: String, completion: @escaping (String) -> Void) {
        // Correct API URL
        let apiUrl = "https://llm.datasaur.ai/api/sandbox/3262/2700/chat/completions"
        let apiKey = "c983501b-a5f1-4cad-bc6a-aa17dfbba48b"
        
        // Prepare the request
        guard let url = URL(string: apiUrl) else {
            completion("Error: Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Correct body structure
        let body: [String: Any] = [
            "messages": [
                ["role": "user", "content": message]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion("Error: Unable to encode request body")
            return
        }
        
        // Debugging: Print the request
        print("API URL: \(apiUrl)")
        print("Request Body: \(body)")
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion("Error: No data received")
                return
            }
            
            // Debugging: Print the raw response
            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid response")")
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let content = choices.first?["message"] as? [String: Any],
                   let text = content["content"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion("Error: Unexpected API response")
                }
            } catch {
                completion("Error: Failed to parse response")
            }
        }.resume()
    }
}
