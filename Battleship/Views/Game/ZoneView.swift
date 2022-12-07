//
//  ZoneView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI

struct ZoneView: View {
    var currentState: Int
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .strokeBorder((currentState == 1 ? .red : .blue), lineWidth: 2)
                .frame(width: size, height: size)
            
            if currentState == 2 {
                Circle()
                    .fill(.blue)
                    .frame(width: size / 3, height: size / 3)
            }
            else if currentState == 1 {
                XMark()
                    .stroke(.red, lineWidth: 3)
                    .frame(width: size / 2, height: size / 2)
            }
        }
    }
}
