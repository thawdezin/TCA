//
//  TCAApp.swift
//  TCA
//
//  Created by Thaw De Zin on 8/28/23.
//

import SwiftUI
import ComposableArchitecture
import Foundation

struct Feature: Reducer {
    struct State: Equatable {
        var count = 0
        var numberFactAlert: String?
      }
    
    enum Action: Equatable {
        case factAlertDismissed
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
      }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .factAlertDismissed:
          state.numberFactAlert = nil
          return .none

        case .decrementButtonTapped:
          state.count -= 1
          return .none

        case .incrementButtonTapped:
          state.count += 1
          return .none

        case .numberFactButtonTapped:
          return .run { [count = state.count] send in
            let (data, _) = try await URLSession.shared.data(
              from: URL(string: "http://numbersapi.com/\(count)/trivia")!
            )
            await send(
              .numberFactResponse(String(decoding: data, as: UTF8.self))
            )
          }

        case let .numberFactResponse(fact):
          state.numberFactAlert = fact
          return .none
        }
      }
    
}



struct FeatureView: View {
  let store: StoreOf<Feature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Button("−") { viewStore.send(.decrementButtonTapped) }
          Text("\(viewStore.count)")
          Button("+") { viewStore.send(.incrementButtonTapped) }
        }

        Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
      }
      .alert(
        item: viewStore.binding(
          get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
          send: .factAlertDismissed
        ),
        content: { Alert(title: Text($0.title)) }
      )
    }
  }
}

struct FactAlert: Identifiable {
  var title: String
  var id: String { self.title }
}

//@main
//struct TCAApp: App {
//
//    static let store = Store(initialState: CounterFeature.State()){
//        CounterFeature()._printChanges()
//    }
//
//    static let s = Store(initialState: CounterFeature.State(), reducer: {CounterFeature()._printChanges()})
//
//  var body: some Scene {
//    WindowGroup {
//        CounterView(store: TCAApp.store)
//    }
//  }
//}


//struct ContentView: View {
//    @State private var isDrawerOpen = false
//
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                HStack(spacing: 0) {
//                    if isDrawerOpen {
//                        DrawerView()
//                            .frame(width: min(geometry.size.width * 0.7, 300))
//                            .transition(.move(edge: .leading))
//                            .animation(.default)
//                            .gesture(DragGesture().onEnded { gesture in
//                                if gesture.translation.width < -100 {
//                                    withAnimation {
//                                        isDrawerOpen = false
//                                    }
//                                }
//                            })
//                    }
//
//                    VStack {
//                        NavigationLink(destination: HomeView()) {
//                            Text("Home")
//                        }
//                        .isDetailLink(false)
//                        .contentShape(Rectangle()) // Make the NavigationLink area tappable
//                        .gesture(DragGesture().onChanged { _ in
//                            if isDrawerOpen {
//                                withAnimation {
//                                    isDrawerOpen = false
//                                }
//                            }
//                        })
//
//                        Spacer()
//
//                        Button("Open Drawer") {
//                            withAnimation {
//                                isDrawerOpen.toggle()
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .contentShape(Rectangle()) // Make the VStack area tappable
//                    .gesture(DragGesture().onChanged { _ in
//                        if isDrawerOpen {
//                            withAnimation {
//                                isDrawerOpen = false
//                            }
//                        }
//                    })
//                }
//            }
//            .navigationBarTitle("App")
//        }
//    }
//}



struct HomeView: View {
    var body: some View {
        Text("Home Page")
            .navigationBarTitle("Home", displayMode: .inline)
    }
}

// Dummy views for the other pages
struct LoginView: View {
    var body: some View {
        Text("Login Page")
            .navigationBarTitle("Login", displayMode: .inline)
    }
}

struct RegisterView: View {
    var body: some View {
        Text("Register Page")
            .navigationBarTitle("Register", displayMode: .inline)
    }
}

struct AboutView: View {
    var body: some View {
        Text("About Page")
            .navigationBarTitle("About", displayMode: .inline)
    }
}

struct OptionsView: View {
    var body: some View {
        Text("Options Page")
            .navigationBarTitle("Options", displayMode: .inline)
    }
}

//struct DrawerView: View {
//    var body: some View {
//        List {
//
//            NavigationLink(destination: LoginView()) {
//                Text("Login")
//            }
//            NavigationLink(destination: RegisterView()) {
//                Text("Register")
//            }
//            NavigationLink(destination: AboutView()) {
//                Text("About")
//            }
//            NavigationLink(destination: OptionsView()) {
//                Text("Options")
//            }
//
//            Section(header: Text("Dashboard")) {
//                            NavigationLink(destination: RegisterView()) {
//                                Text("For Sale")
//                            }
//                            NavigationLink(destination: RegisterView()) {
//                                Text("For Rent")
//                            }
//                        }
//                        Section(header: Text("Title 1")) {
//                            NavigationLink(destination: RegisterView()) {
//                                Text("Label 1")
//                            }
//                            NavigationLink(destination: RegisterView()) {
//                                Text("Label 2")
//                            }
//                        }
//
//            Section(header: Text("Dashboard")) {
//                            NavigationLink(destination: RegisterView()) {
//                                Text("For Sale")
//                            }
//                            NavigationLink(destination: RegisterView()) {
//                                Text("For Rent")
//                            }
//                        }
//                        Section(header: Text("Title 1")) {
//                            NavigationLink(destination: RegisterView()) {
//                                Text("Label 1")
//                            }
//                            NavigationLink(destination: RegisterView()) {
//                                Text("Label 2")
//                            }
//                        }
//        }
//        .listStyle(SidebarListStyle())
//    }
//}


struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            
            ContentView()
        }
    }
}




func sendHttpRequestsWithRetries() {
    // Function to perform an HTTP request
    func sendHttpRequest(url: URL, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(false)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("Request failed with status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("Request failed with an unknown error")
                completion(false)
            }
        }
        task.resume()
    }

    let targetUrlString = "https://www..com"
    let targetUrl = URL(string: targetUrlString)!

    // Number of retries for failed requests
    let maxRetries = 3

    // Loop to send requests
    for i in 0..<18 {
        print("Batch \(i + 1)")
        var failedRequests = 0

        // Send 9 requests together
        let group = DispatchGroup()
        for _ in 0..<9 {
            group.enter()
            sendHttpRequest(url: targetUrl) { success in
                if !success {
                    failedRequests += 1
                }
                group.leave()
            }
        }

        // Wait for all requests in the batch to complete
        group.wait()

        // Retry failed requests
        for retry in 0..<maxRetries {
            if failedRequests == 0 {
                break // No need to retry if all requests were successful
            }

            print("Retrying \(failedRequests) failed requests...")

            // Send failed requests again
            for _ in 0..<failedRequests {
                group.enter()
                sendHttpRequest(url: targetUrl) { success in
                    if !success {
                        print("Retry failed for request")
                    }
                    group.leave()
                }
            }

            // Wait for all retry requests to complete
            group.wait()
        }

        // Print summary for this batch
        print("Summary for Batch \(i + 1): \(failedRequests) failed requests.")
    }
}


