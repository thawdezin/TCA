//
//  SlowlorisService.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//

import SwiftUI
import Foundation
import Dispatch

// Function to measure CPU usage
func getCPUUsage() -> Double {
    var rusageInfo = rusage()
    getrusage(RUSAGE_SELF, &rusageInfo)
    
    let userTime = TimeInterval(rusageInfo.ru_utime.tv_sec) + TimeInterval(rusageInfo.ru_utime.tv_usec) / 1_000_000
    let systemTime = TimeInterval(rusageInfo.ru_stime.tv_sec) + TimeInterval(rusageInfo.ru_stime.tv_usec) / 1_000_000
    
    let totalTime = userTime + systemTime
    return totalTime
}
// Function to measure RAM usage
func getRAMUsage() -> Double {
    let processInfo = ProcessInfo()
    let ramUsage = Double(processInfo.physicalMemory) / (1024 * 1024) // Convert to MB
    return ramUsage
}

// Function to send an HTTP request
// Function to send an HTTP request and handle the response
func sendHttpRequest(url: URL, group: DispatchGroup) {
    let session = URLSession(configuration: .default)
    var request = URLRequest(url: url)
    request.httpShouldUsePipelining = true // Enable Keep-Alive headers
    
    let task = session.dataTask(with: request) { data, response, error in
        defer {
            group.leave() // Ensure the group leave is called even if there's an error
        }
        
        if let error = error {
            print("Request failed with error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        
        // Inspect the response status code and other properties
        let statusCode = httpResponse.statusCode
        print("Response Status Code: \(statusCode)")
        
        if 200...299 ~= statusCode {
            // The request was successful (status code in the 2xx range)
            print("Request was successful")
        } else if 500...599 ~= statusCode {
            // Server error (status code in the 5xx range)
            print("Server error: \(statusCode)")
        } else {
            // Handle other status codes as needed
            print("Unhandled status code: \(statusCode)")
        }
        
        // You can also inspect the response data if needed
        if let responseData = data {
            let responseString = String(data: responseData, encoding: .utf8)
            print("Response Data: \(responseString ?? "N/A")")
        }
    }
    
    task.resume()
}

// Function to send a batch of 9 unique HTTP requests
func send9Request() {
    let targetUrlString = "https://.com"
    let maxRequestsPerBatch = 2
    let totalRequests = 3
    
    // Calculate the number of batches needed
    let totalBatches = (totalRequests + maxRequestsPerBatch - 1) / maxRequestsPerBatch
    
    // Create a DispatchGroup to keep track of request completion
    let group = DispatchGroup()
    
    // Internal variable to keep track of the current batch number
    var batchNumber = 0
    
    // Define the recursive function to send requests in the current batch
    func sendNextBatch() {
        let startIndex = batchNumber * maxRequestsPerBatch
        let endIndex = min(startIndex + maxRequestsPerBatch, totalRequests)
        
        for i in startIndex..<endIndex {
            guard let targetUrl = URL(string: "\(targetUrlString)/\(i)") else {
                continue // Skip invalid URLs
            }
            
            group.enter() // Notify that a request is starting
            sendHttpRequest(url: targetUrl, group: group)
        }
        
        // Wait for all requests in the batch to complete
        group.wait()
        
        // Check CPU and RAM usage here
        let cpuUsage = getCPUUsage()
        let ramUsage = getRAMUsage()
        
        print("Batch \(batchNumber + 1):")
        print("CPU Usage: \(cpuUsage)")
        print("RAM Usage: \(ramUsage) MB")
        
        if cpuUsage > 80 || ramUsage > 80 {
            // Postpone sending more requests if CPU or RAM usage is high
            //print("CPU or RAM usage is high. Requests postponed.")
            
            // Calculate the number of remaining requests
            let remainingRequests = totalRequests - endIndex
            
            if remainingRequests > 0 {
                // Send the next batch of requests recursively
                print("CPU and RAM usage are within acceptable limits. Sending more requests.")
                batchNumber += 1
                sendNextBatch()
            } else {
                // All requests have been sent
                print("All requests have been sent.")
            }
        } else {
            // Calculate the number of remaining requests
            let remainingRequests = totalRequests - endIndex
            
            if remainingRequests > 0 {
                // Send the next batch of requests recursively
                print("CPU and RAM usage are within acceptable limits. Sending more requests.")
                batchNumber += 1
                sendNextBatch()
            } else {
                // All requests have been sent
                print("All requests have been sent.")
            }
        }
    }
    
    // Start sending the first batch
    sendNextBatch()
    
    // Use the calculated totalBatches if needed
    print("Total Batches: \(totalBatches)")
}
