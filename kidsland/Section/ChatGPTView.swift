//
//  ChatGPTView.swift
//  kidsland
//
//  Created by 中战云台 on 2023/3/2.
//

import SwiftUI

struct ChatMessage: Identifiable,Codable {
    var id = UUID()
    var message: String
    var isMe: Bool
}



struct ChatGPTView: View {

    @State private var newMessage = ""
    @State private var messages = [
        ChatMessage(message: "Hello", isMe: false),
        ChatMessage(message: "Hi", isMe: true),
    ]
    @State private var dots = ""
    @State private var loading = false

    var body: some View {
        VStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        if message.isMe {
                            HStack {
                                Spacer()
                                Text(message.message)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .textSelection(.enabled)
                            }
                        } else {
                            HStack {
                                Text(message.message)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .textSelection(.enabled)
                                Spacer()
                            }
                        }
                    }
                    if loading{
                        HStack{
                            Text("Loading\(dots)")
                                .onAppear {
                                    let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                        if dots.count < 3 {
                                            dots += "."
                                        } else {
                                            dots = ""
                                        }
                                    }
                                    timer.fire()
                                }
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .textSelection(.enabled)
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .onAppear{
                UIScrollView.appearance().keyboardDismissMode = .onDrag
                let datas = UserDefaults.standard.data(forKey: "messages")
                let decodedMessages = try? JSONDecoder().decode([ChatMessage].self, from: datas ?? Data())
                
                if let decodedMessages = decodedMessages {
                    messages = decodedMessages
                }
            }
            .onDisappear {
                let encodedMessages = try? JSONEncoder().encode(messages)
                UserDefaults.standard.set(encodedMessages, forKey: "messages")
            }
            
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Button(action: {
                    sendMessage()
                    //                        messages.append(ChatMessage(message: newMessage, isMe: true))
                    newMessage = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Send")
                }
                .padding()
//                .buttonStyle(RoundedButtonStyle())
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(newMessage.isEmpty ? Color.gray : Color.blue, lineWidth: 1))
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle("Chat")
        .navigationBarItems(trailing:
                                Button(action: deleteMessages) {
            Text("Clear")
        }
        )
    }
    func deleteMessages() {
        UserDefaults.standard.removeObject(forKey: "messages")
        messages = []
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messages.append(ChatMessage(message: newMessage, isMe: true))
        
        loading.toggle()
        
        let params = ["model": "gpt-3.5-turbo","messages": [["role": "user", "content":newMessage]]] as [String : Any]
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("Bearer sk", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            loading = false
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response: \(response.debugDescription)")
                messages.append(ChatMessage(message:"Error fetching data: \(error?.localizedDescription) Unexpected response: \(response.debugDescription)", isMe: false))
                
                
                return
            }
            guard let data = data else {
                print("No data received in response")
                return
            }
            guard let response = decodeJSONResponse(data) else {
                print("Failed to decode response")
                return
            }
            
            // 在此处处理解析后的响应
            /// do something add message
            
            if let msg = response.choices?.first?.message?.content{
                messages.append(ChatMessage(message:msg, isMe: false))
            }
            
            
            
            //                print("Received response: \(response)")
        }.resume()
        
        newMessage = ""
    }
    
    // 定义一个用于解析JSON的函数
    func decodeJSONResponse(_ data: Data) -> ChatGPTResponseInfo? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(ChatGPTResponseInfo.self, from: data)
            return response
        } catch {
            print("Error decoding response: \(error.localizedDescription)")
            return nil
        }
    }
}

//struct RoundedButtonStyle: ButtonStyle {
//    var borderColor: Color = .blue
//    var borderWidth: CGFloat = 2.0
//    var cornerRadius: CGFloat = 10.0
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .padding()
//            .foregroundColor(.white)
//            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
//            .cornerRadius(cornerRadius)
//            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
//                .stroke(borderColor, lineWidth: borderWidth))
//    }
//}

struct ChatGPTResponseInfo: Codable {
    var id, object: String?
    var created: Int?
    var model: String?
    var usage: Usage?
    var choices: [Choice]?
}

// MARK: - Choice
struct Choice: Codable {
    var message: Message?
    var finishReason: String?
    var index: Int?
    
    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case index
    }
}

// MARK: - Message
struct Message: Codable {
    var role, content: String?
}

// MARK: - Usage
struct Usage: Codable {
    var promptTokens, completionTokens, totalTokens: Int?
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}



struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
