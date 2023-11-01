//
//  ContentView.swift
//  mafia timer
//
//  Created by Ilia Shcherbinin on 01/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var spent: Int = 0
    @State private var running = false
    @State private var mode = 60 // 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timeRemaining : Int {
        mode - spent
    }

    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                    .padding(.vertical, 50)

                ZStack {
                    if spent > 0 {
                        Text("\(timeRemaining)")
                            .font(.system(size: 72, design: .rounded))
                            .foregroundColor(.white)
                        
                        CircularProgressView(past: 60 - timeRemaining, lineWidth: 15)
                            .frame(width: 200,height: 200)
                    }
                }
                
                HStack(spacing: 30) {
                    if spent == 0 {
                        Button {
                            mode = 60
                            running = true
                        } label: {
                            Text("60")
                                .font(.system(size: 48))
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        
                        Button {
                            mode = 30
                            running = true
                        } label: {
                            Text("30")
                                .font(.system(size: 48))
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    } else {
                        if running {
                            Button {
                                running = false
                            } label: {
                                Image(systemName: "pause")
                                    .font(.system(size: 48))
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        } else {
                            Button {
                                running = true
                            } label: {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 48))
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        }
                        
                        Button {
                            spent = 0
                            running = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 48))
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
                .padding(.top, 25)
            }
        }
        .onReceive(timer) { time in
            guard running else { return }
            
            if timeRemaining > 0 {
                spent += 1
            } else {
                spent = 0
                running = false
            }
        }
        .accentColor(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
