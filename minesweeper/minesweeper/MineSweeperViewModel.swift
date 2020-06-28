//
//  MineSweeperViewModel.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

class MineSweeperViewModel: ObservableObject {
    @Published var game: MineSweeperGame = MineSweeperViewModel.createMineSweeperGame(height: 10, width: 10, numBombs: 20)
    
    private static func createMineSweeperGame(height: Int, width: Int, numBombs: Int) -> MineSweeperGame {
        MineSweeperGame(height: height, width: width, numBombs: numBombs)
    }
        
    // MARK: - Access to the Model
    
    var cells: Array<MineSweeperGame.Cell> {
        return game.cells
    }
    
    var numBombs: Int {
        var num = 0;
        
        for cell in game.cells {
            num += cell.isMine ? 1 : 0
        }
        
        return num
    }
    
    var numFlags: Int {
        var num = 0;
        
        for cell in game.cells {
            if cell.flag != .none && !cell.isRevealed {
                num += 1
            }
        }
        
        return num
    }
    
    var gameWon: Bool {
        // Game is over if only the bombs are flagged
        // or if the max revealed is achieved
        
        var gameOver = true
        var numCorrectFlags = 0
        var numRevealed = 0
        
        for cell in cells {
            if !cell.isRevealed && cell.isMine && cell.flag != .none {
                numCorrectFlags += 1
            }
            if cell.isRevealed {
                numRevealed += 1
            }
        }
        
        if (numCorrectFlags != numFlags) || ((numRevealed + numBombs) != self.game.height * self.game.width) {
            gameOver = false
        }
        
        return gameOver && self.game.playing
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
    
    func resetGame(difficulty: Difficulty) {
        if difficulty == .easy {
            game = MineSweeperViewModel.createMineSweeperGame(height: 7, width: 7, numBombs: 10)
        }
        else if difficulty == .normal {
            game = MineSweeperViewModel.createMineSweeperGame(height: 10, width: 10, numBombs: 20)
        }
        else if difficulty == .expert {
            game = MineSweeperViewModel.createMineSweeperGame(height: 13, width: 13, numBombs: 30)
        }
    }
    
    func revealAllCells() {
        game.revealAllCells()
    }
}

enum Difficulty: Int {
    case easy = 0, normal = 1, expert = 2
}
