import SwiftUI
import UIKit
import Foundation

struct GenerateView: View {
    @State private var selectedTab = "Text" // 选择 "Text" or "Image"
    @State private var inputText = "" // 文字输入框
    @State private var selectedImage: UIImage? // 用户上传的图片
    @State private var responseType = "回复" // 回复 or 生成文案
    @State private var selectedStyle = "Shakespeare" // 默认风格
    @State private var includeEmoji = true // 是否包含 Emoji
    @State private var wordCount: Double = 100 // 1-200 字
    @State private var isPrivate = false // 是否 Private
    @State private var generatedText = "" // AI 生成结果
    @State private var isGenerating = false // 生成状态

    let styles = ["Shakespeare", "Kanye West", "抖音风格", "幽默", "文艺", "夸张", "Instagram 风格"]

    var body: some View {
        ScrollView {
            VStack {
                // Header
                Text("Comet AI 生成器")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                // Tab 切换
                Picker("模式", selection: $selectedTab) {
                    Text("文字").tag("Text")
                    Text("图文").tag("Image")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == "Image" {
                    VStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        } else {
                            Button("上传图片") {
                                // TODO: 处理图片上传
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.2))
                            .cornerRadius(10)
                        }

                        Picker("生成类型", selection: $responseType) {
                            Text("回复").tag("回复")
                            Text("生成文案").tag("生成文案")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                } else {
                    TextField("输入你的文字...", text: $inputText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Picker("风格", selection: $selectedStyle) {
                    ForEach(styles, id: \.self) { style in
                        Text(style).tag(style)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Toggle("包含 Emoji", isOn: $includeEmoji)
                    .padding()

                VStack {
                    Text("字数: \(Int(wordCount))")
                    Slider(value: $wordCount, in: 1...200, step: 1)
                }
                .padding()

                Toggle("私密（不显示在排行榜）", isOn: $isPrivate)
                    .padding()

                Button(action: generateText) {
                    Text(isGenerating ? "生成中..." : "生成")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(isGenerating)

                if !generatedText.isEmpty {
                    VStack {
                        ScrollView { // 让 AI 生成的文本可以滚动
                            Text(generatedText)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxHeight: 200) // 限制最大高度，防止 UI 撑开

                        Button(action: {
                            UIPasteboard.general.string = generatedText
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("复制")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }

        .padding()
    }

    // 处理 AI 生成逻辑
    func generateText() {
        isGenerating = true
        let prompt = constructPrompt()
        callOpenAI(prompt: prompt) { response in
            DispatchQueue.main.async {
                self.generatedText = response
                self.isGenerating = false
            }
        }
    }

    // 生成 Prompt
    func constructPrompt() -> String {
        var prompt = "请生成一段"

        if selectedTab == "Image" {
            prompt += "关于图片的"
        } else {
            prompt += "关于文本的"
        }

        if responseType == "回复" {
            prompt += "回复"
        } else {
            prompt += "创意文案"
        }

        prompt += "，风格为 \(selectedStyle)"
        prompt += includeEmoji ? "，包含 emoji。" : "，不包含 emoji。"
        prompt += "字数为 \(Int(wordCount)) 字。"

        if selectedTab == "Text" {
            prompt += "原始文本：" + inputText
        }

        return prompt
    }
    
    
    func callOpenAI(prompt: String, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://comet.seonaluo59.workers.dev/v1/chat/completions")!
        
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 100
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("❌ 请求失败: \(error.localizedDescription)")
                    completion("AI 生成失败")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP 状态码: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("❌ 服务器返回错误: \(String(data: data ?? Data(), encoding: .utf8) ?? "无数据")")
                        completion("AI 生成失败")
                        return
                    }
                }

                // **完整打印 JSON 返回内容**
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("✅ 返回 JSON: \(jsonString)")
                }

                if let data = data,
                   let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data) {
                    completion(response.choices.first?.message.content ?? "AI 生成失败")
                } else {
                    completion("AI 生成失败: 数据格式错误")
                }
            }.resume()
        }

    // OpenAI API 响应结构
    struct OpenAIResponse: Codable {
        struct Choice: Codable {
            struct Message: Codable {
                let content: String
            }
            let message: Message
        }
        let choices: [Choice]
    }

}
