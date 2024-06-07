//
//  NetworkManager.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/1/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    public let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    func get(to url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func post(to url: URL, body parameters: [String: Any] = [:], headers: [String: String] = [:], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(nil, nil, error)
            return
        }
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func put(to url: URL, body parameters: [String: Any], headers: [String: String], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(nil, nil, error)
            return
        }
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func delete(to url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
