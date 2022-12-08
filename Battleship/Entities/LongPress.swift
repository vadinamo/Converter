//
//  LongPress.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI


struct LongPress: View {
    @State private var timer: Timer?
    @State var isLongPressing = false
    
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        Button(action: {
            if(self.isLongPressing) {
                //this tap was caused by the end of a longpress gesture, so stop our fastforwarding
                self.isLongPressing.toggle()
                self.timer?.invalidate()
                
            } else {
                //just a regular tap
                action()
                
            }
        }, label: {
            Image(systemName: imageName)
                .font(.system(size: CGFloat(60)))
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
        })
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
            self.isLongPressing = true
            //or fastforward has started to start the timer
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                action()
            })
        })
        .buttonStyle(PlainButtonStyle())
    }
}
