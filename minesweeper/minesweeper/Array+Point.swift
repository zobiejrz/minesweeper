//
//  Array+Point.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

extension Array where Element == MineSweeperGame.Cell {
    func findIndexOfPoint(_ point: MineSweeperGame.Point) -> Int? {
        for index in 0..<self.count {
            if self[index].location == point {
                return index
            }
        }
        return nil
    }
}
