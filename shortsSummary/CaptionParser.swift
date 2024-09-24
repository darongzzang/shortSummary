//
//  CaptionParser.swift
//  shortsSummary
//
//  Created by 김이예은 on 9/23/24.
//

import Foundation

class CaptionParser: NSObject, XMLParserDelegate {
    private var currentElement: String = ""
    private var currentText: String = ""
    private var transcript: String = ""
    
    func fetchCaptionContent(captionID: String, apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
        let captionAPIURL = "https://www.googleapis.com/youtube/v3/captions/\(captionID)?key=\(apiKey)"

        guard let url = URL(string: captionAPIURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }

            // XML 파싱 로직
            let parser = XMLParser(data: data)
            parser.delegate = self
            self.transcript = "" // Reset transcript
            if parser.parse() {
                completion(.success(self.transcript))
            } else {
                completion(.failure(NSError(domain: "ParsingError", code: -1, userInfo: nil)))
            }
        }.resume()
    }

    // XMLParserDelegate 메서드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentText = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "body" { // 자막 내용이 포함된 XML 요소
            transcript += currentText + "\n"
        }
    }
}


