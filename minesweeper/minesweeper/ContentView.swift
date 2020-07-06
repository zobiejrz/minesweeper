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
    @State var flagMode: Bool = false
    @State var showMenu: Bool = false
    @State var showNewGameView: Bool = false

    
//    var gridSizes: (rows: Int, columns: Int) {
//        if difficulty == .easy {
//            return (rows: 7, columns: 7)
//        }
//        else if difficulty == .normal {
//            return (rows: 10, columns: 10)
//        }
//        else {
//            return (rows: 13, columns: 13)
//        }
//    }
    
    var body: some View {
        ZStack {
            VStack {
                TopBar(viewModel: viewModel, showMenu: $showMenu)
                NewGameView(viewModel: viewModel, showNewGameView: $showNewGameView)
                Spacer()
                Game(viewModel: viewModel)
                Spacer()
            }
            PauseView(viewModel: viewModel, showMenu: $showMenu, showNewGameView: $showNewGameView)
        }
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
                Text(self.cell.isMine ? "💣" : (self.cell.numAdjacentMines != 0 ? "\(self.cell.numAdjacentMines)" : " "))
                    .font(Font.system(size: fontSize(for: size)))
                    .foregroundColor(Color.white)
            }
        }
        .cardify(isFaceUp: cell.isRevealed, flagStyle: cell.flag)
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
        
        return Group {
            ContentView(viewModel: game).previewLayout(.fixed(width: 375, height: 1000))
                                .environment(\.colorScheme, .dark)
            ContentView(viewModel: game).previewLayout(.fixed(width: 375, height: 1000))
                                .environment(\.colorScheme, .light)
        }
    }
}
