//
//  SlowlorisMainView.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//

import SwiftUI
import Alamofire
import ComposableArchitecture

struct SlowlorisMainView: View {
    
    let store: StoreOf<SlowlorisFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Hello \(viewStore.statusMessage)")
            Button(action: {
                print("Hi")
                //viewStore.send(.setStatusMessage("New Message"))
                
                Task {
                    await f6iBackup(url: "https://thawdezin.web.app", input: 3)
                }
                
                
//                // Define the URL you want to send a GET request to
//                let url = URL(string: "https://thawdezin.web.app")!
//
//                // Create a URLSession configuration with a delegate to discard the response body
//                let configuration = URLSessionConfiguration.default
//                configuration.protocolClasses = [URLProtocolDiscardBody.self]
//
//                // Set the timeout interval to simulate a slow request (e.g., 5 seconds)
//                configuration.timeoutIntervalForResource = 5.0
//
//                // Create an URLSession with the custom configuration
//                let session = URLSession(configuration: configuration)
//
//                // Send the GET request
//                let task = session.dataTask(with: url) { (data, response, error) in
//                    if let httpResponse = response as? HTTPURLResponse {
//                        print("Response Status Code: \(httpResponse.statusCode)")
//
//                    }
//
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//
//                    } else {
//                        print("Request Completed Successfully")
//                    }
//                }
//
//                task.resume()
//
//                let task1 = session.dataTask(with: url) { (data, response, error) in
//                    if let httpResponse = response as? HTTPURLResponse {
//                        print("Response Status Code: \(httpResponse.statusCode)")
//                    }
//
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                    } else {
//                        print("Request Completed Successfully")
//                    }
//                }
//
//                task1.resume()
//
//                let task3 = session.dataTask(with: url) { (data, response, error) in
//                    if let error = error {
//                            print("Error: \(error.localizedDescription)")
//                        } else {
//                            if let httpResponse = response as? HTTPURLResponse {
//                                print("Response Status Code: \(httpResponse.statusCode)")
//                            } else {
//                                print("Response: \(response) ?? No response)")
//                            }
//
//                            // Print the response data for further inspection
//                            print("Response Data: \(data ?? Data())")
//                        }
//                }
//
//                task3.resume()

                
                
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "wand.and.stars")
                        .font(.title)
                    Text("Start")
                        .font(.headline)
                }
                .padding()
                .background(Color.clear)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
        }.onAppear {
            DispatchQueue.main.async {
                print("View appear")
                // Call the function to send 9 requests
                
            
            }
        }
    }
}

struct SlowlorisMainView_Previews: PreviewProvider {
    static var previews: some View {
        SlowlorisMainView(
              store: Store(initialState: SlowlorisFeature.State()) {
                  SlowlorisFeature()
              }
            )
    }
}
