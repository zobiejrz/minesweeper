//
//  MineSweeperViewModel.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

class MineSweeperViewModel: ObservableObject {
    @Published var game: MineSweeperGame = MineSweeperViewModel.createMineSweeperGame(height: 15, width: 15, numBombs: 45)
    
    private static func createMineSweeperGame(height: Int, width: Int, numBombs: Int) -> MineSweeperGame {
        MineSweeperGame(height: height, width: width, numBombs: numBombs)
    }
        
    // MARK: - Access to the Model
    
    var cells: Array<MineSweeperGame.Cell> {
        return game.cells
    }
    
    // MARK: - Intents
    
    func choose(cell: MineSweeperGame.Cell) {
        print(cell)
        game.choose(cell: cell)
    }
    
    func flag (cell: MineSweeperGame.Cell) {
        print(cell)
        
        var flag: MineSweeperGame.Cell.FlagStyle = cell.flag
        
        if (flag == .none) {
            flag = .flag
        }
        else if (flag == .flag) {
            flag = .question
        }
        else {
            flag = .none
        }
        
        game.flag(cell: cell, with: flag)
    }
    
    func resetGame() {
        game = MineSweeperViewModel.createMineSweeperGame(height: 15, width: 15, numBombs: 45)
    }
}
