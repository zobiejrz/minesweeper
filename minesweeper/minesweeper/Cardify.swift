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
        GeometryReader { geometry in
            ZStack {
                Group {
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: self.edgeLineWidth)
                    content
                }
                .opacity(self.isFaceUp ? 1 : 0)
                Group {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).fill()
                        if self.flagStyle == .flag {
                            Text("🚩")
                                .rotation3DEffect(Angle.degrees(self.rotation), axis: (0, 1, 0))
                                .font(Font.system(size: self.fontSize(for: geometry.size)))
                        }
                        else if self.flagStyle == .question{
                            Text("❓")
                                .rotation3DEffect(Angle.degrees(self.rotation), axis: (0, 1, 0))
                                .font(Font.system(size: self.fontSize(for: geometry.size)))
                        }
                    }
                }
                .opacity(self.isFaceUp ? 0 : 1)
            }
            .rotation3DEffect(Angle.degrees(self.rotation), axis: (0, 1, 0))
        }

    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    
    private let fontScaleFactor: CGFloat = 0.7
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

extension View {
    func cardify(isFaceUp: Bool, flagStyle: MineSweeperGame.Cell.FlagStyle) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, flagStyle: flagStyle))
    }
}
