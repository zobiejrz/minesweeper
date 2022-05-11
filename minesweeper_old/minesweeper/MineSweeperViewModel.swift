//
//  MineSweeperViewModel.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

class MineSweeperViewModel: ObservableObject {
    @Published var game: MineSweeperGame = MineSweeperViewModel.createMineSweeperGame(for: .normal)
    @Published var currentDifficulty: Difficulty = .normal
    @Published var currentGridSize: (rows: Int, columns: Int) = (rows: 10, columns: 10)
    
    private static func createMineSweeperGame (height: Int, width: Int, numBombs: Int) -> MineSweeperGame {
        MineSweeperGame(height: height, width: width, numBombs: numBombs)
    }
    
    private static func createMineSweeperGame(for difficulty: Difficulty) -> MineSweeperGame {
        if difficulty == .easy {
            return createMineSweeperGame(height: 7, width: 7, numBombs: 10)
        }
        else if difficulty == .normal {
            return createMineSweeperGame(height: 10, width: 10, numBombs: 20)
        }
        else {
            return createMineSweeperGame(height: 13, width: 13, numBombs: 45)
        }
    }
        
    // MARK: - Access to the Model
    
    var cells: Array<MineSweeperGame.Cell> {
        return game.cells
    }
    
    var numBombs: Int {
        game.numBombs
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
    
    func resetGame (difficulty: Difficulty) {
        if difficulty == .easy {
            currentGridSize = (rows: 7, columns: 7)
            game = MineSweeperViewModel.createMineSweeperGame(for: currentDifficulty)
        }
        else if difficulty == .normal {
            currentGridSize = (rows: 10, columns: 10)
            game = MineSweeperViewModel.createMineSweeperGame(for: currentDifficulty)
        }
        else if difficulty == .expert {
            currentGridSize = (rows: 13, columns: 13)
            game = MineSweeperViewModel.createMineSweeperGame(for: currentDifficulty)
        }
    }
    
    func resetGame (rows: Int, columns: Int, numBombs: Int) {
        currentGridSize = (rows: rows, columns: columns)
        game = MineSweeperViewModel.createMineSweeperGame(height: rows, width: columns, numBombs: numBombs)
    }
    
    func restart() {
        resetGame(difficulty: currentDifficulty)
    }
    
    func revealAllCells() {
        game.revealAllCells()
    }
}

enum Difficulty: Int {
    case easy = 0, normal = 1, expert = 2
}
