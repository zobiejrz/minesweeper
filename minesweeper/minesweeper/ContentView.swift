//
//  ContentView.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @State var gridSize : (rows: Int, columns: Int) = (rows: 5, columns: 5)
    var body: some View {
        VStack {
            Grid (viewModel.cells, numRows: gridSize.rows, numColumn: gridSize.columns) { cell in
                CardView(cell: cell).onTapGesture {
                    withAnimation(.linear) {
                        self.viewModel.choose(cell: cell)
                    }
                }
                    .padding(5)
            }
            .foregroundColor(Color.green)
            .padding()
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            })
            {
                Text("New Game")
            }
        }
        .padding()
    }
}

struct CardView: View {
    var cell: MineSweeperGame.Cell
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            if cell.isRevealed{
                Text(self.cell.isMine ? "💣" : "\(self.cell.numAdjacentMines)")
                    .font(Font.system(size: fontSize(for: size)))
            }
        }
        .cardify(isFaceUp: cell.isRevealed)
    }
    // MARK: - Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.7
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MineSweeperViewModel()
        game.choose(cell: game.cells[0])
        return ContentView(viewModel: game)
    }
}
