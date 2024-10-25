//
//  TranslteViewModel.swift
//  Translte App
//
//  Created by Meet Kapadiya on 22/10/24.
//

import Foundation


class TranslteViewModel {
    
    var trans: TransModel?
    
    func translate(from sourceLanguage: String, to targetLanguage: String, text: String, completion: @escaping (Result<Any, Error>) -> Void) {
        
        let headers = [
            "x-rapidapi-key": "7294f725acmsh49a1de05b3e4a9fp121840jsna6c42979f078",
            "x-rapidapi-host": "google-translate113.p.rapidapi.com",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
              "from": sourceLanguage,
              "to": targetLanguage,
              "json": [
                "title" : text
              ]
        ]
        
        guard let url = URL(string: "https://google-translate113.p.rapidapi.com/api/v1/translator/json") else {
            print("Invalid URL")
            return
        }
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error serializing JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                   
                    let data = try JSONDecoder().decode(TransModel.self, from: data as Data)
                    completion(.success(data))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }
        task.resume()
    }
}

