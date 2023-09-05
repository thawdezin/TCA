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
            DispatchQueue.main.async {
                send9Request()
            }
            
            return .none
        }
    }
}
extension SlowlorisFeature.State: Equatable {}
