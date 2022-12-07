//
//  XMark.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI

struct XMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        
        path.move(to: CGPoint(x: rect.width, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height))
        
        path.closeSubpath()
        return path
    }
}
