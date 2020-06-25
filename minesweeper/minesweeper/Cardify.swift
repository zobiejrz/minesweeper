//
//  Cardify.swift
//  memory-game
//
//  Created by Ben Zobrist on 6/11/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation : Double
    var flagStyle: MineSweeperGame.Cell.FlagStyle
    
    init (isFaceUp: Bool, flagStyle flag: MineSweeperGame.Cell.FlagStyle) {
        rotation = isFaceUp ? 0 : 180
        flagStyle = flag
    }
    
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            Group {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill()
                    if flagStyle == .flag {
                        Text("🚩")
                            .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
                    }
                    else if flagStyle == .question{
                        Text("❓")
                            .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
                    }
                }
            }
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))

    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool, flagStyle: MineSweeperGame.Cell.FlagStyle) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, flagStyle: flagStyle))
    }
}
