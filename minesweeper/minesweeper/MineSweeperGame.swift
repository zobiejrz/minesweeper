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
    
    private func getNeighbors(of point: Point) -> [Point] {
        var possibleNeighbors = [Point(x: point.x-1, y: point.y-1),
                                 Point(x: point.x  , y: point.y-1),
                                 Point(x: point.x+1, y: point.y-1),
                                 Point(x: point.x-1, y: point.y),
                                 /*Point(x: point.x  , y: point.y),*/
                                 Point(x: point.x+1, y: point.y),
                                 Point(x: point.x-1, y: point.y+1),
                                 Point(x: point.x  , y: point.y+1),
                                 Point(x: point.x+1, y: point.y+1)]
        
        for candidate in possibleNeighbors {
            if candidate.x < 0 || candidate.y < 0 {
                possibleNeighbors.removeFirstOccurance(of: candidate)
            }
            if candidate.x >= width || candidate.y >= height {
                possibleNeighbors.removeFirstOccurance(of: candidate)
            }
        }
        
        return possibleNeighbors
    }
    
    private mutating func populateBombs() {
        // Generate all the bombs regardless of points
        var numBombsAdded = 0
        while numBombsAdded != numBombs {
            let location = Point.random(maxWidth: width, maxHeight: height)
            let cellAtLocation = cells[(location.y*width)+location.x]
            if !cellAtLocation.isMine {
                cells[(location.y*width)+location.x].isMine = true
                
                let cellNeighbors = getNeighbors(of: location)
                for n in cellNeighbors {
                    let locationOfNeighbor = cells.findIndexOfPoint(n)
                    cells[locationOfNeighbor!].numAdjacentMines += 1
                }
                numBombsAdded += 1
            }
        }
    }
    
    private mutating func populateBombs(excluding cell: Cell) {
        // Generate all the bombs, but prevent the excluded card from being a bomb
        var numBombsAdded = 0
        while numBombsAdded != numBombs {
            let location = Point.random(maxWidth: width, maxHeight: height)
            let cellAtLocation = cells[(location.y*width)+location.x]
            if location != cell.location && !cellAtLocation.isMine {
                cells[(location.y*width)+location.x].isMine = true
                
                let cellNeighbors = getNeighbors(of: location)
                for n in cellNeighbors {
                    let locationOfNeighbor = cells.findIndexOfPoint(n)
                    cells[locationOfNeighbor!].numAdjacentMines += 1
                }
                numBombsAdded += 1
            }
        }
    }
    
    private mutating func revealAllCells() {
        for c in cells {
            let cIndex = cells.findIndexOfPoint(c.location)
            cells[cIndex!].isRevealed = true
        }
    }
    // MARK: - Intents
    
    mutating func choose(cell: Cell) {
        // Populate field as needed
        if !playing {
            populateBombs(excluding: cell)
            playing = true
        }
        let index = cells.firstIndex(matching: cell)
        
        
        // Flip over card
        if cells[index!].isMine { // Flip over ALL cards
            revealAllCells()
        }
        else if !cells[index!].isRevealed { // Flip over selected card
            cells[index!].isRevealed = true
            
            // flip over adjacent cards if current card has no neighboring mines
            let neighbors = getNeighbors(of: cell.location)
            if cells[index!].numAdjacentMines == 0 {
                for n in neighbors {
                    let nIndex = cells.findIndexOfPoint(n)
                    choose(cell: cells[nIndex!])
                }
            }
        }
                
    }
    
    mutating func flag (cell: Cell, with flag: Cell.FlagStyle) {
        // If we flag a cell first, we don't get the knowledge that the cell we picked is safe
        if !playing {
            populateBombs()
            playing = true
        }
        
        let indexOfCell = cells.firstIndex(matching: cell)
        
        if cell.flag != flag {
            cells[indexOfCell!].flag = flag
        }
    }
    
    struct Cell: Identifiable {
        var id: Int
        var location: Point
        var isRevealed: Bool = false
        var numAdjacentMines: Int = 0
        var isMine: Bool = false
        var flag: FlagStyle = .none
        
        enum FlagStyle { case flag, question, none }
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
