//
//  CardCircle.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 09/11/25.
//

import SwiftUI

struct CardCircleView: View {
    let card: CardCircle
    
    var body: some View {
        ZStack {
            if card.isRevealed {
                Circle()
                    .overlay(
                        Image(card.imageName)
                            .memoImageBadkidStyle(size: 100)
                    )
            } else {
                Circle()
                    .fill(Color.blue)
                    .overlay(
                        Image("badKid")
                            .memoImageBadkidStyle(size: 100)
                    )
            }
        }
        .frame(width: 100, height: 100)
        .rotation3DEffect(
            .degrees(card.isRevealed ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.4), value: card.isRevealed)
    }
}

#Preview {
    var button = CardCircle(imageName: "badKid")
    CardCircleView(card: button)
}
