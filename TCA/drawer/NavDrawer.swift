//
//  NavDrawer.swift
//  TCA
//
//  Created by Thaw De Zin on 8/30/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @State private var isShowingDrawer = false
    
    
    
    var body: some View {
        
        
        NavigationView {
            GeometryReader { geometry in
            ZStack {
                // Main content view
                Color.white
                
                // Navigation Drawer
                if isShowingDrawer {
                    //                    DrawerView(isShowingDrawer: $isShowingDrawer)
                    //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                        .background(Color.black.opacity(0.5))
                    //                        .transition(.move(edge: .leading))
                    //                        .edgesIgnoringSafeArea(.all)
                    //                        .zIndex(1)
                    //                        .onTapGesture {
                    //                            withAnimation {
                    //                                isShowingDrawer.toggle()
                    //                            }
                    //                        }
                    DrawerView(isShowingDrawer: $isShowingDrawer)
                        .frame(width: min(geometry.size.width * 0.7, 300))
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                        .animation(.default)
                        .gesture(DragGesture().onEnded { gesture in
                            if gesture.translation.width < -100 {
                                withAnimation {
                                    //isDrawerOpen = false
                                }
                            }
                        })
                    
                }
                
                // Main content
                VStack {
                    Text("Home Page")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                }
                .navigationBarTitle("Navigation Drawer", displayMode: .inline)
                .navigationBarItems(leading:
                                        Button(action: {
                    withAnimation {
                        isShowingDrawer.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
                )
            }.onAppear{
                
                DispatchQueue.global().async {
                                sendHttpRequestsWithRetries()
                                
                                
                            }
            }
        }
        }
    }
}

struct DrawerView: View {
    @Binding var isShowingDrawer: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Navigation Drawer")
                .font(.title)
                .bold()
                .padding(.top, 30)
                .padding(.leading, 20)
            
            List {
                NavigationLink(destination: LoginPage()) {
                    Text("Login")
                }
                
                NavigationLink(destination: RegisterPage()) {
                    Text("Register")
                }
                
                NavigationLink(destination: AboutPage()) {
                    Text("About")
                }
                
                NavigationLink(destination: OptionsPage()) {
                    Text("Options")
                }
            }
            .listStyle(SidebarListStyle())
            .padding(.top, 20)
            .padding(.leading, 20)
            
            Spacer()
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .offset(x: isShowingDrawer ? 0 : -300)
        .animation(.spring())
    }
}

struct LoginPage: View {
    var body: some View {
        Text("Login Page")
            .font(.largeTitle)
            .padding()
    }
}

struct RegisterPage: View {
    var body: some View {
        Text("Register Page")
            .font(.largeTitle)
            .padding()
    }
}

struct AboutPage: View {
    var body: some View {
        Text("About Page")
            .font(.largeTitle)
            .padding()
    }
}

struct OptionsPage: View {
    var body: some View {
        Text("Options Page")
            .font(.largeTitle)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

