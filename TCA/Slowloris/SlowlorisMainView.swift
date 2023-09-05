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
                viewStore.send(.setStatusMessage("New Message"))
                
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
