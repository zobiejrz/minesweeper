//
//  Array+Remove.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/21/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeFirstOccurance(of k: Element) {
        for i in 0..<self.count {
            if self[i] == k {
                self.remove(at: i)
                return
            }
        }
    }
}
