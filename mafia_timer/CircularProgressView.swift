//
//  circular.swift
//  mafia timer
//
//  Created by Ilia Shcherbinin on 01/11/2023.
//

import SwiftUI

struct CircularProgressView: View {
    let total: Double
    let spent: Double
    let lineWidth: Int
    
    var progress: Double {
        (1.0 / total) * spent
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.red.opacity(0.1),
                    lineWidth: CGFloat(lineWidth + 4)
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: CGFloat(lineWidth),
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

#Preview {
    CircularProgressView(total: 30.0, spent: 25.0, lineWidth: 20)
}
