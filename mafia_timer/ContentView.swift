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
    @State private var spent: Double = 0.0
    @State private var running: Bool = false
    @State private var mode: Double = 60.0
    @State private var timer: Timer? = nil
    @State private var showingCreditsSheet = false

    let buttonWidth = CGFloat(80)
    let fontSize = CGFloat(32)

    var timeRemaining: Double {
        let multiplier = pow(10, Double(1))
        return Darwin.round((mode - spent) * multiplier) / multiplier
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Group {
                    HStack {
                        Spacer()

                        Button {
                            showingCreditsSheet.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20))
                        }.padding(.horizontal, 60)

                    }
                    
                    LogoView()

                    ZStack {
                        if spent > 0 {
                            Text("\(Int(timeRemaining))")
                                .font(.system(size: 72, design: .rounded))
                                .foregroundColor(.white)
                            
                            CircularProgressView(
                                total: mode,
                                spent: spent,
                                lineWidth: 15
                            )
                            .frame(width: 200, height: 200)
                        }
                    }
                    .padding(.top)
                }

                HStack(spacing: 30) {
                    if spent.isZero {
                        Button {
                            restartTimer(duration: 60.0)
                            playSound(resource: "start")
                        } label: {
                            Text("60")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Button {
                            restartTimer(duration: 30.0)
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
                            spent = 0.0
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
        .sheet(isPresented: $showingCreditsSheet) {
            CreditsView()
        }
    }
    
    func restartTimer(duration: Double) -> Void {
        mode = duration
        spent = 0.0
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { runningTimer in
            spent += runningTimer.timeInterval

            print(timeRemaining)
            if timeRemaining == 10.0 {
                playSound(resource: "ten")
            } else if timeRemaining.isZero {
                spent = 0.0
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
