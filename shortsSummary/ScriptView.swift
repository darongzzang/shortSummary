//
//  ScriptView.swift
//  shortsSummary
//
//  Created by 김이예은 on 9/13/24.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

struct ScriptView: View {
    @State private var videoURL: String = ""
    @State private var transcript: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter YouTube Shorts URL", text: $videoURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Get Transcript") {
                fetchTranscript(from: videoURL)
            }
            .padding()
            
            if !transcript.isEmpty {
                Text("Transcript:")
                    .font(.headline)
                Text(transcript)
                    .padding()
            }
            
            if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    func fetchTranscript(from url: String) {
        guard let videoID = extractVideoID(from: url) else {
            errorMessage = "Invalid URL"
            return
        }
        
        let apiKey = personalAPIKey // 여기에 API 키를 입력
        let apiURL = "https://www.googleapis.com/youtube/v3/captions?videoId=\(videoID)&key=\(apiKey)"
        
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let items = json?["items"] as? [[String: Any]], let firstItem = items.first, let captionID = firstItem["id"] as? String {
                    let captionParser = CaptionParser()
                    captionParser.fetchCaptionContent(captionID: captionID, apiKey: apiKey) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let transcript):
                                self.transcript = transcript
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                                
                                print(String(data: data, encoding: .utf8) ?? "No data")
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "No captions found"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse JSON"
                }
            }
        }.resume()
    }

    func extractVideoID(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url) else { return nil }
        return urlComponents.path.split(separator: "/").last.map(String.init)
    }
}
