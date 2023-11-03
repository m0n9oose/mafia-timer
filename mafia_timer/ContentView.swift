//
//  ContentView.swift
//  mafia timer
//
//  Created by Ilia Shcherbinin on 01/11/2023.
//

import AVFoundation
import SwiftUI
import Combine

var player : AVAudioPlayer?

struct ContentView: View {
    @State private var spent: Int = 0
    @State private var running = false
    @State private var mode = 60 // 30
    @State private var timer: Timer? = nil

    let buttonWidth = CGFloat(80)
    let fontSize = CGFloat(32)

    var timeRemaining : Int {
        mode - spent
    }

    var body: some View {
        ZStack {
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
                            restartTimer(duration: 60)
                            playSound(resource: "start")
                        } label: {
                            Text("60")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Button {
                            restartTimer(duration: 30)
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
                            stopTimer()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        if running {
                            Button {
                                stopTimer()
                                player?.pause()
                            } label: {
                                Image(systemName: "pause")
                                    .font(.system(size: fontSize))
                                    .frame(minWidth: buttonWidth)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        } else {
                            Button {
                                startTimer()
                                player?.play()
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
        .accentColor(Color.white)
        .ignoresSafeArea(edges: .vertical)
    }
    
    func restartTimer(duration: Int) -> Void {
        mode = duration
        spent = 0
        startTimer()
    }
    
    func stopTimer() -> Void {
        running = false

        if timer != nil {
            timer!.invalidate()
        }
    }
    
    func startTimer() -> Void {
        running = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            spent += 1

            if timeRemaining == 10 {
                playSound(resource: "ten")
            } else if timeRemaining == 0 {
                spent = 0
                stopTimer()
            }
        }
        
        if timer != nil {
            timer!.fire()
        }
    }

    func playSound(resource: String) -> Void {
        if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)

                player = try AVAudioPlayer(contentsOf: url)

                if player == nil { return }

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
