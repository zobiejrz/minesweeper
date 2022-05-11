//
//  GridLayout.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/24/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import SwiftUI

struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0
    
    init(itemCount: Int, numRows rows: Int, numColumns cols: Int, in size: CGSize) {
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard itemCount > 0 else { return }
        
        // We already know how many rows/columns there needs to be, so extra
        // math is not needed to calculate it
        rowCount = rows
        columnCount = cols
    }
    
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            let sideLength = min(size.width / CGFloat(columnCount), size.height / CGFloat(rowCount))
            return CGSize(
                width: sideLength,
                height: sideLength
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

