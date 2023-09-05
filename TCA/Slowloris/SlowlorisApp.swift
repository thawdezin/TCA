//
//  SlowlorisApp.swift
//  TCA
//
//  Created by Thaw De Zin on 9/5/23.
//
import SwiftUI
import ComposableArchitecture

@main
struct SlowlorisApp: App {
    static let store = Store(initialState: SlowlorisFeature.State()) {
        SlowlorisFeature()._printChanges()
      }

      var body: some Scene {
        WindowGroup {
          SlowlorisMainView(store: SlowlorisApp.store)
        }
      }
}
