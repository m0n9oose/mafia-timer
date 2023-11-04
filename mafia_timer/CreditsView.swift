//
//  CreditsView.swift
//  mafia_timer
//
//  Created by Ilia Shcherbinin on 03/11/2023.
//

import SwiftUI

struct CreditsView: View {
    @Environment(\.dismiss) var dismiss
    
    let imageLink = "https://www.freepik.com/free-vector/mysterious-gangster-character_7275333.htm"
    let ideaLink = "https://mafia-timer.neonll.ru"
    let githubLink = "https://github.com/m0n9oose/mafia-timer"
    let imagesize = CGFloat(36)

    var body: some View {
        VStack {
            VStack {
                Spacer()

                HStack(alignment: .center) {
                    Image("logo-n")
                        .resizable()
                        .frame(width: imagesize, height: imagesize)
                    
                    Link(destination: URL(string: imageLink)!) {
                        Text("Image: Freepik.com")
                        Image(systemName: "arrow.up.forward.app")
                    }
                }

                Link(destination: URL(string: ideaLink)!) {
                    Text("Original idea")
                    Image(systemName: "arrow.up.forward.app")
                }.padding(.top)

                Link(destination: URL(string: githubLink)!) {
                    Text("Github")
                    Image(systemName: "arrow.up.forward.app")
                }.padding(.top)

                Spacer()
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left.circle")
                    .font(.system(size: 36))
            }
            .padding(.bottom, 40)
        }
        .accentColor(Color.white)
    }
}

#Preview {
    CreditsView()
}
