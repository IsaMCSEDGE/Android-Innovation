//import SwiftUI
//
//struct ChatView: View {
//    let chatTitle: String
//    @State private var messages: [String] = ["Welcome to the AI Chat!"]
//    @State private var userInput: String = ""
//
//    var body: some View {
//        VStack {
//            // Display chat messages
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(messages, id: \.self) { message in
//                        Text(message)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//            }
//            .padding()
//
//            // Input field and send button
//            HStack {
//                TextField("Type your message", text: $userInput)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(minHeight: 40)
//
//                Button(action: {
//                    sendMessage()
//                }) {
//                    Text("Send")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(chatTitle)
//    }
//
//    private func sendMessage() {
//        guard !userInput.isEmpty else { return }
//        messages.append("You: \(userInput)")
//        let userMessage = userInput
//        userInput = ""
//
//        // Call the AI API
//        callAIAPI(message: userMessage) { response in
//            DispatchQueue.main.async {
//                messages.append("AI: \(response)")
//            }
//        }
//    }
//
//    private func callAIAPI(message: String, completion: @escaping (String) -> Void) {
//        // Your API key and endpoint
//        let apiKey = "your-api-key-here"
//        let apiUrl = "https://api.openai.com/v1/completions"
//
//        // Prepare the request
//        guard let url = URL(string: apiUrl) else {
//            completion("Error: Invalid API URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // JSON body
//        let body: [String: Any] = [
//            "model": "text-davinci-003",
//            "prompt": message,
//            "max_tokens": 100
//        ]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        } catch {
//            completion("Error: Unable to encode request body")
//            return
//        }
//
//        // Perform the request
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                completion("Error: No data received")
//                return
//            }
//
//            // Parse the response
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                   let choices = json["choices"] as? [[String: Any]],
//                   let text = choices.first?["text"] as? String {
//                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
//                } else {
//                    completion("Error: Unexpected API response")
//                }
//            } catch {
//                completion("Error: Failed to parse response")
//            }
//        }.resume()
//    }
//}
