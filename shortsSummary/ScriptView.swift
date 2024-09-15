//
//  ScriptView.swift
//  shortsSummary
//
//  Created by 김이예은 on 9/13/24.
//

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

        let apiKey = "AIzaSyAChf4iWwerK3xLtFJW9gzci6r-NTgLK2M" // 여기에 API 키를 입력하세요.
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
                // JSON 파싱 로직 (자막 데이터 처리)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                // json에서 자막 텍스트를 추출하는 로직을 추가해야 합니다.
                // 이 부분은 YouTube API의 응답 형식에 따라 다릅니다.

                DispatchQueue.main.async {
                    // transcript = "추출한 자막 텍스트"
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


