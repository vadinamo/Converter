//
//  Preparation.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI


struct Preparation: View {
    private var field: [[Int]] { // 0 - none, 1 - hit, 2 - miss
        var result = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
        
        for ship in currentShips {
            for cell in ship.cells {
                result[cell.i][cell.j] += 1
            }
        }
        
        return result
    }
    
    @State private var ships: [Int: Int] = [
        1: 4,
        2: 3,
        3: 2,
        4: 1
    ]
    
    @State private var currentShips: [Ship] = []
    @State private var pickedShip: Ship = Ship(count: 0, cells: [])
    
    @State private var playerReady: Bool = false
    @State private var opponentReady: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                Text("Arrange your ships")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Button(action: {
                    
                }, label: {
                    Spacer()
                    Text("Ready")
                    Spacer()
                })
                .buttonStyle(.borderedProminent)
            }
            
            YourField
            
            Spacer()
            
            HStack {
                RemainingShips
                Spacer()
                MovementButtons
            }
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    var YourField: some View {
        VStack {
            ForEach(0...9, id: \.self) {i in
                HStack {
                    ForEach(0...9, id: \.self) { j in
                        ZStack {
                            if field[i][j] > 1 {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: 25, height: 25)
                            }
                            else if pickedShip.cells.contains(where: { $0.i == i && $0.j == j }) {
                                Rectangle()
                                    .fill(.green)
                                    .frame(width: 25, height: 25)
                            }
                            else if field[i][j] == 1 {
                                Rectangle()
                                    .fill(.yellow)
                                    .frame(width: 25, height: 25)
                            }
                            Rectangle()
                                .strokeBorder(.blue, lineWidth: 2)
                                .frame(width: 25, height: 25)
                        }
                        .onTapGesture {
                            pickedShip = currentShips.last(where: { $0.cells.contains(where: {$0.i == i && $0.j == j})}) ?? Ship(count: 0, cells:[])
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var RemainingShips: some View {
        VStack {
            ForEach(ships.sorted(by: <), id: \.key) { ship in
                Divider()
                Button(action: {
                    if ships[ship.key]! > 0 {
                        self.pickedShip = Ship(count: ship.key, cells: fillCells(count: ship.key))
                        currentShips.append(pickedShip)
                        self.ships[ship.key]! -= 1
                    }
                }, label: {
                    HStack {
                        ForEach(0..<Int(ship.key), id: \.self) { _ in
                            ZStack {
                                Rectangle()
                                    .fill(.yellow)
                                    .frame(width: 30, height: 30)
                                Rectangle()
                                    .strokeBorder(.blue, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        Spacer()
                        Text("x\(ship.value)")
                    }
                })
                Divider()
            }
        }
    }
    
    @ViewBuilder
    var MovementButtons: some View {
        VStack {
            Spacer()
            HStack {
                LongPress(action: {
                    let index = findIndex()
                    if index >= 0 {
                        pickedShip = Ship(count: pickedShip.count, cells: moveCells(cells: pickedShip.cells, iMove: 0, jMove: -1))
                        self.currentShips[index] = pickedShip
                    }
                }, imageName: "arrowtriangle.left.fill")
                VStack {
                    LongPress(action: {
                        let index = findIndex()
                        if index >= 0 {
                            pickedShip = Ship(count: pickedShip.count, cells: moveCells(cells: pickedShip.cells, iMove: -1, jMove: 0))
                            self.currentShips[index] = pickedShip
                        }
                    }, imageName: "arrowtriangle.up.fill")
                    LongPress(action: {
                        let index = findIndex()
                        if index >= 0 {
                            pickedShip = Ship(count: pickedShip.count, cells: moveCells(cells: pickedShip.cells, iMove: 1, jMove: 0))
                            self.currentShips[index] = pickedShip
                        }
                    }, imageName: "arrowtriangle.down.fill")
                }
                LongPress(action: {
                    let index = findIndex()
                    if index >= 0 {
                        pickedShip = Ship(count: pickedShip.count, cells: moveCells(cells: pickedShip.cells, iMove: 0, jMove: 1))
                        self.currentShips[index] = pickedShip
                    }
                }, imageName: "arrowtriangle.right.fill")
            }
            Spacer()
            HStack {
                Spacer()
                LongPress(action: {
                    let index = findIndex()
                    if index >= 0 {
                        pickedShip = Ship(count: pickedShip.count, cells: rotateCells(cells: pickedShip.cells, iMove: 0, jMove: 1, direction: "l"))
                        self.currentShips[index] = pickedShip
                    }
                }, imageName: "arrow.counterclockwise")
                Spacer()
                LongPress(action: {
                    let index = findIndex()
                    if index >= 0 {
                        pickedShip = Ship(count: pickedShip.count, cells: rotateCells(cells: pickedShip.cells, iMove: 0, jMove: 1, direction: "r"))
                        self.currentShips[index] = pickedShip
                    }
                }, imageName: "arrow.clockwise")
                Spacer()
            }
            Spacer()
        }
    }
    
    func findIndex() -> Int {
        for i in 0..<currentShips.count {
            if currentShips[i].count != pickedShip.count {
                continue
            }
            var check = true
            for j in 0..<currentShips[i].cells.count {
                if currentShips[i].cells[j].i != pickedShip.cells[j].i ||
                    currentShips[i].cells[j].j != pickedShip.cells[j].j {
                    check = false
                }
            }
            
            if check {
                return i
            }
        }
        return -1
    }
}
