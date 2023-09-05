//
//  SlowlorisV1.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//

import SwiftUI
import Foundation

//// Define the URL you want to send a GET request to
//let url = URL(string: "https://example.com")!
//
//// Create an URLSession configuration with a delegate to discard the response body
//let configuration = URLSessionConfiguration.default
//configuration.protocolClasses = [URLProtocolDiscardBody.self]
//
//// Create an URLSession with the custom configuration
//let session = URLSession(configuration: configuration)

// Define a custom URLProtocol to discard the response body
//class URLProtocolDiscardBody: URLProtocol {
//    override class func canInit(with request: URLRequest) -> Bool {
//        return true
//    }
//
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//
//    override func startLoading() {
//        // Complete loading without processing the response body
//        self.client?.urlProtocolDidFinishLoading(self)
//    }
//
//    override func stopLoading() {
//        // No-op
//    }
//}

//// Send the GET request
//let task = session.dataTask(with: url) { (data, response, error) in
//    if let httpResponse = response as? HTTPURLResponse {
//        print("Response Status Code: \(httpResponse.statusCode)")
//    }
//
//    if let error = error {
//        print("Error: \(error.localizedDescription)")
//    }
//}
//
//task.resume()

//import Foundation

//// Define the URL you want to send a GET request to
//let url = URL(string: "https://example.com")!
//
//// Create a URLSession configuration with a delegate to discard the response body
//let configuration = URLSessionConfiguration.default
//configuration.protocolClasses = [URLProtocolDiscardBody.self]
//
//// Set the timeout interval to simulate a slow request (e.g., 5 seconds)
//configuration.timeoutIntervalForResource = 5.0
//
//// Create an URLSession with the custom configuration
//let session = URLSession(configuration: configuration)

// Define a custom URLProtocol to discard the response body
class URLProtocolDiscardBody: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Complete loading without processing the response body
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // No-op
    }
}

//// Send the GET request
//let task = session.dataTask(with: url) { (data, response, error) in
//    if let httpResponse = response as? HTTPURLResponse {
//        print("Response Status Code: \(httpResponse.statusCode)")
//    }
//    
//    if let error = error {
//        print("Error: \(error.localizedDescription)")
//    }
//}
//
//task.resume()
