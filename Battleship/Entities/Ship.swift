//
//  Ship.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI


struct Cell {
    var i: Int
    var j: Int
}


struct Ship {
    var count: Int
    var cells: [Cell]
    
    init(count: Int, cells: [Cell]) {
        self.count = count
        self.cells = cells
    }
    
    func compareCells(cellsToCheck: [Cell]) -> Bool {
        if cellsToCheck.count != cells.count {
            return false
        }
        
        for i in 0..<cells.count {
            if cellsToCheck[i].i != cells[i].i || cellsToCheck[i].j != cells[i].j {
                return false
            }
        }
            
        return true
    }
}

func fillCells(count: Int) -> [Cell] {
    var cells: [Cell] = []
    for i in 0..<count {
        cells.append(Cell(i: 0, j: i))
    }
    
    return cells
}

func moveCells(cells: [Cell], iMove: Int, jMove: Int) -> [Cell] {
    if cells.count == 0 {
        return cells
    }
    
    var newCells: [Cell] = []
    for cell in cells {
        let newI = cell.i + iMove
        let newJ = cell.j + jMove
        if newI > 9 || newI < 0 || newJ > 9 || newJ < 0 {
            return cells
        }
        
        newCells.append(Cell(i: newI, j: newJ))
    }
    
    return newCells
}

func rotateCells(cells: [Cell], iMove: Int, jMove: Int, direction: String) -> [Cell] {
    if cells.count == 0 || cells.count == 1 {
        return cells
    }
    
    let middle: Int = cells.count / 2
    let mainI = cells[middle].i
    let mainJ = cells[middle].j
    
    var difference: [Cell] = []
    for cell in cells {
        difference.append(Cell(i: cell.i - mainI, j: cell.j - mainJ))
    }
    
    var newCells: [Cell] = []
    for i in 0..<cells.count {
        var newI = cells[middle].i + difference[i].j
        var newJ = cells[middle].j - difference[i].i
        if direction == "l" {
            newI = cells[middle].i - difference[i].j
            newJ = cells[middle].j + difference[i].i
        }
        
        if newI > 9 || newI < 0 || newJ > 9 || newJ < 0 {
            return cells
        }
        newCells.append(Cell(i: newI, j: newJ))
    }
    return newCells
}
