//
//  ContentView.swift
//  mafia timer
//
//  Created by Ilia Shcherbinin on 01/11/2023.
//

import AVFoundation
import SwiftUI
import Combine

var player: AVAudioPlayer?

struct ContentView: View {
    @State private var showingCreditsSheet = false
    @ObservedObject var timerSession = TimerSession()

    let buttonWidth = CGFloat(80)
    let fontSize = CGFloat(32)

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
                        if timerSession.duration != nil {
                            Text("\(Int(timerSession.left))")
                                .font(.system(size: 72, design: .rounded))
                                .foregroundColor(.white)

                            CircularProgressView(
                                total: timerSession.duration!,
                                spent: timerSession.spent,
                                lineWidth: 12
                            )
                            .frame(width: 200, height: 200)
                        }
                    }
                    .padding(.top)
                }

                HStack(spacing: 30) {
                    if timerSession.duration == nil {
                        Button {
                            timerSession.setDuration(duration: 60.0)
                            timerSession.setCallback {
                                playSound(resource: "ten")
                            }
                            timerSession.start()
                            playSound(resource: "start")
                        } label: {
                            Text("60")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Button {
                            timerSession.setDuration(duration: 30.0)
                            timerSession.setCallback {
                                playSound(resource: "ten")
                            }
                            timerSession.start()
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
                            timerSession.stop()
                            player?.stop()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: fontSize))
                                .frame(minWidth: buttonWidth)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        if timerSession.running {
                            Button {
                                timerSession.pause()
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
                                timerSession.start()

                                if timerSession.left < 10.0 {
                                    // only resume "10 sec" sound
                                    player?.play()
                                }
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

    func playSound(resource: String) -> Void {
        if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)

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
