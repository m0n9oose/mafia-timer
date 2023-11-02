//
//  ContentView.swift
//  mafia timer
//
//  Created by Ilia Shcherbinin on 01/11/2023.
//

import AVFoundation
import SwiftUI

var player : AVAudioPlayer?

struct ContentView: View {
    @State private var spent: Int = 2
    @State private var running = false
    @State private var mode = 60 // 30

    let buttonWidth = CGFloat(80)
    let fontSize = CGFloat(32)
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var timeRemaining : Int {
        mode - spent
    }

    var body: some View {
        ZStack {
            Color.black

            VStack {
                Spacer()

                Group {
                    Image("logo-n")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .scaledToFit()
                    
                    Text("Mafia")
                        .font(.system(size: fontSize))
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    ZStack {
                        if spent > 0 {
                            Text("\(timeRemaining)")
                                .font(.system(size: 72, design: .rounded))
                                .foregroundColor(.white)
                            
                            CircularProgressView(
                                total: mode,
                                spent: mode - timeRemaining,
                                lineWidth: 15
                            )
                            .frame(width: 200, height: 200)
                        }
                    }
                }

                HStack(spacing: 30) {
                    if spent == 0 {
                        Button {
                            mode = 60
                            running = true
                            playSound(resource: "start")
                        } label: {
                            Text("60")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Button {
                            mode = 30
                            running = true
                            playSound(resource: "start")
                        } label: {
                            Text("30")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    } else {
                        Button {
                            spent = 0
                            running = false
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        if running {
                            Button {
                                running = false
                            } label: {
                                Image(systemName: "pause")
                                    .font(.system(size: fontSize))
                                    .frame(minWidth: buttonWidth)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        } else {
                            Button {
                                running = true
                            } label: {
                                Image(systemName: "play.fill")
                                    .font(.system(size: fontSize))
                                    .frame(minWidth: buttonWidth)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        }
                    }
                }

                Spacer()
            }
        }
        .onReceive(timer) { time in
            guard running else { return }

            if timeRemaining > 0 {
                spent += 1
                if timeRemaining == 10 {
                    playSound(resource: "ten")
                }
            } else {
                spent = 0
                running = false
            }
        }
        .accentColor(Color.white)
        .ignoresSafeArea(edges: .vertical)
    }

    func playSound(resource: String) -> Void {
        if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)

                if player == nil { return }

                player!.prepareToPlay()
                player!.volume = 1.0
                player!.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
