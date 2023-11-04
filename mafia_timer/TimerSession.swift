//
//  TimerSession.swift
//  mafia_timer
//
//  Created by Ilia Shcherbinin on 03/11/2023.
//

import SwiftUI

class TimerSession: ObservableObject {
    var duration: Double?
    var callback: (() -> ())?
    var timer: Timer?

    @Published var running: Bool
    @Published var spent: Double

    var left: Double {
        if duration == nil { return 0.0 }

        let multiplier = pow(10, Double(1))
        return Darwin.round((duration! - spent) * multiplier) / multiplier
    }

    init(duration: Double? = nil, callback: (() -> ())? = nil) {
        self.duration = duration
        self.callback = callback
        self.timer = nil
        self.running = false
        self.spent = 0.0
    }

    func setDuration(duration: Double) -> Void {
        pause()
        self.spent = 0.0
        self.duration = duration
    }

    func setCallback(callback: @escaping () -> ()) -> Void {
        pause()
        self.spent = 0.0
        self.callback = callback
    }

    func start() {
        self.running = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] runningTimer in
            self.spent += runningTimer.timeInterval

            if left == 10.0 {
                if callback != nil {
                    callback!()
                }
            } else if left.isZero && timer != nil {
                stop()
            }
        }
    }
    
    func pause() {
        self.running = false

        if timer != nil {
            timer!.invalidate()
        }
    }

    func stop() {
        pause()

        self.spent = 0.0
        self.duration = nil
        self.callback = nil
    }
}
