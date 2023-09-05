//
//  SlowlorisFeature.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//

import SwiftUI
import ComposableArchitecture

struct SlowlorisFeature: Reducer {
    struct State {
        var statusMessage = "" // Use statusMessage of type String
    }

    enum Action {
        case setStatusMessage(String) // Define an action to set the status message
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setStatusMessage(let newMessage):
            state.statusMessage = newMessage // Set the status message
            Task {
                // Define the URL you want to send a GET request to
                let url = URL(string: "https://thawdezin.web.app")!

                // Create a URLSession configuration with a delegate to discard the response body
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [URLProtocolDiscardBody.self]

                // Set the timeout interval to simulate a slow request (e.g., 5 seconds)
                configuration.timeoutIntervalForResource = 5.0

                // Create an URLSession with the custom configuration
                let session = URLSession(configuration: configuration)
                
                // Send the GET request
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Response Status Code: \(httpResponse.statusCode)")
                        
                    }
                    
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        
                    }
                }

                task.resume()
                
            }
            
            return .none
        }
    }
}
extension SlowlorisFeature.State: Equatable {}
