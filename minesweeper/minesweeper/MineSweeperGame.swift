//
//  MineSweeperGame.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

struct MineSweeperGame {
    
    private(set) var cells: Array<Cell>
    
    private(set) var playing: Bool = false
    private(set) var height: Int
    private(set) var width: Int
    private(set) var numBombs: Int
    
    init (height: Int, width: Int, numBombs: Int) {
        self.height = height
        self.width = width
        self.numBombs = numBombs
        
        // Generate all the cells but no bombs
        cells = Array<Cell>()
        for y in 0..<width {
            for x in 0..<height {
                cells.append(Cell(id: (y*width)+x, location: Point(x: x, y: y)))
            }
        }
        
    }
    
    // MARK: - Intents
    mutating func populateBombs(excluding cell: Cell) {
        // Generate all the bombs, but prevent the excluded card from being a bomb
        var numBombsAdded = 0
        while numBombsAdded != numBombs {
            let location = Point.random(maxWidth: width, maxHeight: height)
            let cellAtLocation = cells[(location.y*width)+location.x]
            if location != cell.location && !cellAtLocation.isMine {
                cells[(location.y*width)+location.x].isMine = true
                numBombsAdded += 1
            }
        }
    }
    
    mutating func choose(cell: Cell) {
        // Populate field as needed
        if !playing {
            populateBombs(excluding: cell)
        }
        
        // Flip over card
        if !cell.isRevealed {
            let index = cells.firstIndex(matching: cell)
            cells[index!].isRevealed = true
        }
        
        // MARK: TODO: Flip over adjacent cards if we don't have neighbors
        
    }
    
    struct Cell: Identifiable {
        var id: Int
        var location: Point
        var isRevealed: Bool = true
        var numAdjacentMines: Int = 0
        var isMine: Bool = false
    }
    
    struct Point: Equatable {
        var x: Int
        var y: Int
        
        public static func random(maxWidth: Int, maxHeight: Int) -> Point {
            let randX = Int.random(in: 0..<maxWidth)
            let randY = Int.random(in: 0..<maxHeight)
            return Point(x: randX, y: randY)
        }
    }
}
