//
//  TCAApp.swift
//  TCA
//
//  Created by Thaw De Zin on 8/28/23.
//

import SwiftUI
import ComposableArchitecture

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


struct ContentView: View {
    @State private var isDrawerOpen = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if isDrawerOpen {
                        DrawerView()
                            .frame(width: min(geometry.size.width * 0.7, 300)) // Adjust the drawer width as needed
                            .transition(.move(edge: .leading))
                            .animation(.default)
                    }

                    VStack {
                        NavigationLink(destination: HomeView()) {
                            Text("Home")
                        }
                        .isDetailLink(false) // Prevent pushing a new view onto the navigation stack

                        Spacer()

                        Button("Open Drawer") {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarTitle("App")
        }
    }
}

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

struct DrawerView: View {
    var body: some View {
        List {
            NavigationLink(destination: LoginView()) {
                Text("Login")
            }
            NavigationLink(destination: RegisterView()) {
                Text("Register")
            }
            NavigationLink(destination: AboutView()) {
                Text("About")
            }
            NavigationLink(destination: OptionsView()) {
                Text("Options")
            }
        }
        .listStyle(SidebarListStyle())
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
