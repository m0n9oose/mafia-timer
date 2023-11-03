//
//  LogoView.swift
//  mafia_timer
//
//  Created by Ilia Shcherbinin on 03/11/2023.
//

import SwiftUI

struct LogoView: View {
    let fontSize = CGFloat(24)
    let imageSize = CGFloat(200)
    
    var body: some View {
        Group {
            Image("logo-n")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .scaledToFit()
            
            Text("Mafia")
                .font(.system(size: fontSize, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    LogoView()
}
