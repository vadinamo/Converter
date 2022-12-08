//
//  Sound.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import AVFoundation


var player: AVAudioPlayer!

func playSound(soundName: String) {
    let number = Int.random(in: 1...4)
    let url = Bundle.main.url(forResource: soundName + String(number), withExtension: "mp3")
    
    guard url != nil else {
        return
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player?.play()
    } catch {
        print(error)
    }
}
